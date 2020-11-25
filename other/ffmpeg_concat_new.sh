#!/bin/bash

start=`date +%s`

echo "example: $0 ~/work/src/input1.mp3 ~/work/src/input2.mp3 ~/work/out/out_file.mp3 out_nb_channels out_sample_rate"
if [ $# != 5 ] ; then
echo "USAGE: $0 input_file1 input_file2 output_file out_nb_channels out_sample_rate, exit"
exit 1;
fi

if [ ! -e $1  ];then
echo "USAGE: $1 nonexist, exit"
exit 1;
fi

if [ ! -e $2  ];then
echo "USAGE: $2 nonexist, exit"
exit 1;
fi

function concatFiles()
{
    echo "startup ffmpeg concat"
    nb_channels=$4
    sample_rate=$5
    ffmpeg -i $1 -i $2 -filter_complex "[0:a] [1:a] concat=n=2:v=0:a=1 [out]" \
           -map [out] -acodec libmp3lame -q:a 3 -ac $4 -ar $5 -f mp3 -y $3
    echo "complete ffmpeg concat"
}

out_path=$3
if [ ! -d ${out_path%/*}  ];then
  mkdir -m 777 ${out_path%/*}
fi

concatFiles $1 $2 $3 $4 $5

end=`date +%s`
dif=$[ end - start ]
echo "cost time $dif"
