# Running Kubernetes-Mesos In Docker

`MESOS_IP` - IP that mesos is accessible on (default mesos.service.consul)
`MESOS_PORT` - Port that mesos-master is accessible on (default 5050)
`ETCD_IP` - IP that etcd is accessible on (no default value)
`ETCD_PORT` - Port that etcd is accessible on (default 4001)
`LOG_DIR` - Directory to write logs to (default /tmp/k8sm-logs)

### Daemon mode

```
docker run -d --name kubernetes-mesos -p 4888:4888 altvnk/kubernetes-mesos
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
docker run -it --name kubernetes-mesos -p 8888:8888 --entrypoint=/bin/bash altvnk/kubernetes-mesos
```

Note: Interactive mode launches bash instead of the start script.

### Stopping

```
docker kill kubernetes-mesos
```

### Building

```
./build.sh
```