# Docker

## Installing Docker

Update your package list:

```bash
sudo apt update
```

install some packages to allow **apt** to use packages over https:

```bash
sudo apt install apt-transport-https ca-certificates curl software-propertites-common
```

add the GPG key for the official Docker repository to your system:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

add the Docker repository to apt sources:

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
```
On Ubuntu 18.04

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
```

update the package database

```bash
sudo apt update
```

verify the repository (docker repo)

```bash
apt-cache policy docker-ce
```

Install docker

```bash
sudo apt install docker-ce docker-ce-cli containered.io
```

Check that docker daemon is running

```bash
sudo systemctl status docker
```

Installing docker now gives you not just the Docker service (daemon) but also the docker command utility (Docker client)

## Executing Docker without sudo

By default, the docker command can only be run by the root user or by a user in the docker group, which is automatically created during the installation process.

If you want to avoid typing sudo whenever you run the docker command, add your username to the docker group:

```bash
sudo usermod -aG docker ${USER}
```

Confirm that your user is now in the docker's group by typing:

```bash
id -nG
```

reload user:

```bash
su - ${USER}
```

## Working with Docker images

Docker containers are built from Docker images. By default docker pulls these images from the [Docker Hub](https://hub.docker.com/), a docker registry manages by docker.

You can download a container image and run it, by using the **run** command.
To check wheter you can access and download images from Docker Hub, type:

```bash
docker run hello-world
```

The following output will indicate tha Docker is working correctly:

```text
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:80f31da1ac7b312ba29d65080fddf797dd76acfb870e677f390d5acba9741b17
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
 ```

Docker was intially unable to find the *hello-world* image locally, so it downloaded the image from Docker Hub. Once the images was downloaded, Docker created a container from the image and the application withing the contatiner executed, displaying the message. The downloaded images it copied into a local storage.

## Searching and loading docker images

With the docker's **search** subcommand you can search for images in the Docker Hub.

```bash
docker search ubuntu
```

It will crawl the Docker Hub and return a listing of all images whose name match the search string. The output will be similar to this:
```text
NAME                             DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
ubuntu                           Ubuntu is a Debian-based Linux operating sys…   14221     [OK]       
websphere-liberty                WebSphere Liberty multi-architecture images …   284       [OK]       
ubuntu-upstart                   DEPRECATED, as is Upstart (find other proces…   112       [OK]       
neurodebian                      NeuroDebian provides neuroscience research s…   89        [OK]       
open-liberty                     Open Liberty multi-architecture images based…   52        [OK]       
ubuntu/nginx                     Nginx, a high-performance reverse proxy & we…   48                   
ubuntu-debootstrap               DEPRECATED; use "ubuntu" instead                46        [OK]       
...
bitnami/ubuntu-base-buildpack    Ubuntu base compilation image                   0                    [OK]
```
In the *OFFICIAL* column, **OK** indicates an image built and supported by the company behind the Docker project. Once you've identified the images that you would like to use, you can download it using the **pull** subcommand.

```bash
docker pull ubuntu
```

After an images has been download, you can the run a container using the download image with the above mentioned *run* subcommand.

To see the images that have been downloaded to your computer, type:

```bash
docker images
```

## Remove local docker images

You can remove the images in your computer by using the docker subcommand **rmi** (remove image). The command requires a list of images to be removed. The generic syntax is:

```bash
docker rmi imagename1 imagename2 ... imagenameN
```

## Running a Docker container

Containers can be interactive. By executing the *run* subcommand with the `-i` (short for `--interactive`) and `-t` (short for `--tty`) options you can obtain interactive shell access (using stdin / stdout / stderr) into the container.

```bash
docker run -it ubuntu
```

or 

```bash
docker run --name myubuntu ubuntu
```

The `--name` option assigns the name *myubuntu* to the container. If this option is not specified, docker cread and assignes a random name to the container.

The command prompt should take this form:

```bash
root@d9b100f2f636:/#
```

Notice the container id in the command prompt. In this example it's **d9b100f2f636**. You'll need that container id to identify the container when you want to remove it.

## Running commands in a container

Once you have the interactive shell controll you can run any command inside the myubuntu container.
You can for example install *node.js*.

Any changes you make inside the container only apply to tha container. To exit the container, type `exit` at the prompt.

If you restart the container, the previous node.js intallation has been lost.

## Managing Docker containers

After using Docker for a while, you'll have many active (running) and inactive containers on your computer.

To view active containers:

```bash
docker ps
```

The output will be similar to the following

```text
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
....           ....      .....     ....      ....      ....      ....
```

To view all containers (active and inactive), run (`-a` is short for `--all`):

```
docker ps -a
```

You will obtain an output similar to:

```text
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
595038d529f8   hello-world   "/hello"   40 minutes ago   Exited (0) 40 minutes ago             clever_gates
f223a82cc664   ubuntu        "bash"     3 weeks ago      Exited (0) 3 weeks ago                cranky_beaver
```

To view the latest created container use the `-l` (short for `--latest`) option:

```bash
docker ps -l
```

## Start and stop Docker containers

To stop a container use docker **stop**, followed by the ***container ID*** or the ***container name***

```bash
docker stop myubuntu
```

```bash
docker stop d9b100f2f636
```

To start a stopped container, use docker *start*, followed by the ***container ID*** or the ***container name***

```bash
docker start d9b100f2f636
```

or

```bash
docker start -ia d9b100f2f636
```

Where `-i` (short for `--interactive`) attach the container's STDIN anc the `-a` (short for `--attach`) option attach STDOUT, STDERR and forwards signals.

The container will start and you can use *docker ps* to see its status.

## Removing docker containers

Once you've decided you no longer need a container anymore, remove it with the **rm** subcommand, using either the *container ID* or the *container name*. Use the `docker ps -a` command to find the ID or the name of the container you want to remove.

```bash
docker rm festive_williams
```

The is a way to remove all containers at once by using command substitution. The **ps* with the `-q` (short for `--quiet`) options will list only the container's *ids*. Therefor running `docker ps -aq` will list all containers ids. The overall command is:

```bash
docker rm $(docker ps -aq)
```

## Committing changes in a container creating a new Docker image

The changes that you make in a container will only apply to that particular container. If you destroy with the `docker rm` command, the changes will be lost for good.
Fortunately, you can save the state of a container as a new Docker image.

For example after intalling node inside the Ubuntu container, you could stop the containter and commit the changes to a new Docker image using the following command

```bash
docker commit -m "added node.js" -a "kelvin_olaiya" e602dd6d84c4 kelvin_olaiya/ubuntu_with_node.js
```

The `-m` (short for `--message`) is for the commit message that helps you and others konw what changes had been made.
The `-a` (short for `--author`) is used to specify the author. Unless you created additional repositories on Docker Hub the repository is usually your Docker Hub username.

When you commit as image, the new image is saved **locally** on your computer. Listing the Docker images will show the new image as well as the old one from which it was derived from.

## Pushing a Docker image to a Docker repository

To push an image to Docker Hub or any other registry, you must have an account there.
Create your own private Docker registry at [https://id.docker.com]()

Log into Docker Hub

```bash
docker login -u docker-registry-username
```

You'll be prompted to authenticate using your Docker Hub password. If you specified the correct password, authentication should succeed.

Push your own image using:

```bash
docker push docker-registry-username/docker-image-name
```

After pushing an image to a registry, it should be listed on your account's dashboard.