SOURCE_BOARD="2024_PiezoPreamp3_Enclosure"

FAB=jlcpcb

ALL_SIDES=(\
 "TOP" \
 "RIGHT" \
 "LEFT" \
)

DEBUG=""

while getopts s:dh flag
do
    case "${flag}" in
        s) SIDE=${OPTARG};;
        d) DEBUG=" --debug ";;
        h) echo "Use -s to specify which side to build. Use -d to enable debug";;
    esac
done

# if no side is specified, build all sides
SIDES=("${SIDE:-${ALL_SIDES[@]}}")

# final output folder that will contain zipped gerbers ready to upload to the PCB manufacturer
mkdir -p upload

for BOARD in ${SIDES[@]}
do
    # separating
    echo ""
    echo "[$BOARD] Separating board from $SOURCE_BOARD.kicad_pcb to build/$BOARD/$BOARD.kicad_pcb"
    echo "\033[32mkikit separate --looseArcs --source \"annotation; ref: $BOARD\" $SOURCE_BOARD.kicad_pcb build/$BOARD/$BOARD.kicad_pcb \033[91m"

    mkdir -p build/$BOARD
    kikit separate --looseArcs --source "annotation; ref: $BOARD" $SOURCE_BOARD.kicad_pcb build/$BOARD/$BOARD.kicad_pcb

    echo "\033[0m"
    echo "[$BOARD] Separation ended."
    echo ""

    # move board2pdf config to newly created $BOARD folder
    cp board2pdf-configs/$BOARD.board2pdf.config.ini build/$BOARD/board2pdf.config.ini

    # fabricating
    echo "[$BOARD] Fabricating gerbers and drill files to build/$BOARD/"
    echo "\033[32mkikit fab $FAB$DEBUG build/$BOARD/$BOARD.kicad_pcb build/$BOARD/ \033[91m"

    #mkdir -p build/$BOARD/production
    kikit fab $FAB$DEBUG build/$BOARD/$BOARD.kicad_pcb build/$BOARD/
    
    echo "\033[0m"
    echo "[$BOARD] Fabrication ended."
    
    # moving gerbers to upload folder
    echo "\033[91m" 
    mv build/$BOARD/gerbers.zip upload/$BOARD-gerbers.zip


    echo "\033[0m--------------------------------------------------------------------------------------------------------------------------------"
done
