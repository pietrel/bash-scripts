#!/bin/bash

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <input_image> <rows> <columns> <result_dir>"
  exit 1
fi

input_image=$1
rows=$2    
columns=$3 
output_prefix=$4
result_dir=$5

mkdir -p "$result_dir"

image_info=$(magick identify -format "%w %h" "$input_image")
image_width=$(echo $image_info | cut -d ' ' -f 1)
image_height=$(echo $image_info | cut -d ' ' -f 2)

echo "${image_width}x${image_height}"

slice_size_width=$((image_width / columns))
slice_size_height=$((image_height / rows))
slice_size=$(( slice_size_width < slice_size_height ? slice_size_width : slice_size_height ))

new_width=$((slice_size * columns))
new_height=$((slice_size * rows))

echo "resize image to ${new_width}x${new_height} to fit ${rows}x${columns} square slices of size ${slice_size}x${slice_size}"

magick convert "$input_image" -resize ${new_width}x${new_height}^ -gravity center -extent ${new_width}x${new_height} "${result_dir}/resized_image.png"

magick convert "${result_dir}/resized_image.png" -crop ${slice_size}x${slice_size} +repage +adjoin "${result_dir}/result_%d.png"

echo "image successfully resized and sliced"
