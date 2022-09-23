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
| global.additionalLabels | object | `{}` | Additional labels for all resources |
| global.hostAliases | list | `[]` | A list of IP to hostname(s) relation |
| global.image.imagePullPolicy | string | `"IfNotPresent"` | The `imagePullPolicy` for all Polygon Edge containers. If not provided, uses Chart app version |
| global.image.repository | string | `"docker.io/0xpolygon/polygon-edge"` | The repository for all Polygon Edge containers |
| global.image.tag | string | `""` | The image tag for all Polygon Edge containers |
| global.imagePullSecrets | list | `[]` | The `imagePullSecrets` for all pods |
| global.networkPolicy.create | bool | `false` | Creates `NetworkPolicy` for all deployments |
| global.networkPolicy.defaultDenyIngress | bool | `false` | Default deny all ingress |
| global.podAnnotations | object | `{}` | Annotations for all pods |
| global.podLabels | object | `{}` | Labels for all pods |
| global.securityContext | object | `{}` | The `securityContext` for all pods. |

## Polygon Edge Config

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.dataDir | string | `"/opt/polygon-edge/data"` | The data directory for polygon-edge to use |
| config.datadog.enabled | bool | `false` | Enable Datadog  |

## Polygon Edge Secrets Manager Config

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretsManagerConfig.aws.region | string | `""` | The AWS region, if backend is `aws` |
| secretsManagerConfig.aws.ssmParameterName | string | `""` | The AWS SSM Parameter key, if backend is `aws` |
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
| genesis.chainConfig.chainID | string | `"100"` | The chain ID |
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
| validator.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| validator.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| validator.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| validator.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| validator.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| validator.logging.format | string | `"text"` | The log format for Polygon Edge validator sets  |
| validator.logging.level | string | `"info"` | The log format for Polygon Edge validator sets |
| validator.metrics.enabled | bool | `false` | Enables Polygon Edge Validator metrics service |
| validator.metrics.service.annotations | object | `{}` | The annotations for the Polygon Edge validator metrics service |
| validator.metrics.service.externalIPs | list | `[]` | The service external IPs  |
| validator.metrics.service.externalTrafficPolicy | string | `""` | The service external trafic policy  |
| validator.metrics.service.labels | object | `{}` | Labels for validator metrics service |
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
| validator.service.annotations | object | `{}` | The annotations for the Polygon Edge validator service |
| validator.service.externalIPs | list | `[]` | The service external IPs  |
| validator.service.externalTrafficPolicy | string | `""` | The service external trafic policy  |
| validator.service.grpc.nodePort | int | `39632` | The grpc node port, if service type is `NodePort` |
| validator.service.grpc.port | int | `9632` | The grpc port |
| validator.service.jsonRpc.nodePort | int | `38545` | The json-rpc node port, if service type is `NodePort` |
| validator.service.jsonRpc.port | int | `8545` | The json-rpc port |
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
