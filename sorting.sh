#!/bin/bash

mkdir -p ./unsorted

for index in $(seq 1 10); do
    hash=$(echo -n "$hash" | sha256sum | awk '{print $1}')
    echo $hash > ./unsorted/$hash.txt
done

mkdir -p ./sorted

for file in ./unsorted/*.txt; do
    
    #get create date
    dateToParse=$(stat --printf="%w" "$file")

    # fallback on mod date
    if [[ -z "$dateToParse" || "$dateToParse" == "-" ]]; then
        dateToParse=$(stat --printf="%y" "$file")
    fi

    dateParsed=$(date -d "$dateToParse" +"%Y-%m-%d")

    mkdir -p ./sorted/$dateParsed
    mv $file ./sorted/$dateParsed
done
