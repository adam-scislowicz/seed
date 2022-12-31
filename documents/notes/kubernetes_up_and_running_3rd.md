# Notes

Kubernetes focuses on the stateful management of immutable containers specified declaratively.

## High level concepts

1. **pods**: groups of containers. group together container images developed by different teams into a single deployable unit.
1. **services**: provide load balancing, naming, and discovery to isolate one microservice from another.
1. **namespaces**: provide isolation and access control, so that each microservice can control the degree to which other services interact with it.
1. **ingress objects**: easy-to-use frontend that can combine multiple microservices into a single externalized API surface area.

## Capabilities

- System-level test driven development

## Multi-node Testing w/ Kind

I've installed kind on the host system (*my laptop*) using `brew install kind`

## More Concepts

1. **replica sets**: TBD

## Snippets

```sh
kubectl version --short
```

Note get componentstatuses is depricated.
```sh
kubectl get componentstatuses
```

```sh
kubectl get nodes
```

```
NAME             STATUS   ROLES           AGE     VERSION
docker-desktop   Ready    control-plane   5h46m   v1.25.2
```

```sh
kubectl describe nodes docker-desktop
```

Note that with a *docker-from-docker* setup you will need to modify ~/.kube/config hostname, replacing 127.0.0.1 or localhost with sample-cluster-control-plane, and that must resolve to the IP that host.docker.internal does.

Verify by look at /etc/hosts and comparing the IP associated with sample-cluster-control-plane with what is returned by the host host.docker.internal file.

**docker-from-docker**: Running docker within docker and the hosts /var/run/docker.sock bind mounted into the container where the container version of docker runs.

cat /etc/hosts
```
192.168.65.2 sample-cluster-control-plane
```

host host.docker.internal
```
host.docker.internal has address 192.168.65.2
```

kubectl commands for docker users: https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/
