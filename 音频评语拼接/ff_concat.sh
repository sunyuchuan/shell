#!/bin/bash

start=`date +%s`

if [ $# != 6 ] ; then
echo "USAGE: $0 in_audio_1 in_audio_2 in_audio_3 in_audio_4 output_audio target_LUFS, exit"
exit 1;
fi

audio_1=`realpath $1`
if [ ! -e $audio_1  ];then
echo "USAGE: $audio_1 nonexist, exit"
exit 1;
fi
audio_2=`realpath $2`
if [ ! -e $audio_2  ];then
echo "USAGE: $audio_2 nonexist, exit"
exit 1;
fi
audio_3=`realpath $3`
if [ ! -e $audio_3  ];then
echo "USAGE: $audio_3 nonexist, exit"
exit 1;
fi
audio_4=`realpath $4`
if [ ! -e $audio_4  ];then
echo "USAGE: $audio_4 nonexist, exit"
exit 1;
fi

outpath=`realpath $5`
target_LUFS=$6

function getLoudness()
{
    result=`ffmpeg -i $1 -af ebur128=framelog=verbose -f null /dev/null 2>&1`
    tmp=${result#*I\:}
    ret=${tmp%%LUFS*}

    echo $ret
}

function loudnorm_ebur128()
{
    loudness=$(getLoudness $1)
    gain="$(echo "($target_LUFS)-($loudness)" | bc | awk '{printf "%.3f", $0}')dB"
    ffmpeg -y -i $1 -vn -sn -filter_complex "[0:a]alimiter=level_in=$gain:limit=-1dB:level=disabled[out]" -map "[out]" -c:a libmp3lame -ac 2 -ar 44100 -b:a 128k -f mp3 -y $2 1>/dev/null 2>/dev/null
}

function concatFiles()
{
    if [ -e ${outpath%/*}/concat.txt  ];then
      rm ${outpath%/*}/concat.txt
    fi
    touch ${outpath%/*}/concat.txt

    echo "ffconcat version 1.0" > ${outpath%/*}/concat.txt

    loudnorm_ebur128 $audio_1 ${outpath%/*}/${audio_1##*/}.mp3
    echo "file '${outpath%/*}/${audio_1##*/}.mp3'" >> ${outpath%/*}/concat.txt

    loudnorm_ebur128 $audio_2 ${outpath%/*}/${audio_2##*/}.mp3
    echo "file '${outpath%/*}/${audio_2##*/}.mp3'" >> ${outpath%/*}/concat.txt

    loudnorm_ebur128 $audio_3 ${outpath%/*}/${audio_3##*/}.mp3
    echo "file '${outpath%/*}/${audio_3##*/}.mp3'" >> ${outpath%/*}/concat.txt

    loudnorm_ebur128 $audio_4 ${outpath%/*}/${audio_4##*/}.mp3
    echo "file '${outpath%/*}/${audio_4##*/}.mp3'" >> ${outpath%/*}/concat.txt

    ffmpeg -f concat -safe 0 -i ${outpath%/*}/concat.txt -vn -sn -c:a copy -f mp3 -y $outpath 1>/dev/null 2>/dev/null
    rm ${outpath%/*}/${audio_1##*/}.mp3 ${outpath%/*}/${audio_2##*/}.mp3 ${outpath%/*}/${audio_3##*/}.mp3 ${outpath%/*}/${audio_4##*/}.mp3 ${outpath%/*}/concat.txt
}

concatFiles

end=`date +%s`
dif=$[ end - start ]
echo "ff_concat cost time $dif sec"

