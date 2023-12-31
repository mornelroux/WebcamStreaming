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

## How to Capture video
For this excersize, we will use the onboard webcam within the host computer, since it is already listed as a webcam USB device and setup is very similar to an external USB webcam. 

List all the available devices:

```
$ v4l2-ctl --list-devices
Integrated_Webcam_HD: Integrate (usb-0000:00:14.0-6):
        /dev/video0
        /dev/video1
        /dev/media0
```

List all the available formats:

```
$ v4l2-ctl --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture

        [0]: 'MJPG' (Motion-JPEG, compressed)
        [1]: 'YUYV' (YUYV 4:2:2)
```
Use `--list-formats-ext` to view more detail on the available formats.

For this tutorial, MJPEG will be used.

Get the `capture.c` source file available on the [Linux Foundation Website](https://www.kernel.org/doc/html/v4.9/media/uapi/v4l/capture.c.html). 

Within the `capture.c` source, change the format from `YUYV` to `MJPEG`.

```
        fmt.fmt.pix.width       = 640;
        fmt.fmt.pix.height      = 480;
        fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
        fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;
```

Note that the orginial `capture.c`'s output string from the function `fprintf()` has some of the `\n` removed, which means the text output will be compressed. 

More additions are needed to allow infinate streaming of the output. Therefore, instead of saving raw data to a file, the data will be streamed to the terminal, where it will be piped to `ffmpeg` to stream. Modifications were made under the `mainloop()` function.

        ```
        static void mainloop(void)
        {
                unsigned int count;
                unsigned int loopIsInfinite = 0;

                if (frame_count == 0) loopIsInfinite = 1;
                count = frame_count;

                while ((count-- > 0)||(loopIsInfinite)) {
                        for (;;) {
                                fd_set fds;
                                struct timeval tv;
                [...]
        ```

After the fixes were made, build the program. For example, the program may be build with:

```
$ gcc capture.c -o capture.out
```

### Capture a short video

In the terminal, execute the following:

```
$ ./capture.out -f -d /dev/video0 -c 300 -o > output.raw
```

Explaination:
`-f` referes the the default format set, which was changed to MJPEG.
`-c` referes to the total number of frames. 10 second * 30 FPS = 300 frames
`-o` referes to the destination file for the raw data.

Encode the video data with:

```
$ ffmpeg -f mjpeg -i output.raw -vcodec copy output.mp4
```

Now the video can be viewed.


## Stream video over UDP

These instructions is for streaming live video (with much latency) to your own host with UDP. Open two terminals side by side. One terminal open at the `capture.c` directory (host) and the other at a random dicretory(client).

At the client directory, use `ffplay` to listen on the UDP port:

```
ffplay udp://192.168.8.150:1234/
```

At the host directory, stream the video from the captured output by piping the raw data. 

```
/capture -d /dev/video0 -o -c0|ffmpeg -i - -c:v libx264 -f mpegts udp://127.0.0.1:1234
```


```
./capture -d /dev/video5 -o -c0|ffmpeg -i - -c:v libx264 -preset ultrafast -tune zerolatency -f mpegts udp://127.0.0.1:1234
```


## Capture a single image
```
$ v4l2-ctl --device=/dev/video2 --set-fmt-video=width=3840,height=2160,pixelformat=MJPG --stream-mmap --stream-to=frame.jpg --stream-count=1
```

Install avconv


## Derek mallow Example for host PC

Requirements
--Install opencv (PACKAGE_OPENCV2)
--Install libv4l2 (PACKAGE_LIBV4L)



