#!/bin/bash

#echo "USAGE: $0 input_audio output_audio target_LUFS, exit"

input=$1
output=$2
target_LUFS=$3

function getLoudness()
{
    result=`ffmpeg -i $1 -af ebur128=framelog=verbose -f null /dev/null 2>&1`
    tmp=${result#*I\:}
    ret=${tmp%%LUFS*}

    echo $ret
}

function loudnorm_ebur128()
{
    loudness=$(getLoudness $1)
    gain="$(echo "($target_LUFS)-($loudness)" | bc | awk '{printf "%.3f", $0}')dB"
    ffmpeg -y -i $1 -vn -sn -filter_complex "[0:a]alimiter=level_in=$gain:limit=-1dB:level=disabled[out]" -map "[out]" -c:a libmp3lame -ac 2 -ar 44100 -b:a 128k -f mp3 -y $2 1>/dev/null 2>/dev/null
}

loudnorm_ebur128 $input $output

