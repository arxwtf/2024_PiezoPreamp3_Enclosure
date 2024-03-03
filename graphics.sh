ALL_SIDES=(\
 "TOP" \
 "BOTTOM" \
 "RIGHT" \
 "LEFT" \
 "FRONT" \
 "BACK" \
)

while getopts s:dh flag
do
    case "${flag}" in
        s) SIDE=${OPTARG};;
        h) echo "Use -s to specify single side whose PDF will be processed";;
    esac
done


# if no side is specified, process all sides
SIDES=("${SIDE:-${ALL_SIDES[@]}}")

# output folder that will contain .jpg created from .pdfs generated by board2pdf plugin
mkdir -p graphics

for BOARD in ${SIDES[@]}
do
    echo ""
    echo "[$BOARD] Converting build/$BOARD/$BOARD\__Assembly.pdf to graphics/$BOARD-plain.jpg"
    echo "\033[32mconvert -density 600 -trim build/$BOARD/$BOARD\__Assembly.pdf -quality 95 graphics/$BOARD\_plain.jpg \033[91m"

    convert -density 600 -trim build/$BOARD/$BOARD\__Assembly.pdf -quality 95 graphics/$BOARD\_plain.jpg

    echo "\033[0m"
    echo "[$BOARD] Converted."
    echo ""

    echo "\033[0m--------------------------------------------------------------------------------------------------------------------------------"
done