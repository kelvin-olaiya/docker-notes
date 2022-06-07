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

You can specify runtime parameters in the Config file the same way you can specify them with the docker run command. The image section specifies the name of the image to be used to start up containers. If your service has a build section, the resulting image of the build will be tagged with the name that you specify in the image section. You can override the container command in the command section in the Compose file. You can specify an entry point with entrypoint.

You can specify a custom container name, this may be useful if you need the container name in a script, for example.

You can pass environment variable with **environments**

The **deploy** section only applies in Swarm mode.

## Docker compose

The Docker compose command has various subcommands. For help:

```bash
docker-compose --help
```

