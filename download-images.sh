#!/usr/bin/env bash

# [[file:~/prg/org/hadoop-images/TODO.org::*Streaming][Streaming:1]]

while read url; do
    # echo $url >&2
    size=$(curl -s -D - -o /dev/null "$url" | \
        grep -i content-length | \
        cut -d ' ' -f 2)
    echo "$(date +%s) ${1} ${size:-0}"
done

# Streaming:1 ends here
