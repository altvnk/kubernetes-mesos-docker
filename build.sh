#!/usr/bin/env bash

REPO="docker.io/altvnk/"
PROJECT_NAME="kubernetes-mesos"
PROJECT_TAG=latest
WORKSPACE=$PWD/rootfs/opt/k8sm

cleanup() {
    rm -rf ${WORKSPACE}
    echo "Workspace deleted: $WORKSPACE"
}

if [[ ! -e ${WORKSPACE} ]]; then
	echo "Binaries not found, let's build them"
	mkdir -p ${WORKSPACE}
	docker run --rm -v ${WORKSPACE}:/target mesosphere/kubernetes-mesos:build
fi

echo "Binaries found:"
ls ${WORKSPACE}

# build docker image
echo "Building kubernetes-mesos docker image"
docker build -t ${REPO}${PROJECT_NAME}:${PROJECT_TAG} .
echo "Docker image ${REPO}${PROJECT_NAME}:${PROJECT_TAG} is built, you can run it or push to the repo"
