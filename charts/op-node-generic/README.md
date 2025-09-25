# OP-Node Generic

A Helm chart for deploying OP-Node (Optimism consensus client) to Kubernetes.

## Installation

```bash
helm install my-op-node ./op-node-generic
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- A secret containing L1 RPC URL and JWT token
- Access to L1 Ethereum node and OP-Geth execution client

## Key Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `container.image.tag` | OP-Node image tag | `v1.9.5` |
| `storage.size` | Persistent volume size | `500Gi` |
| `existingSecret` | Secret name with L1 RPC URL and JWT | `secretName` |
| `config.network` | L2 network name | `some-l2-network-name` |
| `config.l2.engineRpc` | OP-Geth RPC URL | `http://op-geth:8551` |
| `config.sync.mode` | Sync mode | `consensus-layer` |
| `resources.limits.memory` | Memory limit | `10Gi` |

## Example Values

```yaml
container:
  image:
    tag: v1.9.6

config:
  network: my-network
  l2:
    engineRpc: "http://my-op-geth:8551"
  sync:
    mode: execution-layer
  p2p:
    bootnodes: "enode://..."

storage:
  size: 1Ti

resources:
  limits:
    memory: 20Gi
```

## Ports

- **8545**: RPC
- **9222**: P2P (TCP/UDP)
- **7300**: Metrics

## Required Secret

```bash
kubectl create secret generic my-secret \
  --from-literal=l1RpcURL="https://eth-mainnet.g.alchemy.com/v2/YOUR-KEY" \
  --from-literal=jwt="your-jwt-token"
```

## Sync Modes

- **consensus-layer**: Derives blocks from L1 (recommended)
- **execution-layer**: Syncs from execution client
