# GKE Internal Generic

This Helm chart deploys a generic _internal_ containerized app or service to a GKE cluster.

## Getting started

Here is an example snippet with recommended options

```yaml
name: my-project

hostname: example.com

replicas: 1

image:
  repository: nobody
  tag: main

containerPorts:
  http: 80

ingress:
  annotations: some-annotations

env:
```
