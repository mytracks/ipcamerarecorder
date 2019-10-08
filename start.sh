#!/bin/sh

cd /record
rm -f current.mp4
find ./*.mp4 -mtime +15 -exec rm -f {} \; 2> /dev/null
ffmpeg -i rtsp://${USER}:${PASSWORD}@${IP}/live/ch0 -r 4 -acodec copy -vcodec copy current.mp4 &
sleep 3600
pkill -x ffmpeg
sleep 1
cp current.mp4 `date -Iseconds`.mp4
