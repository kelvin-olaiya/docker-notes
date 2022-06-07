# Docker

## Info

Docker has three essential components:
* **Docker engine**, provides the core capabilities of managing containers. It interfaces with the underlying *Linux* operating system to expose simple APIs to deal with the lifecycle of containers.

* **Docker Tools**, they are a set of command-line tools that talk to the API exposed by the Docker Engine. They are used to run the containers, create new images, configure storage and networks, and perform many more operations that impact the lifecycle of a container.

* **Docker Registry**, is the place where container images are stored. Each image can have multiple versions identified through unique tags. Users pull existing images from the registry and push new images to it.
  * [*Docker Hub*](https://hub.docker.com) is a hosted registry mantained by [*Docker, Inc*](https://www.docker.com).
  * It's also possible to run a registry within your onw environments to keep the images closer to the engine.

The following command displays the details of the Docker Engine deployed in the environment:

```bash
docker info
```

```txt
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Docker Buildx (Docker Inc., v0.8.2-docker)
  scan: Docker Scan (Docker Inc., v0.17.0)

Server:
 Containers: 2
  Running: 0
  Paused: 0
  Stopped: 2
 Images: 2
 Server Version: 20.10.15
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 212e8b6fa2f44b9c21b2798135fc6fb7c53efc16
 runc version: v1.1.1-0-g52de29d
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: default
 Kernel Version: 5.13.0-41-generic
 Operating System: Ubuntu 20.04.4 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 8
 Total Memory: 7.653GiB
 Name: kelvin-ubuntu
 ID: PJ23:LGGZ:CZR6:J5IJ:ZYAH:U6DD:DLGM:TMEB:BRI4:LJH7:4T7X:2FKC
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
 ```

 The following command verifies that the Docker Tools are properly installed and configured. It should print the version of both Docker Engine and Tools.

 ```bash
 docker version
 ```

```txt
Client: Docker Engine - Community
 Version:           20.10.15
 API version:       1.41
 Go version:        go1.17.9
 Git commit:        fd82621
 Built:             Thu May  5 13:19:23 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.15
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.17.9
  Git commit:       4433bf6
  Built:            Thu May  5 13:17:28 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.4
  GitCommit:        212e8b6fa2f44b9c21b2798135fc6fb7c53efc16
 runc:
  Version:          1.1.1
  GitCommit:        v1.1.1-0-g52de29d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

## Selecting container

Filters on `docker ps` command allow selecting containers. (`-f` is short for `--filter`)

```bash
docker ps -a -f status=exited
```

By using command substitution we can then remove the exited containers:

```bash
docker rm $(docker ps -a -q -f status=exited)
```

## Parameters of run command

```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARGS...]
```

A large set of parameters can be specified when running a Docker container:
* `-e`, `--env`, set environment variables;
* `-d`, `--detach`, run container in background and print container ID;
* `-i`, `--interactive`, keep STDIN open even if not attached;
* `--name` *string*, assign a name to the container;
* `--network` *string*, connect a container to a network (default is "default");
* `-p`, `--pubish` *list*, Publish a container'port(s) t the host;
* `-h`, `--hostname` *string*, container host name;
* `--ip` *string*, IPv4 address (e.g., 172.30.100.104);
* `--ip6` *string*,IPv6 address (e.g., 2001:db8::33);
* `-v`, `--volume` *list*, bind mount a volume;
* `--expose` *list*, expose a port or a range of ports;
* `--rm`, automatically remove the container when it exits.

## Running a container and a specific command

```bash
docker run -it --name myubuntu ubuntu /urs/bin/find / -iname '*.sh'
```

When the command *find* terminates, the containers stops.

## Environment variables

```bash
docker run -it -e "VAR=VARCONTENT" --name myubuntu ubuntu
```

## Running in background

```bash
docker run -d --name myubuntu ubuntu
```

## Execute interactively a command in a running background container

``` bash
docker run -d -it --name myubuntu ubuntu
```

```bash
docker exec [OPTIONS] CONTAINER COMMAND [ARGS]
```

```bash
docker exec -u root:root -w /usr/local myubuntu find ./ -iname '*ma*'
```

- `-u`, `--user` *string*, username or UID (format: <name|uid>[:<group|gid>]);
- `-w`, `--workdir` *string*, working directory inside the container;

## Execute a background command in a running background container

By adding the `-d` flag:

```bash
docker exec -d -u root:root -w /usr/local myubuntu find ./ -iname '*ma*'
```

## Attach an interactive shell to a running background container

By using the `docker attach` subcommnand and specifying the *container name* or the *container id*

```bash
docker attach myubuntu
```

After this, the stdin, stdout, stderr stream are connected to the respective streams of a bash running in the container.

If you execute the `exit` command in the shell the container stops.

## Detach a foreground container and turn it stopped but non exited

To detach the container you must type ***CTRL + p*** and ***CTRL + q***, the container stops but does not exit. You can attach againg to the container with the `docker attach` subcommand.

## Mount shared Storage to containers

The `-v` option points a **directory within the container** to a **directory in the host's filesystem**. Any changes made in those directory will be visible at both locations.

```bash
docker run -p 8888:80 --name web -d -v /home/kelvin/htdocs:/usr/local/apache2/htdocs httpd
```
With the previous command we want to start a container named **web** (`--name` option) from an image called **httpd** mapping:
* The container's port number *80* to the host port number *8888* (using `-p`);
* The container directory */usr/local/apache2/* to the host */home/kelvin/htdocs* directory (using `-v`).

> NOTE: When mapping directories from/to containers, you must pay attention to files permissions.

## Autoremove container on exit

The `--rm` flag automatically removes the container when it exits.

```bash
docker run -it --rm ubuntu
```
