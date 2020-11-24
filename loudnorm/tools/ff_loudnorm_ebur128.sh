#!/bin/bash

start=`date +%s`

echo "ebur128 example: $0 input_dir output_dir target_LUFS"
if [ $# != 3 ] ; then
echo "USAGE: $0 input_dir output_dir target_LUFS, exit"
exit 1;
fi

in_path=`realpath "$1"`
if [ ! -d "$in_path" ];then
echo "USAGE: $1 nonexist, exit"
exit 1;
fi

out_path=`realpath "$2"`
if [ ! -d "$out_path" ];then
    mkdir -p "$out_path"
fi

target_LUFS=$3

function getLoudness()
{
    result=`ffmpeg -i "$1" -af ebur128=framelog=verbose -f null /dev/null 2>&1`
    tmp=${result#*I\:}
    ret=${tmp%%LUFS*}

    echo $ret
}

function loudnorm()
{
    for file in "$1"/*; do
        file_basename=$(basename "$file")
        if [ -d "$file" ]; then
            if [ ! -d "$2/$file_basename" ]; then
                mkdir -m 777 "$2/$file_basename"
            fi
            loudnorm "$file" "$2/$file_basename"
        else
            if [ "${file##*.}"x = "mp3"x ]||[ "${file##*.}"x = "MP3"x ] ||
               [ "${file##*.}"x = "mp4"x ]||[ "${file##*.}"x = "MP4"x ] ||
               [ "${file##*.}"x = "m4a"x ]||[ "${file##*.}"x = "M4A"x ] ||
               [ "${file##*.}"x = "aac"x ]||[ "${file##*.}"x = "AAC"x ] ||
               [ "${file##*.}"x = "wav"x ]||[ "${file##*.}"x = "WAV"x ]
            then
                start=`date +%s`

                loudness=$(getLoudness "$file")
                gain="$(echo "($target_LUFS)-($loudness)" | bc | awk '{printf "%.3f", $0}')dB"

                filename=$(echo "$file_basename" | cut -d . -f1)
                ffmpeg -i "$file" -filter_complex "[0:a]alimiter=level_in=$gain:level_out=1:limit=-1dB:attack=5:release=200:level=disabled[out]" -map "[out]" -y "$2/$filename.wav" 1>/dev/null 2>/dev/null

                end=`date +%s`
                dif=$[ end - start ]
                echo "ebur128 file name ---> $file gain: $gain cost time $dif sec"
            fi
        fi
    done
}

loudnorm "$in_path" "$out_path"
