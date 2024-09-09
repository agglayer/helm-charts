# GKE Internal Generic

This Helm chart deploys a Cert-Manager ClusterIssuer resource for private DNS TLS cert management.

## Getting started

Here is an example snippet

```yaml
gcp:
  projectId: my-project
  location: somewhere
  ca:
    poolId: some-pool
    name: some-ca-name
```
