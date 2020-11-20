#!/bin/bash

echo $1 $2 
input=`realpath $1`
if [ ! -d $input  ];then
echo "USAGE: $input nonexist, exit"
exit 1;
fi

outpath=$2
if [ ! -d ${outpath%/*}  ];then
  mkdir -m 777 ${outpath%/*}
fi
outpath=`realpath $outpath`

./tools/ff_concat.sh "$input/1.m4a" 0 30 "$input/2.m4a" 0 30 "$outpath/concat-12.m4a"
./tools/ff_concat.sh "$input/3.m4a" 0 30 "$input/4.m4a" 0 30 "$outpath/concat-34.m4a"
./tools/ff_concat.sh "$input/5.m4a" 0 30 "$input/6.m4a" 0 30 "$outpath/concat-56.m4a"
./tools/ff_concat.sh "$input/7.m4a" 0 30 "$input/8.m4a" 0 30 "$outpath/concat-78.m4a"
./tools/ff_concat.sh "$input/9.m4a" 0 30 "$input/10.m4a" 0 30 "$outpath/concat-910.m4a"
./tools/ff_concat.sh "$input/11.m4a" 0 30 "$input/12.m4a" 0 30 "$outpath/concat-1112.m4a"
./tools/ff_concat.sh "$input/13.m4a" 0 30 "$input/14.m4a" 0 30 "$outpath/concat-1314.m4a"
./tools/ff_concat.sh "$input/15.m4a" 0 30 "$input/16.m4a" 0 30 "$outpath/concat-1516.m4a"
./tools/ff_concat.sh "$input/17.m4a" 0 30 "$input/18.m4a" 0 30 "$outpath/concat-1718.m4a"
./tools/ff_concat.sh "$input/19.m4a" 0 30 "$input/20.m4a" 0 30 "$outpath/concat-1920.m4a"

