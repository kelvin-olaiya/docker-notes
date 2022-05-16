# Networks

Docker's networking subsystem is pluggable, using drivers. Several drivers exist by default, and provide core networking functionality: **bridge, host, overlay, macvlan, none, custom network plugins**.

You can assign a driver to a container using the `--network` option. If not specified, the default is the *bridge* network driver.

When you start Docker, a default bridge network (also called bridge) is created automatically, and newly-started containers connect to it unless otherwise specified. The default bridge networks allow container to connect to external service.

You can also create user-defined custom bridge networks.

A bridge newtork allows containers connected to the same bridge network to communicate, while providing isolation from containers which are not connected to that bridge network.

The Docker bridge driver automatically installs rules in the host machine so that containers on different bridge networks cannot communicate directly with each other.

Bridge networks apply to containers running on the same Docker daemon host. For communication among containers running on different Docker daemon host, you can either manage routing at the OS level, or you can use an overlay netwwork.

## Network drivers types:

* **bridge**: If you don’t specify a driver, this is the type of network you are
creating. Bridge networks are usually used when your applications run in
standalone containers that need to communicate to each other. Bridge networks
allow container to connect to external service. You can create a custom bridge.

* **host**: For standalone containers, remove network isolation between the
container and the Docker host, and use the host’s networking directly. host is
only available for swarm services on Docker 17.06 and higher.

* **overlay**: Overlay networks connect multiple Docker daemons together and enable
swarm services to communicate with each other. You can also use overlay
networks to facilitate communication between a swarm service and a standalone
container, or between two standalone containers on different Docker daemons.
This strategy removes the need to do OS-level routing between these containers.

* **macvlan**: Macvlan networks allow you to assign a MAC address to a container,
making it appear as a physical device on your network. The Docker daemon routes
traffic to containers by their MAC addresses. Using the macvlan driver is
sometimes the best choice when dealing with legacy applications that expect to
be directly connected to the physical network, rather than routed through the
Docker host’s network stack.

* **none**: For this container, disable all networking. Usually used in conjunction with a
custom network driver.

## Default bridge network

### Enable forwarding from Docker containers to the outside world

By default, traffic from containers conncected to the default bridge network is *not* forwarded to the outside world. To enable forwarding, you need to change two kernel-lev settings.

1. Configure the Linux kernel to allow IP forwarding;
    ```bash
    sysctl net.ipv4.conf.all.forwarding=1
    ```
2. Change the policy for the iptables FORWARD policy from DROP to ACCEPT.
    ```bash
    sudo iptables -P FORWARD ACCEPT
    ```
    `-P`, `--policy` *chain* *target*, change policy on *chain* to *target*.

These settings do not persist accross a reboot, so you may need to add them to a start-up script.

### Use the default bridge network

The default bridge network is considered a legacy detail of Docker and is not recommended for production use. User-defined bridge network should be used.

### Connect a container to the default bridge network

If you do not specify a network using the `--network` flag, your container is connected to the default bridge network by default.

## Configure  default bridge network

### Enable forwarding from Docker containers to the outside world

To configure the default bridge network, you may specify options in daemon.json.
Here is an example daemon.json with several options specified. Only specify the settings you need to customize

```json
{
"bip": "192.168.1.5/24",
"fixed-cidr": "192.168.1.5/25",
"fixed-cidr-v6": "2001:db8::/64",
"mtu": 1500,
"default-gateway": "10.20.1.1",
"default-gateway-v6": "2001:db8:abcd::89",
"dns": ["10.20.1.2","10.20.1.3"]
}
```

Restart Docker for the changes to take effect.

