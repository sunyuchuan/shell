#!/bin/bash

#echo "USAGE: $0 input_concat_file output_audio, exit"

input=$1
output=$2

ffmpeg -f concat -i $input -vn -sn -c:a copy -f mp3 -y $output

