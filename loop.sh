while true; do
    echo "### censys:"
    ./generate.sh lists/latest-censys.txt html/censys
    echo "### gosuslugi:"
    ./generate.sh lists/latest-gosuslugi.txt html/gosuslugi
    echo "### tranco:"
    ./generate.sh lists/tranco_russia_10k.txt html/tranco
    sleep 3600
done