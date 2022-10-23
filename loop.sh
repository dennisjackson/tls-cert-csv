while true; do
    git pull
    echo "### censys:"
    ./generate.sh lists/latest-censys.txt html/censys
    echo "### gosuslugi:"
    ./generate.sh lists/latest-gosuslugi.txt html/gosuslugi
    echo "### bespoke:"
    ./generate.sh lists/latest-bespoke.txt html/bespoke
    echo "### selected-entities:"
    ./generate.sh lists/latest-selected-entities.txt html/selected_entities
    echo "### tranco-10k:"
    ./generate.sh lists/tranco_russia_10k.txt html/tranco_10k
    echo "### tranco-100k:"
    ./generate.sh lists/tranco_russia_100k.txt html/tranco_100k
    echo "### tranco-all:"
    ./generate.sh lists/tranco_russia_all.txt html/tranco_all
    sleep 3600
done