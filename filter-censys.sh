OUTDIR="lists"
PREFIX=`date +\%d\%m\%y-\%H\%M-censys`
FILTERED_LIST="$OUTDIR/$PREFIX.txt" 
LATEST="$OUTDIR/latest-censys.txt"
TEMP="filtered.txt"
cat $1 | jq -r '[ .results | map( [.parsed | .names ] ) | flatten(2) | .[]  ]' | \
    sed "s/\"//g"  | sed "s/null,//" | sed "s/,//" | sed "s/\[//" | sed "s/\]//" | \
    sed "s/\*.//" | \
    tr -d " " | \
    tr '[:upper:]' '[:lower:]' | \
    awk 'NF' | \
    sort | \
    uniq > $TEMP 

cp $TEMP $LATEST
cp $TEMP $FILTERED_LIST

git add $1
git add $LATEST
git add $FILTERED_LIST
rm $TEMP 

#git commit -m "Update to latest censys list for `date +\%d-\%m-\%y`"

 