#!/bin/bash

start=`date +%s`

echo "example: $0 ~/work/src ~/work/out -35dB"
if [ $# != 3 ] ; then
echo "USAGE: $0 input_dir out_dir Decibel_threshold"
exit 1;
fi

function ffmpeg_l() {
    ffmpeg -i $1 \
        -af silenceremove=start_periods=1:start_duration=$2:start_threshold=$3 -acodec libmp3lame -threads 16 -f mp3 -y $4
}

function listFiles()
{
    for file in `ls $1`;
    do
        if [ -d "$1/$file" ]; then
            if [ ! -d "$2/$file"  ];then
                mkdir -m 777 $2/$file
            fi
            listFiles $1/$file $2/$file $3
        else
            if [ "${file##*.}"x = "mp3"x ]||[ "${file##*.}"x = "MP3"x ];then
                ffmpeg_l $1/$file 0 $3 $2/$file
            fi
        fi
    done
}

if [ ! -d $2  ];then
  mkdir -m 777 $2
fi

listFiles $1 $2 $3

end=`date +%s`
dif=$[ end - start ]
echo "cost time $dif"
