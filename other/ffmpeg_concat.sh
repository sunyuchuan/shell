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
    input1=$1
    input2=$2
    output=$3
    echo "ffconcat version 1.0" > ${output%/*}/concat.txt
    ffmpeg -i $1 -vn -c:a mp3 -ac $4 -ar $5 -f mp3 -y ${output%/*}/$5.${input1##*/}
    echo "file '${output%/*}/$5.${input1##*/}'" >> ${output%/*}/concat.txt
    ffmpeg -i $2 -vn -c:a mp3 -ac $4 -ar $5 -f mp3 -y ${output%/*}/$5.${input2##*/}
    echo "file '${output%/*}/$5.${input2##*/}'" >> ${output%/*}/concat.txt
    ffmpeg -f concat -safe 0 -i ${output%/*}/concat.txt -vn -acodec copy -f mp3 -y $3
    rm ${output%/*}/$5.${input1##*/} ${output%/*}/$5.${input2##*/}
}

out_path=$3
if [ ! -d ${out_path%/*}  ];then
  mkdir -m 777 ${out_path%/*}
fi

if [ -e ${out_path%/*}/concat.txt  ];then
  rm ${out_path%/*}/concat.txt
fi
touch ${out_path%/*}/concat.txt

concatFiles $1 $2 $3 $4 $5
rm ${out_path%/*}/concat.txt

end=`date +%s`
dif=$[ end - start ]
echo "cost time $dif"i

