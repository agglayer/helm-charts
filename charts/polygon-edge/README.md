# Polygon Edge Chart

A Helm chart for Polygon Edge, an extendable framework for building Ethereum-compatible blockchain solutions.

Additional information on Polygon Edge can be found [here](https://docs.polygon.technology/docs/edge/overview)

## Additional Information

This chart installs [polygon-edge](https://github.com/0xPolygon/polygon-edge).

## Prerequisites

- Kubernetes 1.15+
- Helm v3.0.0+

## Installing the Chart

Clone the chart down and choose the supported secrets backend

```console
git clone https://github.com/trapesys/helm-charts.git
cd helm-charts/trapesys/polygon-edge
```

### Local
Run the following to install the chart with a release named `polygon-edge`:

```
helm install -n polygon-edge polygon-edge .

```
### AWS

Install using AWS SSM Parameters store secrets backend
```console
# Installs Polygon Edge using AWS region `us-east-1` and SSM parameter prefix `/polygon-edge/nodes` 
helm install -n polygon-edge polygon-edge --set secretsManagerConfig.type=aws-ssm --set secretsManagerConfig.aws.region=<region> --set secretsManagerConfig.aws.ssmParameterPath=/polygon-edge/nodes
```

### GCP
Install using GCP Secrets manager backend
```console
# Installs Polygon Edge using GCP project ID `<project>` and credentials file located at `/path/to/credentials.json` 
helm install -n polygon-edge polygon-edge --set secretsManagerConfig.type=gcp-ssm --set secretsManagerConfig.gcp.projectId=<project> --set secretsManagerConfig.gcp.credentialKey=/path/to/credentials.json
```
### Hashicorp Vault
Install using Hashicorp Vault backend
```console
# Installs Polygon Edge using Vault server `<server-url>` and token `<vault-token>` 
helm install -n polygon-edge polygon-edge --set secretsManagerConfig.type=hashicorp-vault --set secretsManagerConfig.vault.serverUrl=<server-url> --set secretsManagerConfig.vault.token=<vault-token>
```

## Genesis

## General parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiVersionOverrides.ingress | string | `""` | Override the ingress API version |
| extraFeatures.blockscout.affinity | object | `{}` | Affinity |
| extraFeatures.blockscout.autoscaling.enabled | bool | `false` | Enable autoscaling |
| extraFeatures.blockscout.autoscaling.maxReplicas | int | `10` | Minimum number of replicas |
| extraFeatures.blockscout.autoscaling.minReplicas | int | `1` | Maximum number of replicas |
| extraFeatures.blockscout.autoscaling.targetCPUUtilizationPercentage | int | `90` | Target CPU percentage |
| extraFeatures.blockscout.autoscaling.targetMemoryUtilizationPercentage | int | `90` | Target Memory utilization percentage |
| extraFeatures.blockscout.config | object | `{"coinName":"Edge Coin","coinSymbol":"EDGE","disableExchangeRates":true,"ectoUseSSL":false,"extraEnvs":[],"fetchRewardWay":"manual","indexerDisableBlockRewardFetcher":true,"indexerDisableCatalogedTokenUpdaterFetcher":true,"indexerDisableInternalTransactionsFetcher":true,"indexerDisablePendingTransactionsFetcher":false,"indexerEmptyBlocksSanitizerBatchSize":1000,"logo":"/images/blockscout_logo.svg","logoFooter":"/images/blockscout_logo.svg","mixEnv":"prod"}` | Blockchain configuration |
| extraFeatures.blockscout.config.coinName | string | `"Edge Coin"` | Coin name |
| extraFeatures.blockscout.config.coinSymbol | string | `"EDGE"` | Coin symbol |
| extraFeatures.blockscout.config.disableExchangeRates | bool | `true` | Disable exchange rates fetch |
| extraFeatures.blockscout.config.ectoUseSSL | bool | `false` | Use SSL to communicate with database |
| extraFeatures.blockscout.config.extraEnvs | list | `[]` | Extra environment variables for Blockscout configuration (https://docs.blockscout.com/for-developers/information-and-settings/env-variables) |
| extraFeatures.blockscout.config.fetchRewardWay | string | `"manual"` | Fetch mine rewards manually |
| extraFeatures.blockscout.config.indexerDisableBlockRewardFetcher | bool | `true` | Disable block rewards fetcher |
| extraFeatures.blockscout.config.indexerDisableCatalogedTokenUpdaterFetcher | bool | `true` | Disable cataloged token updater fetcher |
| extraFeatures.blockscout.config.indexerDisableInternalTransactionsFetcher | bool | `true` | Disable internal transactions fetcher |
| extraFeatures.blockscout.config.indexerDisablePendingTransactionsFetcher | bool | `false` | Enable pending transactions fetcher |
| extraFeatures.blockscout.config.indexerEmptyBlocksSanitizerBatchSize | int | `1000` | Empty block sanitizer batch size |
| extraFeatures.blockscout.config.logo | string | `"/images/blockscout_logo.svg"` | Blockscout instance logo |
| extraFeatures.blockscout.config.logoFooter | string | `"/images/blockscout_logo.svg"` | Blockscout instance footer logo |
| extraFeatures.blockscout.config.mixEnv | string | `"prod"` | Set producion environment |
| extraFeatures.blockscout.database | object | `{"enabled":true,"external":{"connString":""},"skipMigration":false}` | Blockscout database backend |
| extraFeatures.blockscout.database.enabled | bool | `true` | Enable local postgresql database |
| extraFeatures.blockscout.database.external | object | `{"connString":""}` | External database connection |
| extraFeatures.blockscout.database.external.connString | string | `""` | Remote database connection string |
| extraFeatures.blockscout.database.skipMigration | bool | `false` | Skip database migration step |
| extraFeatures.blockscout.enabled | bool | `false` | Enable Blockscout (https://docs.blockscout.com/) |
| extraFeatures.blockscout.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| extraFeatures.blockscout.image.repository | string | `"docker.io/blockscout/blockscout"` | Blockscout container repository |
| extraFeatures.blockscout.image.tag | string | `"4.1.8"` | Image tag |
| extraFeatures.blockscout.imagePullSecrets | list | `[]` | Image pull secrets |
| extraFeatures.blockscout.ingress.annotations | object | `{}` | Ingress annotations |
| extraFeatures.blockscout.ingress.enabled | bool | `false` | Disable or enable ingress |
| extraFeatures.blockscout.ingress.extraPaths | list | `[]` | Extra ingress paths |
| extraFeatures.blockscout.ingress.hosts | list | `[]` | Ingress hosts |
| extraFeatures.blockscout.ingress.ingressClassName | string | `""` | The ingress class name |
| extraFeatures.blockscout.ingress.labels | object | `{}` | Ingress lables |
| extraFeatures.blockscout.ingress.pathType | string | `"Prefix"` | Ingress path type |
| extraFeatures.blockscout.ingress.paths | list | `["/"]` | Ingress paths |
| extraFeatures.blockscout.ingress.tls | list | `[]` | Ingress TLS parameters |
| extraFeatures.blockscout.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| extraFeatures.blockscout.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| extraFeatures.blockscout.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| extraFeatures.blockscout.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| extraFeatures.blockscout.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| extraFeatures.blockscout.name | string | `"blockscout"` | Identifier for blockscout resources |
| extraFeatures.blockscout.nodeSelector | object | `{}` | Node selector |
| extraFeatures.blockscout.podAnnotations | object | `{}` | Pod Annotations |
| extraFeatures.blockscout.readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| extraFeatures.blockscout.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| extraFeatures.blockscout.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| extraFeatures.blockscout.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| extraFeatures.blockscout.readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| extraFeatures.blockscout.replicaCount | int | `1` | Replica count |
| extraFeatures.blockscout.resources | object | `{}` | Resources |
| extraFeatures.blockscout.securityContext | object | `{}` | Security context |
| extraFeatures.blockscout.service.annotations | object | `{}` | Service annotations |
| extraFeatures.blockscout.service.labels | object | `{}` | Service labels |
| extraFeatures.blockscout.service.namedPort | string | `"http"` | Service name |
| extraFeatures.blockscout.service.port | int | `4000` | Service port |
| extraFeatures.blockscout.service.type | string | `"ClusterIP"` | Service type |
| extraFeatures.blockscout.tolerations | list | `[]` | Tolerations |
| fullnameOverride | string | `""` | Override for the full resource. (`"polygon-edge.fullname"`) |
| global.additionalLabels | object | `{}` | Additional labels for all resources |
| global.chain | object | `{"chainID":""}` | Chain globals |
| global.chain.chainID | string | `""` | The Chain ID (default 100) |
| global.hostAliases | list | `[]` | A list of IP to hostname(s) relation |
| global.image.imagePullPolicy | string | `"IfNotPresent"` | The `imagePullPolicy` for all Polygon Edge containers. If not provided, uses Chart app version |
| global.image.repository | string | `"docker.io/0xpolygon/polygon-edge"` | The repository for all Polygon Edge containers |
| global.image.tag | string | `""` | The image tag for all Polygon Edge containers |
| global.imagePullSecrets | list | `[]` | The `imagePullSecrets` for all pods |
| global.networkPolicy.create | bool | `false` | Creates `NetworkPolicy` for all deployments |
| global.networkPolicy.defaultDenyIngress | bool | `false` | Default deny all ingress |
| global.podAnnotations | object | `{}` | Annotations for all pods |
| global.podLabels | object | `{}` | Labels for all pods |
| global.postgresql | object | `{"auth":{"database":"blockscout","password":"blockscout","username":"blockscout"},"service":{"ports":{"postgresql":5432}}}` | Blockscout database globals |
| global.postgresql.auth.database | string | `"blockscout"` | Blockscout database name |
| global.postgresql.auth.password | string | `"blockscout"` | Blockscout database password |
| global.postgresql.auth.username | string | `"blockscout"` | Blockscout database username |
| global.postgresql.service.ports.postgresql | int | `5432` | Blockscout database port |
| global.securityContext | object | `{}` | The `securityContext` for all pods. |
| kubeVersionOverride | string | `""` | Override the Kubernetes version |
| nameOverride | string | `"polygon-edge"` | Override for resource names  |
| postgresql.nameOverride | string | `"polygon-edge-blockscout-database"` | Blockscout database name override |
| postgresql.persistence.size | string | `"10Gi"` | Permanent volume size |

## Polygon Edge Config

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.dataDir | string | `"/opt/polygon-edge/data"` | The data directory for polygon-edge to use |
| config.datadog.enabled | bool | `false` | Enable Datadog  |

## Polygon Edge Secrets Manager Config

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretsManagerConfig.aws.region | string | `""` | The AWS region, if backend is `aws` |
| secretsManagerConfig.aws.ssmParameterPath | string | `""` | The AWS SSM Parameter key, if backend is `aws` |
| secretsManagerConfig.gcp.credentialKey | string | `""` | The GCP credentials JSON, if backend is `gcp` |
| secretsManagerConfig.gcp.projectId | string | `""` | The GCP project ID, if backend is `gcp` |
| secretsManagerConfig.initSecrets | bool | `true` | Initialize secrets |
| secretsManagerConfig.namespace | string | `"admin"` | The Vault Enterprise namespace, if backend is `hashicorp-vault` |
| secretsManagerConfig.type | string | `"local"` | The secrets manager type. one of the following: `local`, `aws-ssm`, `gcp-ssm`, or `hashicorp-vault` |
| secretsManagerConfig.vault.serverUrl | string | `""` | The Vault server URL, if backend is `hashicorp-vault` |
| secretsManagerConfig.vault.token | string | `""` | The Vault token, if backend is `hashicorp-vault` |

## Polygon Edge Genesis

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| genesis.chainConfig.blockGasLimit | string | `"5242880"` | The maximum amount of gas used by all transactions |
| genesis.chainConfig.consensus | string | `"ibft"` | The consensus protocol |
| genesis.chainConfig.epochSize | string | `"100000"` | The Epoch size for the chain. |
| genesis.chainConfig.ibftValidatorType | string | `"bls"` | The type of validators in IBFT  |
| genesis.chainConfig.maxValidatorCount | string | `"9007199254740990"` | Max number of validators for a Proof of Stake  |
| genesis.chainConfig.minValidatorCount | string | `"1"` | Min number of validators for a Proof of Stake  |
| genesis.chainConfig.name | string | `"polygon-edge"` | The chain name in genesis  |
| genesis.chainConfig.pos | bool | `false` | Use Proof of Stake over Proof of Authority |
| genesis.chainConfig.premine | string | `""` | The premine address |
| genesis.chainJson | string | `""` | A Pre-generated chain JSON. |
| genesis.envFrom | list | `[]` | The `envFrom` for the genesis job |
| genesis.extraEnvs | list | `[]` | Extra environment variables for the genesis job |
| genesis.image.repository | string | `""` | The repository for the genesis job container |
| genesis.image.tag | string | `""` | The image tag for the genesis job container. If not provided, uses Chart app version |
| genesis.name | string | `"genesis"` | The identifier for the geneis job. |
| genesis.podAnnotations | object | `{}` | Annotations for the genesis pods |
| genesis.podLabels | object | `{}` | Labels for the genesis pods |
| genesis.serviceAccount.annotations | object | `{}` | The annotations for the created service account |
| genesis.serviceAccount.automateServiceAccountToken | bool | `true` | Automount the service account API credentials |
| genesis.serviceAccount.create | bool | `true` | Create a service account for the genesis job  |
| genesis.serviceAccount.serviceAccountName | string | `""` | A service account name override to use |

## Polygon Edge Validator

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| validator.envFrom | list | `[]` | The `envFrom` for the Polygon Edge validator set |
| validator.extraEnvs | list | `[]` | Extra environment variables for the Polygon Edge validator set |
| validator.image.repository | string | `""` | The repository for Polygon Edge validator containers |
| validator.image.tag | string | `""` | The image tag for Polygon Edge validator containers. If not provided, uses Chart app version |
| validator.ingress.annotations | object | `{}` | The annotations for validator JSONRPC ingress |
| validator.ingress.enabled | bool | `false` | Enable the validator JSON RPC ingress resource  |
| validator.ingress.extraPaths | list | `[]` | Extra ingress paths |
| validator.ingress.hosts | list | `[]` | A list of ingress hosts |
| validator.ingress.ingressClassName | string | `""` | The ingress class name |
| validator.ingress.lables | object | `{}` | The labels for validator JSONRPC ingress |
| validator.ingress.pathType | string | `"Prefix"` | The ingress path type |
| validator.ingress.paths | list | `["/"]` | A list of ingress paths |
| validator.ingress.tls | list | `[]` | A list of ingress TLS configuration |
| validator.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| validator.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| validator.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| validator.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| validator.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| validator.logging.format | string | `"syslog"` | The log format for Polygon Edge validator sets  |
| validator.logging.level | string | `"info"` | The log format for Polygon Edge validator sets |
| validator.metrics.enabled | bool | `false` | Enables Polygon Edge Validator metrics service |
| validator.metrics.service.annotations | object | `{}` | The annotations for the Polygon Edge validator metrics service |
| validator.metrics.service.externalIPs | list | `[]` | The service external IPs  |
| validator.metrics.service.externalTrafficPolicy | string | `""` | The service external trafic policy  |
| validator.metrics.service.labels | object | `{}` | The labels for validator metrics service |
| validator.metrics.service.loadBalancerIP | string | `""` | The load balancer IP to use, if service type is `LoadBalancer`  |
| validator.metrics.service.loadBalancerSourceRanges | list | `[]` | The IP CIDR to whitelist, if service type is `LoadBalancer`  |
| validator.metrics.service.namedTargetPort | bool | `true` | Uses the target port name alias instead of explicit port |
| validator.metrics.service.nodePort | int | `8088` | The metrics node port, if metrics service type is `NodePort` |
| validator.metrics.service.servicePort | int | `8088` | The metrics service port |
| validator.metrics.service.servicePortName | string | `"metrics"` | The metrics service port name |
| validator.metrics.service.sessionAffinity | string | `""` | The session affinity. either `ClientIP` or `None`  |
| validator.metrics.service.type | string | `"ClusterIP"` | The service type  |
| validator.name | string | `"validator"` | The identifier for the validator sets |
| validator.persistence.enabled | bool | `false` | Enable persistency for the validator sets |
| validator.persistence.labels.enabled | bool | `true` | Enable labels for persistent volumes |
| validator.podAnnotations | object | `{}` | Annotations for validator pods |
| validator.podLabels | object | `{}` | Labels for validator pods |
| validator.readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| validator.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| validator.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| validator.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| validator.readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| validator.replicas | int | `4` |  |
| validator.serverConfig.accessControlAllowOrigins | string | `"0x0"` | The CORS allow-origins header for the JSON-RPC endpoint  |
| validator.serverConfig.blockGasTarget | int | `0` | Sets the target block gas limit for the existing chain |
| validator.serverConfig.blockTime | int | `2` | The minimum block time in seconds |
| validator.serverConfig.jsonRPCBatchRequestLimit | int | `20` | The max JSON-RPC batch request size limit (0 disables) |
| validator.serverConfig.jsonRPCBlockRangeLimit | int | `1000` | The max block range to consider when executing JSON-RPC requests (0 disables) |
| validator.serverConfig.maxEnqueued | int | `128` | Max number of enqueued transactions per account |
| validator.serverConfig.maxPeers | int | `40` | The client's total max allowed peers |
| validator.serverConfig.priceLimit | int | `0` | The min gas price limit to enforce for inbound transactions |
| validator.service.annotations | object | `{}` | The annotations for the Polygon Edge validator service |
| validator.service.externalIPs | list | `[]` | The service external IPs  |
| validator.service.externalTrafficPolicy | string | `""` | The service external trafic policy  |
| validator.service.grpc.nodePort | int | `39632` | The grpc node port, if service type is `NodePort` |
| validator.service.grpc.port | int | `9632` | The grpc port |
| validator.service.jsonRPC.nodePort | int | `38545` | The json-rpc node port, if service type is `NodePort` |
| validator.service.jsonRPC.port | int | `8545` | The json-rpc port |
| validator.service.labels | object | `{}` | The labels for the Polygon Edge validator service |
| validator.service.libp2p.nodePort | int | `31478` | The libp2p (peering) node port, if service type is `NodePort` |
| validator.service.libp2p.port | int | `1478` | The libp2p (peering) port |
| validator.service.loadBalancerIP | string | `""` | The load balancer IP to use, if service type is `LoadBalancer`  |
| validator.service.loadBalancerSourceRanges | list | `[]` | The IP CIDR to whitelist, if service type is `LoadBalancer`  |
| validator.service.namedTargetPort | bool | `true` | Uses the target port name alias instead of explicit port |
| validator.service.sessionAffinity | string | `""` | The session affinity. either `ClientIP` or `None`  |
| validator.service.type | string | `"ClusterIP"` | The service type  |
| validator.serviceAccount.annotations | object | `{}` | The annotations for the created service account |
| validator.serviceAccount.automateServiceAccountToken | bool | `true` | Automount the service account API credentials |
| validator.serviceAccount.create | bool | `true` | Create a service account for the Polygon Edge validator set |
| validator.serviceAccount.serviceAccountName | string | `""` | A service account name override to use |
| validator.volumeClaimTemplate.accessModes | list | `["ReadWriteOnce"]` | The `accessModes` for the validator persistent volume claims |
| validator.volumeClaimTemplate.resources.requests.storage | string | `"10Gi"` | The requested storage for the validator persistent volume claims  |
| validator.volumeClaimTemplate.storageClassName | string | `""` | The Storage Class name for the validator persistent volume claims |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs)

[affinity]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
[BackendConfigSpec]: https://cloud.google.com/kubernetes-engine/docs/concepts/backendconfig#backendconfigspec_v1beta1_cloudgooglecom
[FrontendConfigSpec]: https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_frontendconfig_parameters
[HPA]: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
[MetricRelabelConfigs]: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#metric_relabel_configs
[Node selector]: https://kubernetes.io/docs/user-guide/node-selection/
[probe]: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
[RelabelConfigs]: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
[Tolerations]: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
[TopologySpreadConstraints]: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
[values.yaml]: values.yaml
