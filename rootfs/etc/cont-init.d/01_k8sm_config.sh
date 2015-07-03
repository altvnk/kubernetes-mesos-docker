#!/usr/bin/with-contenv sh
# This script composes mesos-cloud.conf from env vars.
cat > ${K8SM_HOME}/mesos-cloud.conf <<EOL
[mesos-cloud]
    mesos-master        = ${MESOS_HOST:-leader.mesos.service.consul}:${MESOS_PORT:-5050}
    http-client-timeout = 5s
    state-cache-ttl     = 20s
EOL
