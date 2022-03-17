while true; do
    echo "### censys:"
    ./generate.sh lists/latest-censys.txt html/censys
    echo "### gosuslugi:"
    ./generate.sh lists/latest-gosuslugi.txt html/gosuslugi
    echo "### bespoke:"
    ./generate.sh lists/latest-bespoke.txt html/bespoke
    echo "### tranco10k:"
    ./generate.sh lists/tranco_russia_10k.txt html/tranco_10k
    echo "### tranco100k:"
    ./generate.sh lists/tranco_russia_100k.txt html/tranco_100k
    sleep 3600
done