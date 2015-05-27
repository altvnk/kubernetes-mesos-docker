# Running Kubernetes-Mesos In Docker

## Building

To build container you need to have running Docker daemon locally, then you can run:
```
./build.sh
```
Above command builds kubernetes-mesos binaries from source in docker container and places them into `./km` folder.
Binaries are building only first time you run `./build.sh` in cloned repo. To re-build just run `./build.sh cleanup`
Docker container name is `kubernetes-mesos`

## Running container

### Environment varibles

- `MESOS_IP` - IP that mesos is accessible on (default mesos.service.consul)
- `MESOS_PORT` - Port that mesos-master is accessible on (default 5050)
- `ETCD_IP` - IP that etcd is accessible on (no default value)
- `ETCD_PORT` - Port that etcd is accessible on (default 4001)
- `LOG_DIR` - Directory to write logs to (default /tmp/k8sm-logs)

### Daemon mode
To run container in daemon mode you must specify `etcd` node ip an other values if they are not default one. It can be done via environment variables.
For example, if etcd is accessible via 10.11.12.13 you can run:
```
docker run -d --name kubernetes-mesos -p 4888:4888 -e "ETCD_IP=10.11.12.13" kubernetes-mesos
```

To see the logs:
```
docker logs kubernetes-mesos
```

To attach in interactive mode to a container already running in daemon mode:

```
docker exec -it kubernetes-mesos /bin/bash
```

### Interactive mode

```
docker run -it --name kubernetes-mesos -p 8888:8888 --entrypoint=/bin/bash kubernetes-mesos
```

Note: Interactive mode launches bash instead of the start script.

### Stopping

```
docker kill kubernetes-mesos
```

