#!/bin/bash

start=`date +%s`

if [ $# != 7 ] ; then
echo "USAGE: $0 input1 starttime duration input2 starttime duration outputfile, exit"
exit 1;
fi

input1=`realpath $1`
input1_st=$2
input1_dur=$3
input2=`realpath $4`
input2_st=$5
input2_dur=$6
outpath=`realpath $7`

if [ ! -e $input1  ];then
echo "USAGE: $input1 nonexist, exit"
exit 1;
fi

if [ ! -e $input2  ];then
echo "USAGE: $input2 nonexist, exit"
exit 1;
fi

if [ ! -d ${outpath%/*}  ];then
  mkdir -m 777 ${outpath%/*}
fi

function concatFiles()
{
    echo "ffconcat version 1.0" > ${outpath%/*}/concat.txt
    ffmpeg -i $input1 -ss $input1_st -t $input1_dur -vn -c:a aac -ac 2 -ar 44100 -f mp4 -y ${outpath%/*}/${input1##*/} 1>/dev/null 2>/dev/null
    echo "file '${outpath%/*}/${input1##*/}'" >> ${outpath%/*}/concat.txt
    ffmpeg -i $input2 -ss $input2_st -t $input2_dur -vn -c:a aac -ac 2 -ar 44100 -f mp4 -y ${outpath%/*}/${input2##*/} 1>/dev/null 2>/dev/null
    echo "file '${outpath%/*}/${input2##*/}'" >> ${outpath%/*}/concat.txt
    ffmpeg -f concat -safe 0 -i ${outpath%/*}/concat.txt -vn -c:a copy -f mp4 -y $outpath 1>/dev/null 2>/dev/null
    rm ${outpath%/*}/${input1##*/} ${outpath%/*}/${input2##*/}
}

if [ -e ${outpath%/*}/concat.txt  ];then
  rm ${outpath%/*}/concat.txt
fi
touch ${outpath%/*}/concat.txt

concatFiles
rm ${outpath%/*}/concat.txt

end=`date +%s`
dif=$[ end - start ]
echo "ff_concat input ---> $input1 $input2 cost time $dif sec"
