# Goslugi
OUTDIR="lists"
PREFIX=`date +\%d\%m\%y-\%H\%M-gosuslugi`
RAW_NEW_LIST="$OUTDIR/$PREFIX-raw.txt"
FILTERED_LIST="$OUTDIR/$PREFIX.txt" 
LATEST="$OUTDIR/latest-gosuslugi.txt"
# We get the published list via Google Sheets to avoid a bot-filter on the TLS Handshake 
curl -L "https://docs.google.com/spreadsheets/d/e/2PACX-1vR-VZVR0caI9nsrJAo8irDLXNcDYdroot9FWDG4KyhJgi1kV9ie7xqR8_t5vU_m_A-iuJ06j7Ei3M0e/pub?gid=1158342695&single=true&output=csv" > $RAW_NEW_LIST

# Filter out the bad characters - Space, Non-ASCII, Brackets. 
iconv -c -f utf-8 -t ascii $RAW_NEW_LIST | sed 's/\*\.//' | sed 's/ //g'  \
                                         | sed 's/[^a-zA-Z0-9\.\-]//g' | sed -E 's/^[^a-zA-Z0-9]+//' \
                                         | sed -E 's/\.+$//' | sort | uniq > $FILTERED_LIST
git add $RAW_NEW_LIST
git add $FILTERED_LIST  

cp $FILTERED_LIST $LATEST
git add $LATEST 

#TODO
git commit -m "Update to latest gosuslugi list for `date +\%d-\%m-\%y`"