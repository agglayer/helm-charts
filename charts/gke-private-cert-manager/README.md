# GKE Internal Generic

This Helm chart deploys a Cert-Manager ClusterIssuer resource for private DNS TLS cert management.

## Getting started

Here is an example snippet with recommended options

```yaml
name: <PROJECT>

hostname: <HOSTNAME>

replicas: <REPLICAS>

image:
  repository: <IMAGE_REPOSITORY>
  tag: <IMAGE_TAG>

containerPorts:
  http: <CONTAINER_PORT_HTTP>

tlsSecret: <TLS_SECRET>

env:
  myEnvVar: <MY_ENV_VAR>
```
