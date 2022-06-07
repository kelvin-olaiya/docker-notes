# Dockerfile

A *Dockerfile* is a script tha contains collections of commands and instructions that will be automatically executed in sequence in the docker environment for building a new docker image. 

## Dockerfile commands

| Command | Description |
|---------|-------------|
| FROM | The base image for building a new image. This command must be a the top of the dockerfile|
| MAINTAINER | This is optional. It contains the name of the maintainer of the image |
| RUN | Used to execute a command **during the build process** of the docker image. It can be used multiple times |
| COPY | Copy a file from the host machine to the new docker image. |
| ADD | Same as *COPY* but there is an option to use an URL for the source file to be copied, docker will then download that file to the destination directory |
| ENV | Define ad environment variable. After a variable has been defined it can be used in the following commands |
| CMD | Used for executing commands **when we build a new container** from the docker image |
| ENTRYPOINT | Define the default command that will be executed when the container is running |
| WORKDIR | This is directive for CMD command to be executed |
| USER | Set the user or UID for the container created with the image |
| VOLUME | Enable access/linked directory between the container and the host machine |