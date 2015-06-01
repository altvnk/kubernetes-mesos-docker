#!/usr/bin/env bash

REPO="docker.io/altvnk/"
PROJECT_NAME="kubernetes-mesos"
PROJECT_TAG=s6
BINDIR=${PWD}/bin
TARGET=${PWD}/rootfs/opt/k8sm

cleanup() {
    rm -rf ${TARGET} ${BINDIR}
    echo "Workspace deleted: $WORKSPACE"
}

if [[ ! -e ${BINDIR}/km ]]; then
	echo "Binaries not found, let's build them"
	mkdir -p ${BINDIR}
	docker run --rm -v ${BINDIR}:/target mesosphere/kubernetes-mesos:build
	cp ${BINDIR}/km ${TARGET}/km
fi

echo "Binaries found:"
ls ${TARGET}

# build docker image
echo "Building kubernetes-mesos docker image"
docker build -t ${REPO}${PROJECT_NAME}:${PROJECT_TAG} .
echo "Docker image ${REPO}${PROJECT_NAME}:${PROJECT_TAG} is built, you can run it or push to the repo"
