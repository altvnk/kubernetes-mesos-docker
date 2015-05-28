FROM progrium/busybox

MAINTAINER Oleksandr Lytvynenko <altvnk@me.com>

RUN opkg-install curl bash

COPY ./rootfs/ /

EXPOSE 8888

ENTRYPOINT ["runit"]
