
if [ $# != 3 ] ; then 
echo "USAGE: $0 input_video1 input_video2 png audio output_video" 
exit 1;
fi 

ffmpeg -i $1 -i $2 \
-filter_complex "[0:v] setpts=PTS-STARTPTS,scale=540:960 [base]; \
[1:v] setpts=PTS-STARTPTS,scale=250:250 [head]; \
[base][head] overlay=repeatlast=0:x=0:y=main_h-overlay_h [vout]" \
 -map  "[vout]" \
-c:v libx264 -tune zerolatency -force_key_frames "expr:gte(t,n_forced*5)" -pix_fmt yuv420p -vb 1500k -threads 4 \
-c:a aac -ab 64k -ac 2 -ar 44100 \
 -movflags faststart -f mp4 -y $3
