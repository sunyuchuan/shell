#!/bin/bash

start=`date +%s`

echo "example: $0 ~/work/src/input.mp3 start_time_in_s end_time_in_s ~/work/out/output.mp3"
if [ $# != 4 ] ; then
echo "USAGE: $0 input_file clip_start_time_float_s clip_end_time_s_float output_file, exit"
exit 1;
fi

if [ ! -e $1  ];then
echo "USAGE: $1 nonexist, exit"
exit 1;
fi

function clip()
{
    echo "clip audio start"
    ffmpeg -i $1 -ss $2 -to $3 \
           -c:a copy -metadata creation_time=now -y $4
    echo "clip audio end"
}

out_path=$4
if [ ! -d ${out_path%/*}  ];then
  mkdir -m 777 ${out_path%/*}
fi

clip $1 $2 $3 $4

end=`date +%s`
dif=$[ end - start ]
echo "cost time $dif"
