#!/bin/bash

start=`date +%s`

echo "loudnorm example: $0 input_dir output_dir target_LUFS"
if [ $# != 3 ] ; then
echo "USAGE: $0 input_dir output_dir target_LUFS, exit"
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

target_LUFS=$3

function getLoudnorm()
{
    result=`ffmpeg -i $1 -af loudnorm=I=$target_LUFS:TP=-1.0:LRA=11.0:print_format=summary -f null /dev/null 2>&1`

    tmp=${result#*Input Integrated\:}
    measured_I=${tmp%%LUFS*}
    measured_I=`echo $measured_I`

    tmp=${result#*Input True Peak\:}
    measured_TP=${tmp%%dBTP*}
    measured_TP=`echo $measured_TP`

    tmp=${result#*Input LRA\:}
    measured_LRA=${tmp%%LU*}
    measured_LRA=`echo $measured_LRA`

    tmp=${result#*Input Threshold\:}
    measured_thresh=${tmp%%LUFS*}
    measured_thresh=`echo $measured_thresh`

    tmp=${result#*Target Offset\:}
    offset=${tmp%%LU*}
    offset=`echo $offset`
    offset=$(echo $offset | tr -d "+")
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

                getLoudnorm $1/$file

                filename=$(echo $file | cut -d . -f1)
                ffmpeg -i $1/$file -af loudnorm=I=$target_LUFS:TP=-1.0:LRA=11.0:measured_I=$measured_I:measured_LRA=$measured_LRA:measured_TP=$measured_TP:measured_thresh=$measured_thresh:offset=$offset:linear=true:print_format=none -y $2/$filename.wav 1>/dev/null 2>/dev/null

                end=`date +%s`
                dif=$[ end - start ]
                echo "loudnorm file name ---> $1/$file measured_I=$measured_I:measured_LRA=$measured_LRA:measured_TP=$measured_TP:measured_thresh=$measured_thresh:offset=$offset cost time $dif sec"
            fi
        fi
    done
}

loudnorm $in_path $out_path



