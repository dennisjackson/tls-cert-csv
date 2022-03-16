TLSSCAN="./tls-scan"
JQ="jq"
DOMAINS="russia-tls-list-150322.txt"
FIELDS=".subject, .issuer, .notBefore, .notAfter, .basicConstraints, .sha1Fingerprint"

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

echo "Fetching results, this may take a while..."
# Fetch Results
cat $DOMAINS | $TLSSCAN --port=443 --pretty 2>errors.txt 1>raw_data.json
tail -n 14 errors.txt

echo ""
echo "Extracting fields of interest to CSV format"


HEADER="host, $FIELDS"
HEADER=${HEADER//"."/""}
echo "Fields: $HEADER"

ALL="all.csv"
ROOTS="roots.csv"
RUSSIA="russia.csv"

echo $HEADER > $ALL
echo $HEADER > $ROOTS
echo $HEADER > $RUSSIA

# All Certificates
cat raw_data.json | jq -r '[ [.host] + (.certificateChain | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $ALL
# All roots 
cat raw_data.json | jq -r '[ [.host] +  (.certificateChain | map(select((.basicConstraints | test ("CA:TRUE")))) | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $ROOTS
# All issued by Russia 
cat raw_data.json | jq -r '[ [.host] +  (.certificateChain | map(select(.issuer | test ("The Ministry of Digital Development and Communications"))) | map(['"$FIELDS"']) | .[])] | .[]  | @csv' >> $RUSSIA

echo ""
echo "Output:"
echo $ALL
echo $ROOTS
echo $RUSSIA 
echo ""
echo "Working State:"
echo "errors.txt"
echo "raw_data.json"