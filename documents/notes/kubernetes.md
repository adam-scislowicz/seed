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

Creating a kubernetes namespace:
```sh
$ kubectl config set-context my-context --namespace=mystuff
```

Utilizing or selecting a namespace:
```sh
$ kubectl config use-context my-context
```

Contexts can also be used to manage different clusters or different users for authenticating to those clusters using the --users or --clusters flags with the set-context command.

Get a brief report on the pods and services:
```sh
$ kubectl get pods,services
```

You can increase the verbosity of output byb adding '-o wide', furthermore you can output in a structured format like JSON or YAML using the following options: '-o json' or '-o yaml'.

You can also strip headers from human readable output by adding the following command line argument: '--no-headers'

You can also obtain a list of valid fields for a given object by using the explain command:
```sh
$ kubectl explain pods
```

The '--watch' flag can be added to a command to show continual updates.


Objects in kubernetes can be described by JSON or YAML formatted files. If you would like to apply an object you can use the following command:
```sh
$ kubectl apply -f obj.yaml
```

You can also obtain information regarding the state that was last applied to an object with the following command:
```sh
$ kubectl apply -f myobj.yaml view-last-applied
```

An object can be deleted with the following command:
```sh
$ kubectl delete -f obj.yaml
```

Labels, which are keys having associated values can be added to objects as follows:
```sh
$ kubectl label pods bar color=red
```

The '<label>-' with the '-' as the suffix will allow you to remove a label:
```sh
$ kubectl label pods bar color-
```

The following command will allow you to observe a pods (running container) log.
```sh
$ kubectl logs <pod-name>
```

To get a shell on an existing pod or container you can use the following:
```sh
$ kubectl exec -it <pod-name> -- bash
```

You can attach to an already running process with the following:
```sh
$ kubectl attach -it <pod-name>
```

To copy files into a running container you can use the following command:
``sh
$ kubectl cp <pod-name>:</path/to/remote/file> </path/to/local/file>
```

To forward traffic from the local machine to a pod use the following:
```sh
$ kubectl port-forward <pod-name> 8080:80
```

To see the latest 10 events within a namespace you can use the following command:
```sh
$ kubectl get events
```
To continue to see new events you can add '--watch' to the above command:

If you would like to observe overall resource usage on the console for your namespace you can use the following command:
```sh
$ kubectl top nodes
```

or
```sh
$ kubectl top pods
```
add '--all-namespaces' to see resource usage for the whole cluster, rather than just your current namespace.

Linux cgroup: A cgroup is a Control group. cgroups allow processes to be organized into hierarchical groups whose usage of various types of resources can then be limited and monitored.

The kernel's cgroup interface is provided through a pseudo-filesystem called cgroupfs.

According the the cgroups manpage: "A **cgroup** is a collection of processes that are bound to a set of limits or parameters defined via the cgroup filesystem"

and: "A **subsystem** is a kernel component that modifies the behavior of the processes in a cgroup. Various subsystems have been implemented, making it possible to do things such as limiting the amount of CPU time and memory available to a cgroup, accounting for the CPU time used by a cgroup, and freezing and resuming execution of the processes in a cgroup. Subsystems are sometimes also know as **resource controllers**." ... "The cgroups for a controller are arranged in a hierarchy. This hierarchy is defined yb creation, removing, and renaming subdirectories within the cgroup filesystem"...

For more info on the above see `man 7 cgroups`

In kubernetes the smallest unit of deployment is the pod. A pod contains one or more containers, all associated with, or in other words under the same cgroup.

Pods are described in a **pod manifest**. Manifests's are declarative. From the book "Kubernetes strongly believes in a **declarative configuration**, which means that you write down the desired state of the world in a configuration file and the submit that configuration to a service that takes actions to ensure the desired state becomes the actual state.

Pod manifests are stored using etcd, after being accepted by the Kubernetes API. The kubernetes scheduler maps pods to Kubernetes nodes. The scheduler is mindful of the desire for node replica's to be mapped to separate machines when possible.

Once scheduled to a node, Pods don't move and must be explicitly destroyed and rescheduled.

Pods can be created using the kubectl run command. Here is a simple example:
```sh
$ kubectl run kuard --generator=run-pod/v1 \
  --image=gcr.io/kuar-demo/kuard-amd64:blue
```

You can query the current status of pods using the following command:
```sh
$ kubectl get pods
```

In the above command, you may see that a pod is 'Pending', or 'Running' among other states.


pods can be deleted as follows:
```sh
$ kubectl delete pods/kuard
```

## Pod Manifests

Pod manifests can be in either JSON or YAML formats, YAML is preferred.

Exaple pod specification:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    - image: gcr.io/kuar-demo/kuard-amd64:blue
      name: kuard
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

In addition to run, there is an apply method. The differences between these will be covered later, but apply is roughly more declarative and in relation to a manifest.
```sh
$ kubectl apply -f kuard-pod.yaml
```

From the book: "The Pod manifest will be submitted to the Kubernetes API server. The Kubernetes system will then schedule that Pod to run on a healthy node in the cluster, where the kubelet daemon will monitor it."

start again at 17:24

For more information about a pod, you can use the describe command instead of get as follows:
```sh
$ kubectl describe pods kuard
```

Which produces output similar to the following:
```
Name:           kuard
Namespace:      default
Node:           node1/10.0.15.185
Start Time:     Sun, 02 Jul 2017 15:00:38 -0700
Labels:         <none>
Annotations:    <none>
Status:         Running
IP:             192.168.199.238
Controllers:    <none>
...
Containers:
  kuard:
    Container ID:  docker://055095...
    Image:         gcr.io/kuar-demo/kuard-amd64:blue
    Image ID:      docker-pullable://gcr.io/kuar-demo/kuard-amd64@sha256:a580...
    Port:          8080/TCP
    State:         Running
      Started:     Sun, 02 Jul 2017 15:00:41 -0700
    Ready:         True
    Restart Count: 0
    Environment:   <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-cg5f5 (ro)
```

the pod deletion command comes in two forms:
```sh
$ kubectl delete pods/kuard
```

and

```sh
$ kubectl delete -f kuard-pod.yaml
```

Furthermore, when you issue a command to delete a pod, it will not be immediately executed. Instead you may notice that it will transiently hold the state 'Terminating'. The default grace period for termination is 30 seconds. In a service scenario the grace period is important, as that is the time that a pod will have to complete any active requests.

You can access the logs for the current or previous instance of a pod using the following commands:
```sh
$ kubectl logs kuard
```

or

```sh
$ kubectl logs kuard --previous
```

If logs are not sufficient you can use the exec command to run the command within the context of the container.
```sh
$ kubectl exec kuard -- date
```

You can also run it in interactive mode as follows:
```sh
$ kubectl exec -it kuard -- ash
```

### Liveness Probe

Containers that fail a liveness probe will be restarted.

Here you can see an example pod manifest with a liveness probe utilizing an HTTP GET request:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    - image: gcr.io/kuar-demo/kuard-amd64:blue
      name: kuard
      livenessProbe:
        httpGet:
          path: /healthy
          port: 8080
        initialDelaySeconds: 5
        timeoutSeconds: 1
        periodSeconds: 10
        failureThreshold: 3
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

### Readiness Probe

In addition to liveness probe's kubernetes supports the concept of a readiness probe. Readiness denotes that an application is ready to serve user requests.

### Startup Probe

A startup probe has recently (when?) been added to Kubernetes. These are an alternative means of managing slow-starting containers. A startup probe proceeds until either it times out, in which case the pod is restarted, or it succeeds, at which time the liveness probe takes over.

The startup probe allows one to probe more slowly while waiting for initial startup, and then probe within the latency requirements of the service when the liveness probe takes over.

In addition to http methods like httpGet, Kubernetes supports health checks using tcpSocket, and exec for more general and/or custom validation logic.

### Resource Requests

One can define low and high watermarks for resource requirements. The Kubernetes scheduler will utilize this information when mapping pods to nodes. A request specifies a minimum requirements. While later a limit will specify the maximum of a given resource, that may be used by a container.

Here is an example pod specification including a resources requests section:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    - image: gcr.io/kuar-demo/kuard-amd64:blue
      name: kuard
      resources:
        requests:
          cpu: "500m"
          memory: "128Mi"
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

Note that resources are requested per container and not per pod. Thus the total resources requested by the Pod will be the sum of all resources requested by all containers in the Pod.

## Resource Limits

Here is an example including resource limits:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kuard
spec:
  containers:
    - image: gcr.io/kuar-demo/kuard-amd64:blue
      name: kuard
      resources:
        requests:
          cpu: "500m"
          memory: "128Mi"
        limits:
          cpu: "1000m"
          memory: "256Mi"
      ports:
        - containerPort: 8080
          name: http
          protocol: TCP
```

To get the list of contexts use the following command:
```sh
kubectl config get-contexts
```

To select a context, use the following command and select from clusters listed in the kubectl config get-contexts command:
```sh
kubectl config set-cluster arn:aws:eks:us-west-1:970354268847:cluster/ExtropicKubernetesDevCluster
```
