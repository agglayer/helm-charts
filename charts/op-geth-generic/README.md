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
