# Process to setup live Webcam Streaming

## Capture a single image
```
$ v4l2-ctl --device=/dev/video2 --set-fmt-video=width=3840,height=2160,pixelformat=MJPG --stream-mmap --stream-to=frame.jpg --stream-count=1
```

