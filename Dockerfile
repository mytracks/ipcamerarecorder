FROM alpine:3.10
LABEL MAINTAINER "Dirk Stichling <mytracks@mytracks4mac.com>"

RUN apk add --no-cache ffmpeg

ENV USER user
ENV PASSWORD password
ENV IP 192.168.1.1
ENV KEEP_DAYS 14
ENV RECORD_LENGTH_SECONDS 3600
ENV FRAMERATE 4

COPY start.sh /

CMD /start.sh
