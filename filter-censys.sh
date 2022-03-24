cat $1 | jq -r '[ .results | map( [.parsed | .names ] ) | flatten(2) | .[]  ]' | \
    sed "s/\"//g"  | sed "s/null,//" | sed "s/,//" | sed "s/\[//" | sed "s/\]//" | \
    sed "s/\*.//" | \
    tr '[:upper:]' '[:lower:]' | \
    awk 'NF' | \
    uniq
