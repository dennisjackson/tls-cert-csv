TLSSCAN="./tls-scan"
JQ="jq"
ZIP="zip"
DOMAINS=${1:-"domains.txt"}
FIELDS=".subject, .issuer, .notBefore, .notAfter, .basicConstraints, .sha1Fingerprint"
OUTDIR=${FOODBAR:-"$2/"`date +\%d\%m\%y-\%H\%M`} #Super hacky. Fix.

if [[ ! -f $TLSSCAN ]] 
then
    echo "No TLS-Scan binary at $TLSSCAN."
    exit -1
fi

if [ ! type "$JQ" &> /dev/null ]; then
    echo "No jq binary at $JQ."
    exit -1
fi

if [ ! type "$ZIP" &> /dev/null ]; then
    echo "No zip binary at $ZIP."
    exit -1
fi

if [ ! -f "$DOMAINS" ]; then
    echo "No domains list at $DOMAINS"
    exit -1
fi

rm -r $OUTDIR 2&>/dev/null; mkdir -p $OUTDIR

ERRORS="$OUTDIR/errors.txt"
RAW="$OUTDIR/raw_data.json"

echo "Fetching results, this may take a while..."
# Fetch Results
cat $DOMAINS | $TLSSCAN --port=443 --concurrency=1000 2>$ERRORS 1>$RAW
tail -n 14 $ERRORS

echo ""
echo "Extracting fields of interest to CSV format"


HEADER="host, $FIELDS"
HEADER=${HEADER//"."/""}
echo "Fields: $HEADER"

#ALL="$OUTDIR/all.csv"
#ROOTS="$OUTDIR/roots.csv"
RUSSIA="$OUTDIR/russia.csv"

#echo $HEADER > $ALL
#echo $HEADER > $ROOTS
echo $HEADER > $RUSSIA


FILTERED="filtered".json
grep -v "x509ChainDepth\": -1" $RAW > $FILTERED

# All Certificates
#cat $RAW | jq -r '[ [.host] + (.certificateChain | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $ALL
# All roots 
#cat $RAW | jq -r '[ [.host] +  (.certificateChain | map(select((.basicConstraints | test ("CA:TRUE")))) | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $ROOTS
# All issued by Russia 
cat $FILTERED | jq -r '[ [.host] +  (.certificateChain | map(select(.issuer | test ("The Ministry of Digital Development and Communications"))) | map(['"$FIELDS"']) | .[])] | .[]  | @csv' \
                | xsv search -i -v -s 2 "The Ministry of Digital Development and Communications" >> $RUSSIA

ZIPNAME="$OUTDIR/raw.zip"
$ZIP --junk-paths $ZIPNAME $RAW $ERRORS $DOMAINS 
rm $RAW
rm $ERRORS
rm $FILTERED

echo ""
echo "Output:"
#echo $ALL
#echo $ROOTS
echo $RUSSIA 
echo ""
echo "Working State:"
echo $ZIPNAME

LATEST="$2/latest"
rm -r $LATEST 2&>/dev/null; mkdir $LATEST
cp -r $OUTDIR/* $LATEST