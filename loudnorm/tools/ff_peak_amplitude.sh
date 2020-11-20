#!/bin/bash

start=`date +%s`

echo "peak amplitude example: $0 input_dir output_dir"
if [ $# != 2 ] ; then
echo "USAGE: $0 input_dir output_dir, exit"
exit 1;
fi

in_path=`realpath $1`
if [ ! -d $in_path ];then
echo "USAGE: $1 nonexist, exit"
exit 1;
fi

out_path=`realpath $2`
if [ ! -d $out_path ];then
    mkdir -p $out_path
fi

function min()
{
    if [ $(echo "$1 > $2" | bc) ];then
        echo $2
    else
        echo $1
    fi
}

function getVolume()
{
    result=`ffmpeg -hide_banner -i $1 -af volumedetect -vn -sn -f null /dev/null 2>&1`

    tmp=${result#*mean_volume\:}
    mean=${tmp%%dB*}
    mean=`echo $mean`

    tmp=${result#*max_volume\:}
    peak=${tmp%%dB*}
    peak=`echo $peak`

    mean_new=$(echo "(-6)-($mean)" | bc)
    peak_new=$(echo "(0)-($peak)" | bc)

    ret=$(min $mean_new $peak_new)
    echo $ret
}

function loudnorm()
{
    for file in `ls $1`
    do
        if [ -d "$1/$file" ]; then
            if [ ! -d "$2/$file"  ];then
                mkdir -m 777 $2/$file
            fi
            loudnorm $1/$file $2/$file
        else
            if [ "${file##*.}"x = "mp3"x ]||[ "${file##*.}"x = "MP3"x ] ||
               [ "${file##*.}"x = "mp4"x ]||[ "${file##*.}"x = "MP4"x ] ||
               [ "${file##*.}"x = "m4a"x ]||[ "${file##*.}"x = "M4A"x ] ||
               [ "${file##*.}"x = "aac"x ]||[ "${file##*.}"x = "AAC"x ] ;then
                start=`date +%s`

                if [ "${file##*.}"x = "mp3"x ]||[ "${file##*.}"x = "MP3"x ];then
                    codec="libmp3lame"
                    muxer="mp3"
                fi
                if [ "${file##*.}"x = "mp4"x ]||[ "${file##*.}"x = "MP4"x ]||
                   [ "${file##*.}"x = "m4a"x ]||[ "${file##*.}"x = "M4A"x ];then
                    codec="aac"
                    muxer="mp4"
                fi

                gain="$(echo "$(getVolume $1/$file)" | bc | awk '{printf "%.3f", $0}')dB"

                filename=$(echo $file | cut -d . -f1)
                ffmpeg -i $1/$file -af volume=$gain -y $2/$filename.wav 1>/dev/null 2>/dev/null

                end=`date +%s`
                dif=$[ end - start ]
                echo "peak amplitude file name ---> $1/$file gain : $gain cost time $dif sec"
            fi
        fi
    done
}

loudnorm $in_path $out_path



