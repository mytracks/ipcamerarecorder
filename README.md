# Overview

A Docker image for recording audio and video streams of an IP based  surveillance camera. The camera need to support the *RTSP* protocol. The streams are processed by *ffmpeg*.

## Usage

You need to specify at least the RTSP URL of the IP camera and a volume to store the recorded data. You may need to read to documentation of your IP camera in order to find the correct URL.

Then you can start the container like this:

```bash
docker run -d -e URL="rtsp://user:password@192.168.1.1/live/ch0" -v /my/local/storage_path:/record --restart unless-stopped mytracks/ipcamerarecorder
```

The container will write *mp4* files to the volume mounted to `/record`. Therefore you may need to specify a user id with the correct permissions. As a default the container is executed using user id 1000.

## Configuration

You can configure the container using the following environment variables:

| Environment Variable  | Description | Default Value |
| ------------- | ------------- | ------------- |
| `URL`  | The RTSP URL used to connect to the camera. This has to be a [valid RTSP URL for ffmpeg](http://ffmpeg.org/ffmpeg-protocols.html#rtsp). | `rtsp://user:password@192.168.1.1/live/ch0` |
| `KEEP_DAYS`  | The numbers of days to keep the recorded files.  | `14` |
| `RECORD_LENGTH_SECONDS`  | The length of each individual recording in seconds  | `3600` |
| `FRAMERATE`  | The frame rate for the recording  | `4` |
| `FFMPEG_ARGS`  | Additional command line arguments for ffmpeg.  |  |

## Some Details

You can specify the length of the recordings using the environment variable `RECORD_LENGTH_SECONDS`. After this period the container will stop. I have chosen this solution because it was the most reliable solution in case the camera wasn't reachable for some time or in case any other error occurred. Therefore you need to specify `--restart unless-stopped` when starting the container.

With each start of the container old recordings are deleted. You can specify the number of days to keep old recordings using the environment variable `KEEP_DAYS`.

## Supported Architectures

The following Docker architectures are supported: `linux/arm64`, `linux/arm/v7` and `linux/amd64`

## Kubernetes

You can also run this container in Kubernetes. Here is an example of a pod definition that you can use as a starting point for your configuration:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ipcamerarecorder1
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
  restartPolicy: Always
  hostNetwork: true
  containers:
  - name: ipcamerarecorder
    image: mytracks/ipcamerarecorder
    env:
    - name: URL
      value: "rtsp://user:password@192.168.1.1/live/ch0"
    volumeMounts:
      - mountPath: /record
        name: record
  volumes:
  - name: record
    hostPath:
      path: /my/local/storage_path
      type: Directory
```

*Notes:*

* You need to set `hostNetwork: true`. Otherwise RTSP will not work. If you know a better solution please let me know.
* You need to set `restartPolicy: Always`. Otherwise you will only get a single recording.
