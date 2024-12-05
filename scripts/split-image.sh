#!/bin/bash

if [[ -z "$2" ]]; then
  echo "Usage: $0 <file> <number of slices>"
  exit 1
fi

width=$(identify -format "%w" $1)

part_width=$((width / $2))

for i in $(seq 0 $(($2-1))); do
  magick $1 -crop ${part_width}x+$((i * part_width))+0 part$((i + 1)).png
done
