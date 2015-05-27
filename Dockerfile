FROM progrium/busybox

MAINTAINER Oleksandr Lytvynenko <altvnk@me.com>

RUN opkg-install curl bash

RUN mkdir /kubernetes-mesos
WORKDIR /kubernetes-mesos

COPY ./km/* /kubernetes-mesos/bin/
COPY ./bin /kubernetes-mesos/bin
COPY ./runit/* /usr/bin/

ENV PATH /kubernetes-mesos/bin:$PATH

EXPOSE 4888

ENTRYPOINT ["start.sh"]