# Overview

A Docker image for recording audio and video streams of an IP based  surveillance camera. The camera need to support the *RTSP* protocol. The streams are processed by *ffmpeg*.

## Usage

You need to specify at least the IP address, user name and password of the IP camera and a volume to store the recorded data. Then you can start the container like this:

```bash
docker run -d --name ipcamerarecorder1 -e USER=admin -e PASSWORD=my-secret -e IP=192.168.178.42 -v /my/local/storage_path:/record --restart unless-stopped mytracks/ipcamerarecorder
```

## Configuration

You can configure the container using the following environment variables:

| Environment Variable  | Description | Default Value |
| ------------- | ------------- | ------------- |
| `IP`  | The IP address or DNS name of the camera | `192.168.1.1` |
| `USER`  | The user name  | `user` |
| `PASSWORD`  | The user's password  | `password` |
| `KEEP_DAYS`  | The numbers of days to keep the recorded files.  | `14` |
| `RECORD_LENGTH_SECONDS`  | The length of each individual recording in seconds  | `3600` |
| `FRAMERATE`  | The frame rate for the recording  | `4` |

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
  restartPolicy: Always
  hostNetwork: true
  containers:
  - name: ipcamerarecorder
    image: mytracks/ipcamerarecorder
    env:
    - name: USER
      value: admin
    - name: PASSWORD
      value: my-secret
    - name: IP
      value: "192.168.178.42"
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
