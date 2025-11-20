# Wallet Balance Exporter Helm Chart

A Kubernetes Deployment-based Helm chart that monitors wallet balances across multiple blockchain networks and exposes them as Prometheus metrics.

## Overview

This chart deploys a long-running Deployment that:
- Continuously checks wallet balances across configured blockchain networks (L1/L2, mainnet/testnet) at regular intervals
- Uses **proper Prometheus client libraries** (`prometheus-client`) and **web3.py** for reliable balance checking
- Exposes balance metrics in Prometheus format via a persistent HTTP endpoint
- Integrates seamlessly with Datadog via Autodiscovery annotations for automatic metrics collection
- Alerts when balances fall below configured thresholds
- Supports multiple networks and wallets in a single deployment
- Ensures reliable metric collection with always-available pods (no race conditions with ephemeral CronJob pods)
- **No custom image required** - uses official Python image with dependencies installed at runtime

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Datadog Agent running in your cluster with Autodiscovery enabled
- A Kubernetes secret containing wallet configuration

## Installation

### 1. Create the Configuration Secret

First, create a Kubernetes secret containing your wallet configuration. The configuration should be a JSON object where:
- **Keys** are network RPC endpoints (e.g., Ethereum mainnet, Sepolia testnet, L2 networks)
- **Values** are arrays of wallet objects to monitor on that network

Example configuration structure:

```json
{
  "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY": [
    {
      "address": "0x742d35cc6634c0532925a3b844bc9e7595f0beb",
      "label": "deployer-wallet",
      "min_balance_eth": 1.0
    },
    {
      "address": "0xanotheraddress123...",
      "label": "operations-wallet",
      "min_balance_eth": 5.0
    }
  ],
  "https://sepolia.infura.io/v3/YOUR-PROJECT-ID": [
    {
      "address": "0xtestaddress456...",
      "label": "test-deployer",
      "min_balance_eth": 0.1
    }
  ],
  "https://polygon-mainnet.g.alchemy.com/v2/YOUR-API-KEY": [
    {
      "address": "0xpolygonaddress789...",
      "label": "polygon-operator",
      "min_balance_eth": 100.0
    }
  ]
}
```

**Note:** Addresses can be provided in any format (lowercase, uppercase, or checksummed) - the exporter automatically converts them to proper checksum format.

Create the secret:

```bash
# Create a file with your configuration
cat > wallet-config.json << 'EOF'
{
  "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY": [
    {
      "address": "0x742d35cc6634c0532925a3b844bc9e7595f0beb",
      "label": "deployer-wallet",
      "min_balance_eth": 1.0
    }
  ]
}
EOF

# Create the secret in your namespace
kubectl create secret generic op-secrets \
  --from-file=wallet-balance-exporter=wallet-config.json \
  -n your-namespace

# Clean up the local file
rm wallet-config.json
```

### 2. Install the Chart

```bash
helm repo add agglayer https://agglayer.github.io/helm-charts/
helm repo update

helm install wallet-balance-exporter agglayer/wallet-balance-exporter \
  --namespace your-namespace \
  --set env="production" \
  --set config.checkInterval.seconds=300
```

Or with a custom values file:

```bash
helm install wallet-balance-exporter agglayer/wallet-balance-exporter \
  --namespace your-namespace \
  --values values.yaml
```

## Configuration

### Key Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env` | Environment name (used for Datadog tagging) | `"bali"` |
| `config.checkInterval.seconds` | How often to check balances (in seconds) | `300` (5 minutes) |
| `existingSecret.name` | Name of the existing Kubernetes secret containing configuration | `"op-secrets"` |
| `existingSecret.field` | Field within the secret containing JSON configuration | `"wallet-balance-exporter"` |
| `ports.metrics` | Port to expose Prometheus metrics on | `8080` |
| `podAnnotations` | Pod annotations (includes Datadog Autodiscovery by default) | See values.yaml |
| `replicaCount` | Number of replicas (should be 1) | `1` |
| `image.repository` | Container image repository | `"python"` |
| `image.tag` | Container image tag | `"3.11-alpine"` |
| `resources.limits.cpu` | CPU limit | `"500m"` |
| `resources.limits.memory` | Memory limit | `"256Mi"` |
| `resources.requests.cpu` | CPU request | `"100m"` |
| `resources.requests.memory` | Memory request | `"128Mi"` |

### Datadog Integration

**Datadog Autodiscovery is enabled by default** through pod annotations. The chart automatically configures the Datadog agent to scrape Prometheus metrics from the deployment pods using `ad.datadoghq.com` annotations. The pods run continuously and serve metrics on an HTTP endpoint, eliminating any race conditions or timing issues with metric collection.

Metrics are exposed with the `wallet_balance` namespace prefix in Datadog.

The Datadog annotations are defined in `podAnnotations` in values.yaml and can be customized or removed as needed:

```yaml
podAnnotations:
  ad.datadoghq.com/wallet-balance-exporter.checks: |
    {
      "openmetrics": {
        "init_config": {},
        "instances": [
          {
            "openmetrics_endpoint": "http://%%host%%:8080/metrics",
            "namespace": "wallet_balance",
            "metrics": ["^wallet_.*"]
          }
        ]
      }
    }
```

Datadog tags are automatically added to all pods via labels:
- `tags.datadoghq.com/env`: Set via the `env` parameter
- `tags.datadoghq.com/service`: Automatically set to the chart's full name
- `tags.datadoghq.com/version`: Automatically set to the chart's version

## Implementation Details

The exporter is implemented as a Python application embedded directly in the Helm chart:

- **Language**: Python 3.11
- **Libraries**:
  - `web3==6.11.3` for Ethereum RPC calls
  - `prometheus-client==0.19.0` for metrics exposition
- **No custom image needed**: Dependencies installed at pod startup via `pip install`
- **Deployment model**: Long-running pod with internal scheduling loop

**Why Deployment instead of CronJob?**

- ✅ **Reliable scraping**: Pod is always available for Datadog to discover and scrape
- ✅ **No race conditions**: No timing issues between pod lifecycle and agent scraping
- ✅ **Better observability**: Continuous logs and metrics, easier to debug
- ✅ **Built-in HTTP server**: Uses `prometheus-client`'s start_http_server()
- ✅ **Health checks**: Liveness and readiness probes ensure pod health
- ✅ **Proper web3 library**: Type-safe, reliable Ethereum interactions
- ✅ **Persistent metrics**: Metrics persist between checks, showing historical context

## Multiple Releases

You can deploy multiple instances of this chart (e.g., one per environment or network group). Each release will expose metrics with unique label combinations:

```bash
# Deploy for mainnet wallets
helm install wallet-exporter-mainnet agglayer/wallet-balance-exporter \
  --namespace production \
  --set env=mainnet

# Deploy for testnet wallets
helm install wallet-exporter-testnet agglayer/wallet-balance-exporter \
  --namespace testing \
  --set env=testnet
```

All metrics automatically include `release` and `namespace` labels to distinguish between deployments:

```
wallet_balance_eth{
  address="0x...",
  label="deployer",
  network="mainnet",
  release="wallet-exporter-mainnet",
  namespace="production"
} 1.5
```

This ensures metrics from different releases don't conflict in Datadog, even if monitoring the same addresses.

## Exposed Metrics

The exporter exposes the following Prometheus metrics (all prefixed with `wallet_balance.` in Datadog):

### `wallet_balance_wei`
- **Type**: Gauge
- **Description**: Current balance of the wallet in wei
- **Labels**: `address`, `label`, `network`, `release`, `namespace`

### `wallet_balance_eth`
- **Type**: Gauge
- **Description**: Current balance of the wallet in ETH
- **Labels**: `address`, `label`, `network`, `release`, `namespace`

### `wallet_balance_below_minimum`
- **Type**: Gauge
- **Description**: Indicates if wallet balance is below minimum threshold (1 = below, 0 = above)
- **Labels**: `address`, `label`, `network`, `min_balance_eth`, `release`, `namespace`

### `wallet_balance_check_success`
- **Type**: Gauge
- **Description**: Indicates if the balance check was successful (1 = success, 0 = failure)
- **Labels**: `address`, `label`, `network`, `release`, `namespace`

### `wallet_balance_check_timestamp`
- **Type**: Gauge
- **Description**: Unix timestamp of the last balance check
- **Labels**: `address`, `label`, `network`, `release`, `namespace`

### `wallet_balance_exporter_up`
- **Type**: Gauge
- **Description**: Exporter health indicator (always 1 when running)
- **Labels**: `release`, `namespace`

### `wallet_balance_exporter_last_check_timestamp`
- **Type**: Gauge
- **Description**: Unix timestamp of the last check cycle
- **Labels**: `release`, `namespace`

### `wallet_balance_exporter_info`
- **Type**: Info
- **Description**: Exporter version and metadata
- **Labels**: `version`, `release`, `namespace`

**Note**: All metrics include `release` and `namespace` labels to support multiple deployments. Wallet addresses are automatically converted to checksum format regardless of input casing.

## Example Datadog Monitors

Create monitors in Datadog based on the exposed metrics. All metrics will be prefixed with `wallet_balance.` in Datadog.

### Using Datadog UI

You can create monitors directly in the Datadog UI using these metrics, or define them as code:

**Example 1: Alert when wallet balance is below minimum threshold**

```
avg(last_5m):avg:wallet_balance.wallet_balance_below_minimum{*} by {label,address,network} >= 1
```

Alert message:
```
Wallet {{label.name}} ({{address.name}}) on {{network.name}} has balance below the configured minimum threshold.
```

**Example 2: Alert when balance check fails**

```
avg(last_10m):avg:wallet_balance.wallet_balance_check_success{*} by {label,address,network} < 1
```

Alert message:
```
Failed to check balance for wallet {{label.name}} ({{address.name}}) on {{network.name}}. Please investigate.
```

**Example 3: Alert when balance is critically low**

```
avg(last_5m):avg:wallet_balance.wallet_balance_eth{*} by {label,address,network} < 0.1
```

Alert message:
```
Wallet {{label.name}} ({{address.name}}) on {{network.name}} has only {{value}} ETH remaining. Please top up immediately.
```

## Example Datadog Dashboard Queries

### View all wallet balances in ETH

```
avg:wallet_balance.wallet_balance_eth{*} by {label,network}
```

### Show wallets below minimum threshold

```
avg:wallet_balance.wallet_balance_below_minimum{*} by {label,address,network}
```

Filter where value = 1 to see only wallets below threshold.

### Calculate balance in USD

Assuming you have an ETH price metric:

```
avg:wallet_balance.wallet_balance_eth{*} by {label,network} * avg:crypto.eth.usd{*}
```

### Monitor check success rate

```
(sum:wallet_balance.wallet_balance_check_success{*}.as_count() / (sum:wallet_balance.wallet_balance_check_success{*}.as_count() + sum:wallet_balance.wallet_balance_check_success{*}.as_count())) * 100
```

## Production Considerations

### Dependencies Installation

The chart installs Python dependencies at pod startup using `pip install`:
- `web3==6.11.3` - Ethereum JSON-RPC client
- `prometheus-client==0.19.0` - Prometheus metrics library

Packages are installed to `/tmp/.local` to work with the read-only root filesystem security setting.

**Startup time**: ~15-20 seconds (includes pip install + initial metrics setup)

**Network requirements**: Pod needs internet access during startup to download packages from PyPI.

If you want to avoid the pip install overhead, you can create a pre-built image and update `values.yaml`:

```yaml
image:
  repository: your-registry/wallet-balance-exporter
  tag: "1.0.0"
```

### Security Best Practices

1. **Secret Management**: Use external secret managers (1Password, Vault, AWS Secrets Manager) instead of plain Kubernetes secrets
2. **Network Policies**: Restrict egress to only required RPC endpoints (and PyPI during startup)
3. **Read-only Root Filesystem**: The chart already enables this by default
4. **Non-root User**: The chart runs as user 65534 (nobody) by default
5. **Package Pinning**: Dependencies are pinned to specific versions for reproducibility

### High Availability

The chart deploys a single-replica Deployment by default (`replicaCount: 1`). Consider:

1. **Keep replicaCount at 1** to avoid duplicate balance checks and metrics
2. Monitor pod restarts and failures with Kubernetes metrics
3. Adjust `checkInterval.seconds` based on your needs (shorter for critical wallets)
4. Use pod disruption budgets if you need to ensure uptime during cluster maintenance
5. The deployment will automatically restart if the pod fails

### Monitoring the Exporter Itself

Monitor the Deployment health using Kubernetes and custom metrics in Datadog:

```
# Check if exporter is running
avg:wallet_balance.wallet_balance_exporter_up{*} by {release,namespace}

# Alert if exporter hasn't checked recently (5+ minutes with no updates)
(current_time - max:wallet_balance.wallet_balance_exporter_last_check_timestamp{*} by {release}) > 600

# Monitor pod health
avg:kubernetes.deployment.replicas_available{kube_deployment:wallet-balance-exporter}
```

You can also monitor live logs in Datadog's Log Explorer by filtering for:
```
service:wallet-balance-exporter
```

Or use kubectl:
```bash
kubectl logs -f -l app.kubernetes.io/name=wallet-balance-exporter -n your-namespace
```

## Upgrading

```bash
helm repo update
helm upgrade wallet-balance-exporter agglayer/wallet-balance-exporter \
  --namespace your-namespace \
  --values values.yaml
```

## Uninstallation

```bash
helm uninstall wallet-balance-exporter --namespace your-namespace
```

Note: This will not delete the configuration secret. Delete it manually if needed:

```bash
kubectl delete secret op-secrets -n your-namespace
```

## Troubleshooting

### Check Deployment Status

```bash
kubectl get deployment wallet-balance-exporter -n your-namespace
kubectl get pods -n your-namespace -l app.kubernetes.io/name=wallet-balance-exporter
```

### View Pod Logs

```bash
# View live logs
kubectl logs -f -n your-namespace -l app.kubernetes.io/name=wallet-balance-exporter

# View recent logs
kubectl logs --tail=100 -n your-namespace -l app.kubernetes.io/name=wallet-balance-exporter
```

### Check Metrics Endpoint

```bash
# Port forward to access metrics locally
kubectl port-forward -n your-namespace deployment/wallet-balance-exporter 8080:8080

# Then in another terminal
curl http://localhost:8080/metrics
```

### Restart the Deployment

```bash
kubectl rollout restart deployment/wallet-balance-exporter -n your-namespace
```

### Verify Secret Configuration

```bash
kubectl get secret op-secrets -n your-namespace -o jsonpath='{.data.wallet-balance-exporter}' | base64 -d | jq .
```

### Common Issues

1. **Pod shows "WALLET_CONFIG is empty"**
   - Verify the secret exists and has the correct field name
   - Verify: `kubectl get secret op-secrets -n your-namespace -o jsonpath='{.data.wallet-balance-exporter}' | base64 -d | jq .`

2. **Balance check failures**
   - Verify RPC endpoints are accessible from the cluster
   - Check rate limiting on RPC providers
   - Verify addresses are valid Ethereum addresses (checksumming is handled automatically)

3. **Metrics not appearing in Datadog**
   - Verify Datadog agent is running: `kubectl get pods -n datadog`
   - Verify the pod annotations are present: `kubectl get pod <pod-name> -o yaml | grep ad.datadoghq.com`
   - Check Datadog agent logs: `kubectl logs -n datadog <datadog-agent-pod> | grep wallet-balance`
   - Verify the metrics endpoint is accessible: `kubectl port-forward deployment/wallet-balance-exporter 8080:8080` then `curl http://localhost:8080/metrics`
   - Check that the pod is in Running state and ready

4. **Pip install failures during startup**
   - Verify the pod has internet access to PyPI
   - Check pod logs: `kubectl logs -n your-namespace -l app.kubernetes.io/name=wallet-balance-exporter`
   - Ensure `/tmp` volume mount is working correctly

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See the [LICENSE](../../LICENSE.md) file for details.

## Support

For issues and questions:
- Open an issue in the [GitHub repository](https://github.com/agglayer/helm-charts)
- Check existing issues for solutions

