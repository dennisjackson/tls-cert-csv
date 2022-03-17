while true; do
    ./generate.sh zonefiles/rf.txt html/rf
    ./generate.sh zonefiles/su.txt html/su
    ./generate.sh zonefiles/ru.txt html/ru
    sleep $(( $(date -f - +%s- <<< "tomorrow 01:00"$'\nnow') 0 ))
done