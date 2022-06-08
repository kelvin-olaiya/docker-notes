# Docker Compose

*Docker compose* is a tool that helps in deployment of applications. It can manage multi-container applications on a single host only. (It does not work on computer clusters, accross multiple machines).

## The structure of a compose file

The top level entries are:

* version: specifies the version of the Compose file
* service: specifies the services in your application, we used it to define the containers.
* network: you can define the network set-up of your application
* volumes: you can define the volumes used by your application here
* secrets: (Swarm mode only) you can provide secret information like passwords in a secure way to your application services
* configs: you can add external configuration to your containers. Keeping configurations external will make your containers more generic.

## Service configuration options

Typically the **services** entry contains more section for each service, in particular there are entries for build configuration and runtime configuration.

The **deploy** section only applies in Swarm mode.

You can use the **build** section to specify the details of the build. You can define your build **contex**, build arguments (args), dockerfile location and even the target build stage in a multi-stage build.

You can specify runtime parameters in the config file the same way you can specify them with the docker run command. The image section specifies the name of the image to be used to start up containers. If your service has a build section, the resulting image of the build will be tagged with the name that you specify in the image section. You can override the container command in the command section in the Compose file. You can specify an entry point with entrypoint.

You can specify a custom container name, this may be useful if you need the container name in a script, for example.

You can pass environment variable with **environments**

The **deploy** section only applies in Swarm mode.

## Docker compose

The Docker compose command has various subcommands. For help:

```bash
docker-compose --help
```

### Build images with Docker compose

The build subcommand will build all the images that are specified in the *Compose file*. The command will go through all services in the Compose file and build the ones that have a build section defined.

### Build images and create the stack

The command:

```bash
docker-compose up
```

will only build your image if the image does not exists, but if it exists it will not re-build it every time you start up your application.

The command:

```bash
docker-compose up --build
```

will re-build your image if the Dockerfile or image files have changed.

If you need to initiate a build with no cache you can use the 

```bash
docker-compose build --no-cache
```

## Use build arguments

Build arguments are environment variables accessible only during the build process.

First, specify the arguments in your Dockerfile:

```dockerfile
ARG buildno
ARG gitcommithash

RUN echo "Build number: $buildno"
RUN echo "Based on commit: $gitcommithash"
```

The specify the arguments under the `build` key. You can pass a mapping or a list:

```yaml
build:
    contex: .
    args:
        buildno: 1
        gitcommithash: cdc3b19
```
or alternatively

```yaml
build:
    contex: .
    args:
        - buildno=1
        - gitcommithash=cdc3b19
```

> **contex** is either a path to a directory containing a Dockerfile, or a url to a git repository. When the value supplied is a relative path, it is interpreted as relative to the location of the Compose file. This directory is also the build context that is sent to the Docker daemon.

> **Scope of build args**
>
>In your Docker file, if you specify `ARG` before the `FROM` instruction, `ARG` is not available in the build instructions under `FROM`. If you need an argument to be available in both places, also specify the `FROM` instruction.

You can omit the value when specifying a build argument, in which case its value its value at build time is the value in the environment where Compose is running

```yaml
args:
    - buildno
    - gitcommithash
```

## Manage multi-container applications

The following command will list the containers in your applications

```bash
docker-compose ps
```

You can access the Docker native logs of all containers using the command

```bash
docker-compose logs
```

or give a service name

```bash
docker inspect container | grep LogPath
```

To see the processes in your containers use the following command

```bash
docker-compose top
```

You alse have subcommand to start, stop, kill and restart containers for all or some services in your multi-container application with the `start` `stop`, `kill` and `restart` subcommands. In particular the `down` subcommand stop and delete all the containers, networks and volumes created by `docker-compose up`.

The argument `--rmi all` delete the container images also.

```bash
docker-compose down --rmi all
```

## Execute command in a running container

We can execute commands in a running container:

```bash
docker-compose exec [service] [commandname] arguments
```

## Run one-off commands

Sometimes you want to run one-off (una tantum) commands in a container. This can be done using the `docker-compose run` command

```bash
docker-compose run service commandname arguments
```

This is different from the exec subcommand, because run is not executed againts a running container, **run** will start a new container to execute the command. This is useful if you don't want to mess with the running containers.

There is one key difference between **run** and **up**:
when you use **run**, Docker will not map the ports to the host machine. this behavior lets you run one-off commands in new containers even when your stack is running and your container that you started with `docker-compose up` is already mapped to the host port.

If you need to map a port, you can use the `-p` flag of `docker-compose run`

```bash
docker-compose run -p [service] [commandname] [arguments]
```

## Docker compose networks

You can connect your service with custom, user defined networks using the Compose file, as the following example:

```yaml
version: '3'
services:
    app:
        build:
        context: .
        args:
            - IMAGE_VERSION=3.7.0-alpine3.8
        image: takacsmark/flask-redis:1.0
        environment:
            - FLASK_ENV=development
        ports:
            - 80:5000
        networks:
            - mynet
    redis:
        image: redis:4.0.11-alpine
        networks:
            - mynet
networks:
    mynet:
```

We have defined a user defined network under the *top-level networks section* at the end of the file and called the network **mynet**.

This is a bridge network which means that it's a network on the host machine that is isolated from the rest of the host network stack. 

Under each service we added the networks key to specify that these services should connect to mynet.

You can inpect the network configuration with the `docker network inspect` command.

You can use the top-level networks section to specify a more complex network configuration, too. You can specify multiple networks and attach containers to various network segments of your architecture.

## Volumes and compose

The top level volumes section lets you create named volumes for your application.

Volumes are used to store data outside containers. This is handy if you destroy a container and create a new one, your data will not be lost with the container, but it'll be persisted on the host machine in a volume.

Our example uses one volume currently that is used by the Redis image:

```yaml
version: '3'
services:
    redis:
        image: redis:4.0.11-alpine
        networks: 
            - mynet
        volumes:
            - mydata:/data
volumes:
    mydata:
    ...
```

We defined the mydata volume in the top-level volumes section at the end of the file and we mapped this volume with the volumes option to the redis service.

The volume will be stored in a directory in */var/lib/docekr/volumes/*.

Use this command to see available volumes:

```bash
docker volume ls
```

Use this command to see details about a given volume

```bash
docker volume inspect [volume_name]
```

Use this command to remove all unused volumes

```bash
docker volume prune
```

Use this command to remove a given volume

```bash
docker volume rm [volume_name]
```

## Use env_file to pass environment variables

We usually prefer to use environment files in our projects to pass environment variables to our applications. Use the **env_file** option to add an environment file to your service's configuration to pass environment variables.

```yaml
version: '3'
services:
    redis:
        image: redis:4.0.11-alpine
        env_file: env.txt
        networks: 
            - mynet
        volumes:
            - mydata:/data
```

Where *env.txt* contains:

```text
FLASK_ENV=development
```
