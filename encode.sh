#!/bin/bash
ts=$(date "+%H%M%S")
rm $PWD/output/*.mp4
ffmpeg -f mjpeg -i output.raw -vcodec copy output/output-$ts.mp4