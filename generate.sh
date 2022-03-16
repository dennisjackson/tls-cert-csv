TLSSCAN="./tls-scan"
JQ="jq"
DOMAINS=${1:-"domains.txt"}
FIELDS=".subject, .issuer, .notBefore, .notAfter, .basicConstraints, .sha1Fingerprint"
OUTDIR=${2:-"out/"`date +\%d\%m\%y-\%H\%M`}

if [[ ! -f $TLSSCAN ]] 
then
    echo "No TLS-Scan binary at $TLSSCAN."
    exit -1
fi

if [ ! type "$JQ" &> /dev/null ]; then
    echo "No jq binary at $JQ."
    exit -1
fi

if [ ! -f "$DOMAINS" ]; then
    echo "No domains list at $DOMAINS"
    exit -1
fi

rm -r $OUTDIR 2&>/dev/null; mkdir $OUTDIR

ERRORS="$OUTDIR/errors.txt"
RAW="$OUTDIR/raw_data.json"

echo "Fetching results, this may take a while..."
# Fetch Results
cat $DOMAINS | $TLSSCAN --port=443 --pretty 2>$ERRORS 1>$RAW
tail -n 14 $ERRORS

echo ""
echo "Extracting fields of interest to CSV format"


HEADER="host, $FIELDS"
HEADER=${HEADER//"."/""}
echo "Fields: $HEADER"

ALL="$OUTDIR/all.csv"
ROOTS="$OUTDIR/roots.csv"
RUSSIA="$OUTDIR/russia.csv"

echo $HEADER > $ALL
echo $HEADER > $ROOTS
echo $HEADER > $RUSSIA

# All Certificates
cat $RAW | jq -r '[ [.host] + (.certificateChain | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $ALL
# All roots 
cat $RAW | jq -r '[ [.host] +  (.certificateChain | map(select((.basicConstraints | test ("CA:TRUE")))) | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $ROOTS
# All issued by Russia 
cat $RAW | jq -r '[ [.host] +  (.certificateChain | map(select(.issuer | test ("The Ministry of Digital Development and Communications"))) | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $RUSSIA

echo ""
echo "Output:"
echo $ALL
echo $ROOTS
echo $RUSSIA 
echo ""
echo "Working State:"
echo  $ERRORS
echo $RAW