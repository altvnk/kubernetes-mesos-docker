#!/bin/sh

# MESOS_IP - IP that mesos is accessible on
# MESOS_PORT - Port that mesos-master is accessible on (default 5050)
# ETCD_IP - IP that etcd is accessible on
# ETCD_PORT - Port that etcd is accessible on (default 4001)
# LOG_DIR - Directory to write logs to (default /var/log/)

set -e

K8SM_HOME=/opt/k8sm
K8SM_IP=$(hostname -i)
K8SM_PORT=8888
K8SM_PORTAL=${K8SM_PORTAL:-10.10.10.0/24}

MESOS_IP=${MESOS_IP:-mesos.service.consul}
MESOS_PORT=${MESOS_PORT:-5050}
MESOS_MASTER=${MESOS_IP}:${MESOS_PORT}

ETCD_IP=${ETCD_IP:-etcd.service.consul}
ETCD_PORT=${ETCD_PORT:-4001}
ETCD_URL=http://${ETCD_IP}:${ETCD_PORT}

K8SM_CONFIG="${K8SM_HOME}/mesos-cloud.conf"
if [ ! -f "$K8SM_CONFIG" ]; then
    echo "[mesos-cloud]
        mesos-master        = ${MESOS_MASTER}
        http-client-timeout = 5s
        state-cache-ttl     = 20s
    " > ${K8SM_CONFIG}
fi

LOG_DIR=${LOG_DIR:-"/var/log/"}

PATH=$PATH:${K8SM_HOME}

printf ${K8SM_HOME} > /var/run/s6/container_environment/K8SM_HOME
printf ${K8SM_IP} > /var/run/s6/container_environment/K8SM_IP
printf ${K8SM_PORT} > /var/run/s6/container_environment/K8SM_PORT
printf ${K8SM_PORTAL} > /var/run/s6/container_environment/K8SM_PORTAL
printf ${MESOS_IP} > /var/run/s6/container_environment/MESOS_IP
printf ${MESOS_PORT} > /var/run/s6/container_environment/MESOS_PORT
printf ${MESOS_MASTER} > /var/run/s6/container_environment/MESOS_MASTER
printf ${ETCD_IP} > /var/run/s6/container_environment/ETCD_IP
printf ${ETCD_PORT} > /var/run/s6/container_environment/ETCD_PORT
printf ${ETCD_URL} > /var/run/s6/container_environment/ETCD_URL
printf ${K8SM_CONFIG} > /var/run/s6/container_environment/K8SM_CONFIG
printf ${LOG_DIR} > /var/run/s6/container_environment/LOG_DIR
printf ${PATH} > /var/run/s6/container_environment/PATH