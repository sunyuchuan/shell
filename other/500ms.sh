#!/bin/bash

if [ ! -d "output" ]; then
    mkdir output
fi

ffmpeg -threads 2 -nostats -i $1 \
    -c:v libx264 -vf "fps=25" -strict -2 -flags -global_header -force_key_frames "expr:gte(t,n_forced*0.5)" -sc_threshold 0 -bf 2 -b_strategy 0 -threads 16 \
    -c:a libfdk_aac -ab 128k -ac 2 -ar 44100 \
    -f mp4 output/$1_output.mp4 \
