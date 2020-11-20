#!/bin/bash

start=`date +%s`

echo "example: $0 input_dir output_dir"

in_path=`realpath $1`
if [ ! -d $in_path ];then
echo "USAGE: $1 nonexist, exit"
exit 1;
fi

out_path=$2
if [ ! -d $out_path ];then
    mkdir -p $out_path
fi
out_path=`realpath $out_path`

./tools/ff_concat.sh "$in_path/广告1.m4a" 10 10 "$in_path/音频1.mp3" 180 30 "$out_path/广告音频1.m4a"
./tools/ff_concat.sh "$in_path/广告2.m4a" 10 10 "$in_path/音频2.mp3" 180 30 "$out_path/广告音频2.m4a"
./tools/ff_concat.sh "$in_path/广告3.m4a" 10 10 "$in_path/音频3.mp3" 180 30 "$out_path/广告音频3.m4a"
./tools/ff_concat.sh "$in_path/广告4.m4a" 10 10 "$in_path/音频4.m4a" 180 30 "$out_path/广告音频4.m4a"
./tools/ff_concat.sh "$in_path/广告5.m4a" 10 10 "$in_path/音频5.mp3" 180 30 "$out_path/广告音频5.m4a"
./tools/ff_concat.sh "$in_path/广告6.m4a" 10 10 "$in_path/音频6.m4a" 180 30 "$out_path/广告音频6.m4a"
./tools/ff_concat.sh "$in_path/广告7.m4a" 10 10 "$in_path/音频7.mp3" 180 30 "$out_path/广告音频7.m4a"
./tools/ff_concat.sh "$in_path/广告8.mp3" 10 10 "$in_path/音频8.mp3" 180 30 "$out_path/广告音频8.m4a"
./tools/ff_concat.sh "$in_path/广告9.m4a" 10 10 "$in_path/音频9.mp3" 180 30 "$out_path/广告音频9.m4a"
./tools/ff_concat.sh "$in_path/广告10.m4a" 10 10 "$in_path/音频10.m4a" 180 30 "$out_path/广告音频10.m4a"

