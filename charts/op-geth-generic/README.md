# OP-Geth Generic

A Helm chart for deploying OP-Geth (Optimism execution client) to Kubernetes.

## Installation

```bash
helm install my-op-geth ./op-geth-generic
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- A secret containing JWT token for authentication

## Key Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `container.image.tag` | OP-Geth image tag | `v1.101411.4` |
| `storage.size` | Persistent volume size | `500Gi` |
| `existingSecret` | Secret name with JWT token | `secretName` |
| `config.l2.networkName` | L2 network name | `op-network` |
| `config.l2.sequencerHttp` | Sequencer HTTP URL | `http://somewhere` |
| `config.syncmode` | Sync mode (full/snap) | `snap` |
| `resources.limits.memory` | Memory limit | `10Gi` |

### Init Containers Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `initContainers` | Array of init containers (empty = no init containers) | `[]` |
| `initContainers[].name` | Name of the init container | Required |
| `initContainers[].image.repository` | Init container image repository | Required |
| `initContainers[].image.tag` | Init container image tag | Required |
| `initContainers[].command` | Command to run in init container | Optional |
| `initContainers[].args` | Arguments for the command | Optional |
| `initContainers[].env` | Environment variables | `{}` |
| `initContainers[].volumeMounts` | Additional volume mounts | `[]` |
| `initContainers[].resources` | Resource limits and requests | `{}` |

## Example Values

```yaml
container:
  image:
    tag: v1.101411.5

config:
  l2:
    networkName: my-network
    sequencerHttp: https://sequencer.example.com
  syncmode: full

storage:
  size: 1Ti

# Enable init container for snapshot download
initContainers:
  - name: snapshot-downloader
    image:
      repository: curlimages/curl
      tag: "8.4.0"
    command: ["sh"]
    args:
      - -c
      - "curl -L -o /data/geth/snapshot.tar.gz ${SNAPSHOT_URL} && cd /data/geth && tar -xzf snapshot.tar.gz"
    env:
      SNAPSHOT_URL: "https://snapshots.example.com/mainnet-latest.tar.gz"

resources:
  limits:
    memory: 20Gi
```

## Ports

- **8545**: HTTP RPC
- **8551**: Auth RPC (requires JWT)
- **8546**: WebSocket
- **30303**: P2P
- **7300**: Metrics

## Required Secret

```bash
kubectl create secret generic my-secret --from-literal=jwt="your-jwt-token"
```
