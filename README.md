# atsistemas/docker-mongo-replication-configurator

A Dockerfile for create a container to configure replication set in nodes. All nodes must to have same hostname prefix (example: mongosrv-1,mongosrv-2,...)


The container admin 3 parameters:

* `REPLICAS_NUMBER`: number of mongodb replicas/server
* `REPLICASET_NAME`: Name of the replica set
* `NODE_PREFIX`: Hostname prefix for all nodes

Once all server are up and running. This docker configure replicas and died.

How to run in swarm. Example for 5 nodes named "mongodbsrv-X"

docker service create --name configurator --network "mongodb-net" --restart-max-attempts 30 \
    -e REPLICAS_NUMBER=5 -e REPLICASET_NAME=repset -e NODE_PREFIX=mongodbsrv \
    atsistemas/docker-mongo-replication-configurator:1.0
