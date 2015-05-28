FROM progrium/busybox

MAINTAINER Oleksandr Lytvynenko <altvnk@me.com>

RUN opkg-install curl bash

ADD ./rootfs/* /

EXPOSE 8888

ENTRYPOINT ["runit"]