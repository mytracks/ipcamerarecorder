#!/bin/sh

docker buildx build --platform linux/arm64,linux/arm/v7,linux/amd64 -t mytracks/ipcamerarecorder:latest --push .
