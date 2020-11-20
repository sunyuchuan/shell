#!/bin/bash

start=`date +%s`

echo "replaygain example: $0 input_dir output_dir"
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

function getReplayGain()
{
    result=`ffmpeg -i $1 -af replaygain -f null /dev/null 2>&1`

    tmp=${result##*track_peak = }
    track_peak=${tmp:0:8}
    tmp=${result##*track_gain = }
    track_gain=$(echo ${tmp%% dB*} | tr -d "+")
    track_gain="$(echo "$track_gain" | bc | awk '{printf "%.3f", $0}')dB"
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

                getReplayGain $1/$file

                filename=$(echo $file | cut -d . -f1)
                ffmpeg -i $1/$file -filter_complex "[0:a]volume=$track_gain[aout];[aout]alimiter=level=disabled[out]" -map "[out]" -y $2/$filename.wav 1>/dev/null 2>/dev/null

                end=`date +%s`
                dif=$[ end - start ]
                echo "replaygain file name ---> $1/$file track_gain : $track_gain cost time $dif sec"
            fi
        fi
    done
}

loudnorm $in_path $out_path
