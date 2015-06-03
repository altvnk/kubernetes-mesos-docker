# Running Kubernetes-Mesos In Docker

## Building

To build container you need to have running Docker daemon locally, then you can run:
```
./build.sh
```
Above command builds kubernetes-mesos binaries from source in docker container and places them into `./km` folder.
Binaries are building only first time you run `./build.sh` in cloned repo.

## Running container

### Environment varibles

- `K8SM_HOME` - Folder on filesystem where binaries will be placed (/opt/k8sm)
- `K8SM_PORT` - Kubernetes API is listening (8888)
- `K8SM_PORTAL` - Kubernetes portal network (10.10.10.0/24)
- `MESOS_HOST` - IP that mesos is accessible on (default mesos.service.consul)
- `MESOS_PORT` - Port that mesos-master is accessible on (default 5050)
- `ETCD_HOST` - IP that etcd is accessible on (no default value)
- `ETCD_PORT` - Port that etcd is accessible on (default 4001)
- `LOG_DIR` - Directory to write logs to (default /var/logs/km-<servicename>)


### Daemon mode
To run container in daemon mode you must specify `etcd` node ip an other values if they are not default one. It can be done via environment variables.
For example, if etcd is accessible via 10.11.12.13 you can run:
```
docker run -d --name kubernetes-mesos -p 8888:8888 -e "ETCD_HOST=10.11.12.13" kubernetes-mesos
```

To see the logs:
```
docker logs kubernetes-mesos
```

To attach in interactive mode to a container already running in daemon mode:

```
docker exec -it kubernetes-mesos /bin/sh
```

### Interactive mode

```
docker run -it --name kubernetes-mesos -p 8888:8888 kubernetes-mesos /bin/sh
```

Note: Interactive mode launches bash instead of the start script.

### Stopping

```
docker kill kubernetes-mesos
```