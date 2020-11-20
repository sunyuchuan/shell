#!/bin/bash

start=`date +%s`

echo "example: $0 input_dir output_dir"

in_path=`realpath $1`
if [ ! -d $in_path ];then
echo "USAGE: $1 nonexist, exit"
exit 1;
fi

out_path=$2
if [ ! -d $out_path ];then
    mkdir -p $out_path
fi
out_path=`realpath $out_path`

function clip()
{
    for file in `ls $1`
    do
        if [ -d "$1/$file" ]; then
            if [ ! -d "$2/$file"  ];then
                mkdir -m 777 $2/$file
            fi
            clip $1/$file $2/$file
        else
            if [ "${file##*.}"x = "mp3"x ]||[ "${file##*.}"x = "MP3"x ] ||
               [ "${file##*.}"x = "mp4"x ]||[ "${file##*.}"x = "MP4"x ] ||
               [ "${file##*.}"x = "m4a"x ]||[ "${file##*.}"x = "M4A"x ] ||
               [ "${file##*.}"x = "wav"x ]||[ "${file##*.}"x = "WAV"x ] ||
               [ "${file##*.}"x = "aac"x ]||[ "${file##*.}"x = "AAC"x ] ;then
                start=`date +%s`

                filename=$(echo $file | cut -d . -f1)
                ./tools/ff_clip.sh $1/$file 10 30 $2/$filename.m4a

                end=`date +%s`
                dif=$[ end - start ]
                echo "clip input ---> $1/$file output ---> $2/$filename.m4a cost time $dif sec"
            fi
        fi
    done
}

clip $in_path $out_path

