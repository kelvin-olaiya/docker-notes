# Docker user-defined network

## Docker inspect command

```bash
docker inspect [OPTIONS] NAME|ID [NAME|ID ...]
```

Returns low-level informations on Docker objects. By the default the output is rendered in JSON format.

You can specify `--format` argument (using *Go* syntax) to show selected parts only.

---

```bash
docker run --name myubuntu ubuntu
```

```bash
docker inspect myubuntu
```

Let's see network informations (some parts have been taken off):

```json
/*...*/
"NetworkSettings": {
            "Bridge": "",
            /*...*/
            "Ports": {},
            /*...*/
            "Gateway": "172.17.0.1",
            /*...*/
            "IPAddress": "172.17.0.2",
            /*...*/
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    /*...*/
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    /*...*/
                    "MacAddress": "02:42:ac:11:00:02",
                    /*...*/
                }
            }
        }
/*...*/
```

### Networks

```bash
docker inspect --format='{{json .NetworkSettings.Networks}}' myubuntu
```

### Ip address of the bridge network

```bash
docker inspect --format='{{json .NetworkSettings.Networks.bridge.IPAddress}}' myubuntu
```

### Container's IP address

```bash
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myubuntu
```

### Container's MAC addreass

```bash
docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' myubuntu
```

## Docker network inspect command

```bash
docker network inspect bridge
```

```json
[
    {
        "Name": "bridge",
        "Id": "b9504f737257e2f2d2c09947fa7b2cd4a3cce706f414ec47e85b72142739eb39",
        "Created": "2022-05-19T12:25:25.465602609+02:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "00dab000100749fdf0756f2db764e7cdea9213212d06c261ce458009bdec8cbe": {
                "Name": "myubuntu",
                "EndpointID": "6fcdc03b5c15944690bb02149da2dd3253354a484978fbb306363a328f265c71",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

```bash
docker network inspect --format='{{json .Options}}' bridge
```

```json
{
    "com.docker.network.bridge.default_bridge":"true",
    "com.docker.network.bridge.enable_icc":"true",
    "com.docker.network.bridge.enable_ip_masquerade":"true",
    "com.docker.network.bridge.host_binding_ipv4":"0.0.0.0",
    "com.docker.network.bridge.name":"docker0",
    "com.docker.network.driver.mtu":"1500"
}
```

## Work with Network command

These are the network subcommand you can use to interact with Docker networks and the containers in them:

* docker network create
* docker network connect
* docker network ls
* docker network rm
* docker network disconnect
* docker network inspect

## Create user-defined bridge networks

Docker engine creates a bridge network automatically when you install the engine. This network corresponds to the **docker0** bridge that Docker Engine has traditionally relied on. In addition to this network, you can create your own bridge or overlay network.

A bridge network relies on a single host running as instance of the Docker Engine. Instead, an overlay network can span multiple host running their engines. If you run `docker network create` and only supply a *network name*, it creates a bridge network for you.

```bash
docker network create simple-network
```

With the `-d` (short for `--driver`) option you can specify the driver witch manages the network (default is bridge)

```bash
docker network create -d bridge simple-network
```

You can run the following command to show the network configuration

```bash
docker network inspect simple-network
```

The following command displays the available networks on your host

```bash
docker network ls
```

```txt
NETWORK ID     NAME             DRIVER    SCOPE
b9504f737257   bridge           bridge    local
82f3abe16834   host             host      local
0d3f298216b5   none             null      local
34645871dbf1   simple-network   bridge    local
```

To delete a given network run the following:

```bash
docker network rm NETWORK_NAME|NETWORK_ID
```

```bash
docker network rm simple-network
```

> It is highly recommended to use the `--subnet` option while creating a network. If the `--subnet` is not specified, the docker daemon automatically chooses and assings a subnet for the network and it could overlap with another subnet in your infrastructure that is not managed by docker. Such overlap can cause connectivity issues or failures when containers are connected to that network.

Only overlay network supports multiple subnets.

In addition to the `--subnet` option, you can also specify the `--gateway` and several `--aux-address` options.

## Network create options for bridge network driver

## Network create options for any network drivers

## Create container attached to a network

The following example uses `-o` (short for `--opt`, options) to bind to a specific IP address on the host when binding ports, then uses docker network inspect to inspect the network, and finally attaches a new container to the new network.

```bash
docker network create -o "com.docker.network.bridge.host_binding_ipv4"="10.0.2.15" my-network
```

```bash
docker run -d -P --name redis --network my-network redis
```

The `-P` is short for `--publish-all`, which map all exposed port to random host ports

## Attach container to a network

You can connect an existing container to one or more networks. A container can connect to networks which use different network drivers. Once connected, the containers can communicate using another container's **IP address** or **name**.

Create and run two containers, *container1* and *container2*

```bash
docker run -itd --name container1 busybox
```

```bash
docker run -itd --name container2 busybox
```

Create an isolated, bridge network to test with

```bash
docker network create -d bridge --subnet 10.2.2.0/24 isolated_nw
```

Connect container 2 to isolated_nw network:

```bash
docker network connect isolated_nw container2
```

Container2 is assigned an IP address automatically. Because you specified a `--subnet` when creating the network, the IP address was chosen from that subnet.

Start a third container, but this time assign it an IP address using the `--ip` flag and connect it to the isolated_nw network using the `docker run` command's `--network` option.

```bash
docker run --network isolated_nw --ip 10.2.2.3 -itd --name container3 busybox
```

Inspect container2 and container3

```bash
docker inspect container2
```

Container 2 belongs to two network (eth0 and eth1). It joined the default bridge network when it was launched and isolated_nw when it was attached to it.

We can see this by attaching to container2 and examine the container's network stack

```bash
docker attach container2
```

Then in the container's shell run:

```bash
ifconfig -a
```

Now inspect container3:

```bash
docker inspect container3
```

Container 3 is not attached to the deafault bridge network.

When you specify an IP address by using the `--ip` or `--ip6` flag while using a *user-defined* network the configuration is preserved as part of the container's configuration and will be applied when the container is reloaded (after saving the image).

Since there's non guarantee that the container's subnet will not change when the Docker daemon restarts, assigned IP addresses are not preserved when using *non user-defined* networks.

## Docker embedded DNS server

The Docker embedded DNS server enables name resolution for containers connected to a given network. This means that any connected container can ping another container **on the same network** by its container name.


