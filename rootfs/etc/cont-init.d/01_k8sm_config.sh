#!/usr/bin/with-contenv sh
# This script composes mesos-cloud.conf from env vars.

# cat > ${K8SM_HOME}/mesos-cloud.conf <<EOL
# [mesos-cloud]
#     mesos-master        = ${MESOS_HOST}:${MESOS_PORT}
#     http-client-timeout = 5s
#     state-cache-ttl     = 20s
# EOL

K8SM_CONFIG="${K8SM_HOME}/mesos-cloud.conf"
if [ ! -f "$K8SM_CONFIG" ]; then
    echo "[mesos-cloud]
        mesos-master        = ${MESOS_HOST}:${MESOS_PORT}
        http-client-timeout = 5s
        state-cache-ttl     = 20s
    " > ${K8SM_CONFIG}
fi