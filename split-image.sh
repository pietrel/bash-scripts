#!/bin/bash

# Check if $2 is provided
if [[ -z "$3" ]]; then
  echo "Usage: $0 <file> <number of column slices> <number of row slices>"
  exit 1
fi

width=$(identify -format "%w" $1)
part_width=$((width / $2))

height=$(identify -format "%h" $1)
part_height=$((height / $3))

for j in $(seq 0 $(($3-1))); do
    rowling=row$j.png
    # TODO make only square slices
    magick $1 -crop x${part_height}+0+$((j * part_height)) $rowling
    for i in $(seq 0 $(($2-1))); do
        magick $rowling -crop ${part_width}x+$((i * part_width))+0 part_$((i+1))_$((j + 1)).png
    done
    rm $rowling
done
