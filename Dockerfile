FROM progrium/busybox
MAINTAINER Oleksandr Lytvynenko <altvnk@me.com>

ENV K8SM_HOME /opt/k8sm
ENV PATH $K8SM_HOME:$PATH

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.13.0.0/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && rm -rf /var/run/s6-overlay-amd64.tar.gz

COPY ./rootfs/ /

WORKDIR $K8SM_HOME

ENTRYPOINT ["/init"]
