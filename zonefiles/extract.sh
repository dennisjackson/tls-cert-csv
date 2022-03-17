ZIPPED=$1 
UNZIPPED=${ZIPPED//".gz"/""}
OUTPUT=$UNZIPPED".txt"
# Extract
gzip -dk $ZIPPED
# RegExp 
rg "^\S+" -o -N $UNZIPPED > $OUTPUT
# Delete extraction 
rm $UNZIPPED