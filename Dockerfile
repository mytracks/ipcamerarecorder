FROM alpine:3.10
LABEL MAINTAINER "Dirk Stichling <mytracks@mytracks4mac.com>"

RUN apk add --no-cache ffmpeg

ENV USER user
ENV PASSWORD password
ENV IP 192.168.1.1

COPY start.sh /

CMD /start.sh
