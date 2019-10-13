#!/bin/sh

cd /record
rm -f current.mp4
find ./*.mp4 -mtime +${KEEP_DAYS} -exec rm -f {} \; 2> /dev/null
ffmpeg ${FFMPEG_ARGS} -i ${URL} -r ${FRAMERATE} -acodec copy -vcodec copy current.mp4 &
sleep ${RECORD_LENGTH_SECONDS}
pkill -x ffmpeg
sleep 1
cp current.mp4 `date -Iseconds`.mp4
