#!/bin/bash

start=`date +%s`

echo "example: $0 input_dir output_dir target_LUFS"
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

./ff_clip.sh "$in_path/音量小问题" "$out_path/音量小问题/clip-sample"
./ff_concat_sample.sh "$in_path/广告音量问题" "$out_path/广告音量问题/concat-sample"
./ff_clip.sh "$in_path/专辑音量不一致" "$out_path/专辑音量不一致/clip-sample/clip"
./ff_concat_album.sh "$out_path/专辑音量不一致/clip-sample/clip" "$out_path/专辑音量不一致/clip-sample"

ebur128="ebur128"
#./tools/ff_loudnorm_ebur128.sh $in_path $out_path/$ebur128 $target_LUFS
./ff_clip.sh "$out_path/$ebur128/音量小问题" "$out_path/音量小问题/clip-$ebur128"
./ff_concat.sh "$out_path/$ebur128/广告音量问题" "$out_path/广告音量问题/concat-$ebur128"
./ff_clip.sh "$out_path/$ebur128/专辑音量不一致" "$out_path/专辑音量不一致/clip-$ebur128/clip"
./ff_concat_album.sh "$out_path/专辑音量不一致/clip-$ebur128/clip" "$out_path/专辑音量不一致/clip-$ebur128"

loudnorm="loudnorm"
#./tools/ff_loudnorm_loudnorm.sh $in_path $out_path/$loudnorm $target_LUFS
./ff_clip.sh "$out_path/$loudnorm/音量小问题" "$out_path/音量小问题/clip-$loudnorm"
./ff_concat.sh "$out_path/$loudnorm/广告音量问题" "$out_path/广告音量问题/concat-$loudnorm"
./ff_clip.sh "$out_path/$loudnorm/专辑音量不一致" "$out_path/专辑音量不一致/clip-$loudnorm/clip"
./ff_concat_album.sh "$out_path/专辑音量不一致/clip-$loudnorm/clip" "$out_path/专辑音量不一致/clip-$loudnorm"

peak_amplitude="peak_amplitude"
#./tools/ff_peak_amplitude.sh $in_path $out_path/$peak_amplitude
./ff_clip.sh "$out_path/$peak_amplitude/音量小问题" "$out_path/音量小问题/clip-$peak_amplitude"
./ff_concat.sh "$out_path/$peak_amplitude/广告音量问题" "$out_path/广告音量问题/concat-$peak_amplitude"
./ff_clip.sh "$out_path/$peak_amplitude/专辑音量不一致" "$out_path/专辑音量不一致/clip-$peak_amplitude/clip"
./ff_concat_album.sh "$out_path/专辑音量不一致/clip-$peak_amplitude/clip" "$out_path/专辑音量不一致/clip-$peak_amplitude"



loudnorm_peak="loudnorm_peak"
./ff_concat.sh "$out_path/$loudnorm_peak/广告音量问题" "$out_path/广告音量问题/concat-$loudnorm_peak"





