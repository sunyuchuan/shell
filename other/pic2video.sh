ffmpeg -i $1 -i $2 -map_metadata -1 \
-filter_complex "nullsrc=size=$3x$4,fps=15 [base]; \
[0:v] scale=$3x$4,fps=15 [tmp]; \
[base][tmp] overlay=0:0" \
-c:v libx264 -r 15 -tune zerolatency -force_key_frames "expr:gte(t,n_forced*1)" \
-pix_fmt yuv420p -s $3x$4 \
-c:a aac -ab 64k -ac 2 -ar 44100 \
-shortest -f mpegts -y $5
