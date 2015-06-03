FROM progrium/busybox
MAINTAINER Oleksandr Lytvynenko <altvnk@me.com>

ENV K8SM_HOME /opt/k8sm
ENV K8SM_PORT 8888
ENV K8SM_PORTAL 10.10.10.0/24

ENV MESOS_HOST mesos.service.consul
ENV MESOS_PORT 5050

ENV ETCD_HOST etcd.service.consul
ENV ETCD_PORT 4001

ENV LOG_DIR /var/log

ENV PATH $K8SM_HOME:$PATH

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.10.0.3/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && rm -rf /var/run/s6-overlay-amd64.tar.gz

COPY ./rootfs/ /

EXPOSE $K8SM_PORT

WORKDIR /opt/k8sm

ENTRYPOINT ["/init"]
