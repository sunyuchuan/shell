#!/bin/bash

start=`date +%s`

if [ $# != 4 ] ; then
echo "USAGE: $0 input starttime duration outputfile, exit"
exit 1;
fi

input=`realpath $1`
input_st=$2
input_dur=$3
outpath=`realpath $4`

if [ ! -e $input  ];then
echo "USAGE: $input nonexist, exit"
exit 1;
fi

if [ ! -d ${outpath%/*}  ];then
  mkdir -m 777 ${outpath%/*}
fi

ffmpeg -i $input -ss $input_st -t $input_dur -vn -c:a aac -ac 2 -ar 44100 -f mp4 -y $outpath 1>/dev/null 2>/dev/null

end=`date +%s`
dif=$[ end - start ]
echo "ff_clip input ---> $input cost time $dif sec"

