#!/bin/bash

if [ ! -d "LD" ]; then
    mkdir LD
fi

if [ ! -d "HD" ]; then
    mkdir HD
fi

if [ ! -d "AUDIO" ]; then
    mkdir AUDIO
fi
ffmpeg -threads 2 -nostats -i $1 \
    -c:v libx264 -vf "fps=25" -vf "movie=logo.png, scale=100:20[watermask]; [in] [watermask] overlay=0:0 [out]" -strict -2 -flags -global_header -force_key_frames "expr:gte(t,n_forced*2)" -sc_threshold 0 -bf 2 -b_strategy 0 -s 640x360 -b:v 256k -threads 16 \
    -c:a libfdk_aac -ab 64k -ac 2 -ar 44100 \
    -hls_init_time 10 -hls_time 3 -hls_list_size 0 \
    -start_number 0 -hls_segment_filename 'LD/'$1'_LD-%04d.ts' LD/$1_LD.m3u8 \
    -c:v libx264 -vf "fps=25" -vf "movie=logo.png, scale=100:20[watermask]; [in] [watermask] overlay=0:0 [out]"  -strict -2 -flags -global_header -force_key_frames "expr:gte(t,n_forced*2)" -sc_threshold 0 -bf 2 -b_strategy 0 -s 1280x720 -b:v 1500k -threads 16 \
    -c:a libfdk_aac -ab 128k -ac 2 -ar 44100 \
    -hls_init_time 10 -hls_time 3 -hls_list_size 0 \
    -start_number 0  -hls_segment_filename 'HD/'$1'_HD-%04d.ts' HD/$1_HD.m3u8 \
	-vn -c:a libfdk_aac -ab 64k -ac 2 -ar 44100 \
    -hls_init_time 3 -hls_time 3 -hls_list_size 0 \
    -start_number 0  -hls_segment_filename 'AUDIO/'$1'_AUDIO-%04d.ts' AUDIO/$1_AUDIO.m3u8
touch $1.m3u8
echo -e "#EXTM3U
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=320000\nLD/$1_LD.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1600000\nHD/$1_HD.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=80000\nAUDIO/$1_AUDIO.m3u8" >> $1.m3u8
