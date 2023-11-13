# Process to setup live Webcam Streaming

## V4L2 API
Video4Linux, V4L for short, is a collection of device drivers and an API for supporting real-time video capture on Linux systems. V4L2 is the second version of V4L

#### Capturing a frame involves 6 steps. We can move step-by-step.

1) Initialize the device by setting various options like image format.
2) Request for a buffer from the device by the method of memory mapping, user pointer or DMA. We will be using mmap approach.
3) Query the allotted buffer from the device to get memory details.
4) Start streaming.
5) Queue the buffer to the device and get the frame after the device writes to the buffer.
6) Dequeue the buffer and stop streaming.

## Capture a single image
```
$ v4l2-ctl --device=/dev/video2 --set-fmt-video=width=3840,height=2160,pixelformat=MJPG --stream-mmap --stream-to=frame.jpg --stream-count=1
```

## Derek mallow Example for host PC

Requirements
--Install opencv (PACKAGE_OPENCV2)
--Install libv4l2 (PACKAGE_LIBV4L)



