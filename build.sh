#!/usr/bin/env bash

if [[ "$1" != "" ]]; then
    REPO="$1"
else
    REPO=""
fi

PROJECT_NAME="kubernetes-mesos"
PROJECT_TAG=latest
WORKSPACE=$PWD/km

cleanup() {
    rm -rf ${WORKSPACE}
    echo "Workspace deleted: $WORKSPACE"
}

if [[ ! -e ${WORKSPACE}/km ]]; then
	echo "Binaries not found, let's build them"
	mkdir ${WORKSPACE}
	docker run --rm -v ${WORKSPACE}:/target mesosphere/kubernetes-mesos:build
fi

echo "Binaries found:"
ls ${WORKSPACE}

# build docker image
echo "Building kubernetes-mesos docker image"
docker build -t ${REPO}/${PROJECT_NAME}:${PROJECT_TAG} .
echo "Docker image ${REPO}${PROJECT_NAME}:${PROJECT_TAG} is built, you can run it or push to the repo"