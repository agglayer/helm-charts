# Bridge Tester Helm Chart

A Kubernetes CronJob that automatically bridges assets from L1 to multiple L2 networks using the `polycli` tool.

## Overview

This chart deploys a singleton CronJob that:
- Runs on a configurable schedule (default: every hour)
- Processes multiple L2 networks sequentially
- Uses a single private key to send bridge transactions
- Prevents nonce conflicts by processing networks one at a time

## Features

- **Multi-Network Support**: Configure multiple L2 networks in a single deployment
- **Sequential Processing**: Avoids nonce conflicts by processing networks one after another
- **Singleton Design**: Only one job runs at a time (via `concurrencyPolicy: Forbid`)
- **Flexible Configuration**: Enable/disable individual networks without redeploying
- **JSON Logging**: All logs output in JSON format for Datadog integration
- **Comprehensive Logging**: Detailed output for each bridge operation with structured fields
- **Error Handling**: Tracks and reports failed networks

## Configuration

### Basic Configuration

```yaml
# Schedule (cron format)
schedule: "0 * * * *"  # Every hour

# Kubernetes Secret containing sensitive data
existingSecret: op-secrets
```

### Network Configuration

Configure one or more networks to bridge to under the `config.networks` section:

```yaml
config:
  networks:
    - name: "network-1"
      enabled: true
      l1:
        bridgeAddress: "0x123"
        tokenAddress: "0x123"
      l2:
        networkId: 123
        destinationAddress: "0x123"
      bridgeAmount: "123000000000000"    # Amount in wei

    - name: "network-2"
      enabled: true
      l1:
        bridgeAddress: "0x456"
        tokenAddress: "0x456"
      l2:
        networkId: 456
        destinationAddress: "0x456"
      bridgeAmount: "456000000000000"
```

### Secret Requirements

Create a Kubernetes Secret with the following keys:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: op-secrets
type: Opaque
stringData:
  bridgeTesterPrivateKey: "0x..."
  l1RpcURL: "https://..."
```

## Installation

```bash
# Install the chart
helm install bridge-tester ./charts/bridge-tester \
  --namespace your-namespace \
  --values your-values.yaml

# Upgrade the chart
helm upgrade bridge-tester ./charts/bridge-tester \
  --namespace your-namespace \
  --values your-values.yaml
```

## How It Works

1. **Job Execution**: The CronJob runs on the configured schedule
2. **Tool Installation**: Downloads and installs the latest `polycli` binary
3. **Sequential Processing**: Iterates through all enabled networks
4. **Bridge Operation**: For each network:
   - Loads network-specific configuration
   - Calls `polycli ulxly bridge asset` with appropriate parameters
   - Waits 10 seconds before processing the next network (to avoid nonce conflicts)
5. **Summary**: Reports success/failure for each network

## Troubleshooting

### "Replacement transaction underpriced" Errors

This error occurs when multiple transactions from the same address try to use the same nonce. This chart prevents this by:
- Running as a singleton (only one job at a time)
- Processing networks sequentially with delays between them
- Using `concurrencyPolicy: Forbid` to prevent overlapping executions

### Failed Bridge Operations

Check the pod logs to see which network failed:

```bash
kubectl logs -n your-namespace job/bridge-tester-xxxxx
```

The summary at the end lists all failed networks.

### Disabling a Network Temporarily

Set `enabled: false` for any network you want to skip:

```yaml
config:
  networks:
    - name: "problematic-network"
      enabled: false  # This network will be skipped
      # ... rest of config
```

## JSON Logging

All logs are output in JSON format for easy integration with Datadog and other log aggregation tools. Each log entry includes:

- `timestamp`: ISO 8601 formatted timestamp in UTC
- `level`: Log level (`info`, `error`, `debug`)
- `message`: Human-readable message
- `service`: Always set to `bridge-tester`
- `env`: Environment from values (e.g., `bali`)
- `network`: Network name (when applicable)
- `step`: Current processing step
- Additional context fields (e.g., `l1_bridge`, `l2_network_id`, `amount`)

### Example Log Output

```json
{"timestamp":"2026-01-22T10:00:00.000Z","level":"info","message":"Starting bridge-tester script","step":"init","service":"bridge-tester","env":"bali"}
{"timestamp":"2026-01-22T10:00:05.123Z","level":"info","message":"Processing 2 enabled network(s)","step":"process_networks","service":"bridge-tester","env":"bali"}
{"timestamp":"2026-01-22T10:00:06.456Z","level":"info","message":"Starting network 1/2","network":"network-1","step":"network_start","service":"bridge-tester","env":"bali"}
{"timestamp":"2026-01-22T10:00:07.789Z","level":"info","message":"Network configuration","network":"network-1","step":"prepare_env","l1_bridge":"0x123","l2_network_id":123,"destination":"0x123","amount":"123000000000000","service":"bridge-tester","env":"bali"}
{"timestamp":"2026-01-22T10:00:20.012Z","level":"info","message":"Bridge operation successful","network":"network-1","step":"bridge_asset","service":"bridge-tester","env":"bali"}
```

### Datadog Integration

These JSON logs are automatically picked up by Datadog agents running in your Kubernetes cluster. You can:

- Filter by `service:bridge-tester`
- Group by `network` to see per-network performance
- Track success/failure rates using `level:error`
- Monitor processing times by `step`
- Use the `env` tag for environment-based filtering

## Advanced Configuration

### Custom Pod Labels

```yaml
podLabels:
  name: myname
  business_unit: agglayer
  role: bridge-tester
  partner: Polygon
  network: mynetwork
```

### Job History Limits

```yaml
failedJobsHistoryLimit: 1
successfulJobsHistoryLimit: 1
backoffLimit: 1
```

### Resource Limits

```yaml
# Currently hardcoded in cronjob.yaml, can be made configurable:
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

## Examples

### Multiple Networks with Different L1 Endpoints

```yaml
config:
  networks:
    - name: "prod-network"
      enabled: true
      l1:
        bridgeAddress: "0xProdBridge"
        tokenAddress: "0xProdToken"
      l2:
        networkId: 100
        destinationAddress: "0xProdDest"
      bridgeAmount: "1000000000000000000"

    - name: "staging-network"
      enabled: true
      l1:
        bridgeAddress: "0xStagingBridge"
        tokenAddress: "0xStagingToken"
      l2:
        networkId: 200
        destinationAddress: "0xStagingDest"
      bridgeAmount: "500000000000000000"
```

## License

[Add your license here]
