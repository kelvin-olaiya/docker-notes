# Docker Swarm

## The Swarm structure

A **swarm** is composed by one or more **nodes** (machine). A given node plays the role of docker swarm **manager**. Each other nodes play the role of **worker**. Thus, the manager node plays both the roles of manager and worker.

The swarm need to be initialized by setting up the manager using the `docker swarm init` command in the manager node. This command changes the working "mode" of the docker engine of the node from **sigle node** to **swarm**.

A swarm can run a **stack**. A stack is a group of services. Each service is the service seen in Compose: a **service** is a container image and its structures (newtorks, volumes, ...).

A service can be deployed over multiple workers of the swarm, creating multiple container instances (tasks) on each worker node. Each container instance is called **task**.

Each task of a service is a **replica** of that service. A worker can host more replicas of a given services.

Each worker can run more containers (replicas) of one or more services.

In essence, a **stack** is a set of **tasks** (working containers), grouped in services, running over a cluster of worker nodes and coordinated by a **manager** node. 

The manager coordinates the workers and distributes the task among the worker nodes. The manager receives the client requests and distributes them to the service tasks instantiated on the workers.

## Network assumptions

Docker swarm manager uses **iptables** to forward the client connections to the selected replica.

## Swarm operations

```bash
docker swarm init --advertise-addr 10.133.7.101
```

```bash
docker service create --name myregistry --publish published=5000,target=5000,registry:2
```

```bash
docker service ls
```

```bash
docker stack deploy --compose-file docker-compose-v3.yml mystack
```

```bash
docker stack services mystack
```

```bash
docker swarm join --token SWMTKN-1-4oj8bfuo7wk1jh0kgymq33xosmj5rv94zn3r89nfhaurdr7290-73ilqpldlphdxopip9ibc3dpt 10.133.7.101:2377
```

```bash
docker service scale mystack_tcpreplayservice=2
```

```bash
docker node ls
```

```bash
docker node update --availability drain node-1
```

```bash
docker swarm leave
```

```bash
docker stack rm mystack
```

```bash
docker service rm mystack_tcpreplayservice
```

```bash
docker service rm myregistry
```

```bash
docker swarm leave --force
```
