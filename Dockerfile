FROM busybox
MAINTAINER Oleksandr Lytvynenko <altvnk@me.com>

#RUN opkg-install curl bash

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.10.0.3/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && rm -rf /var/run/s6-overlay-amd64.tar.gz

COPY ./rootfs/ /

EXPOSE 8888

ENTRYPOINT ["/init"]
