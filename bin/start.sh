#!/usr/bin/env bash

# Inputs:
# MESOS_IP - IP that mesos is accessible on
# MESOS_PORT - Port that mesos-master is accessible on (default 5050)
# ETCD_IP - IP that etcd is accessible on
# ETCD_PORT - Port that etcd is accessible on (default 4001)
# LOG_DIR - Directory to write logs to (default /tmp/k8sm-logs)

set -e

# add the current dir to PATH
bin=$(cd $(dirname $0) && pwd -P)
export PATH=$PATH:${bin}

PUBLIC_IP=$(publicip)

set -e

export K8SM_IP=${PUBLIC_IP}
export K8SM_PORT=4888
echo "Kubernetes: ${K8SM_IP}:${K8SM_PORT}"

export MESOS_IP=${MESOS_IP:-mesos.service.consul}
export MESOS_PORT=${MESOS_PORT:-5050}
export MESOS_MASTER=${MESOS_IP}:${MESOS_PORT}
echo "Mesos: ${MESOS_MASTER}"

export ETCD_IP=${ETCD_IP:-etcd.service.consul}
export ETCD_PORT=${ETCD_PORT:-4001}
export ETCD_URL=http://${ETCD_IP}:${ETCD_PORT}
echo "Etcd: ${ETCD_URL}"


K8SM_CONFIG="$(pwd)/mesos-cloud.conf"
echo "Config: ${K8SM_CONFIG}"
if [ ! -f "$K8SM_CONFIG" ]; then
    echo "Writing default config"
    echo "[mesos-cloud]
        mesos-master        = ${MESOS_MASTER}
        http-client-timeout = 5s
        state-cache-ttl     = 20s
    " > ${K8SM_CONFIG}
fi

cat ${K8SM_CONFIG}

LOG_DIR=${LOG_DIR:-"/tmp/k8sm-logs"}
mkdir -p ${LOG_DIR}
echo "Log Dir: ${LOG_DIR}"

echo "---------------------"


source ${bin}/subprocs.sh

# propagate SIGINT & SIGTERM
for sig in INT TERM EXIT; do
    trap "kill_subprocs ${sig}" ${sig}
done

echo "Detecting etcd"
await-health-check ${ETCD_URL}/health
echo "---------------------"


echo "Detecting mesos-master"
await-health-check http://${MESOS_MASTER}/health
echo "---------------------"

echo "Starting km apiserver &> ${LOG_DIR}/apiserver.log"
km apiserver \
  --address=${K8SM_IP} \
  --etcd_servers=${ETCD_URL} \
  --portal_net=10.10.10.0/24 \
  --port=${K8SM_PORT} \
  --cloud_provider=mesos \
  --cloud_config=${K8SM_CONFIG} \
  &> ${LOG_DIR}/apiserver.log \
  &
add_subproc "$!" "km apiserver"
await-health-check http://${K8SM_IP}:${K8SM_PORT}/healthz
echo "---------------------"


echo "Starting km controller-manager &> ${LOG_DIR}/controller-manager.log"
km controller-manager \
  --master=${K8SM_IP}:${K8SM_PORT} \
  --cloud_config=${K8SM_CONFIG} \
  &> ${LOG_DIR}/controller-manager.log \
  &
add_subproc "$!" "km controller-manager"
echo "---------------------"


echo "Starting km scheduler &> ${LOG_DIR}/scheduler.log"
km scheduler \
  --mesos_master=${MESOS_MASTER} \
  --address=${K8SM_IP} \
  --etcd_servers=${ETCD_URL} \
  --mesos_user=root \
  --api_servers=${K8SM_IP}:${K8SM_PORT} \
  &> ${LOG_DIR}/scheduler.log \
  &
add_subproc "$!" "km scheduler"
echo "---------------------"


await_subprocs
