# blockscout

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 4.1.8](https://img.shields.io/badge/AppVersion-4.1.8-informational?style=flat-square)

Helm chart to deploy Blockscout to a Kubernetes environment.

**Homepage:** <https://docs.blockscout.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| epikichi | <ji@epik.dev> | <https://github.com/epikichi> |
| ZeljkoBenovic | <zeljko@zeljkobenovic.com> | <https://github.com/ZeljkoBenovic> |

## Source Code

* <https://github.com/0xPolygon/helm-charts/charts/blockscout>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 12.1.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| apiVersionOverrides.ingress | string | `""` | Override the ingress API version |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `90` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `90` |  |
| backend.dbName | string | `"blockscout"` |  |
| backend.dbPassword | string | `"changeme"` |  |
| backend.dbPort | int | `5432` |  |
| backend.dbUsername | string | `"blockscout"` |  |
| backend.local.enabled | bool | `true` |  |
| backend.remoteDatabaseHost | string | `""` |  |
| blockchain.WebSocketURL | string | `"wss://rpc-edgenet.polygon.technology/ws"` |  |
| blockchain.config.chainID | int | `81001` |  |
| blockchain.config.coinName | string | `"Edge Coin"` |  |
| blockchain.config.coinSymbol | string | `"EDGE"` |  |
| blockchain.config.databaseURL | string | `""` |  |
| blockchain.config.disableExchangeRates | bool | `true` |  |
| blockchain.config.ectoUseSSL | bool | `false` |  |
| blockchain.config.fetchRewardWay | string | `"manual"` |  |
| blockchain.config.indexerDisableBlockRewardFetcher | bool | `true` |  |
| blockchain.config.indexerDisableCatalogedTokenUpdaterFetcher | bool | `true` |  |
| blockchain.config.indexerDisableInternalTransactionsFetcher | bool | `true` |  |
| blockchain.config.indexerDisablePendingTransactionsFetcher | bool | `true` |  |
| blockchain.config.indexerEmptyBlocksSanitizerBatchSize | int | `1000` |  |
| blockchain.config.logo | string | `"/images/blockscout_logo.svg"` |  |
| blockchain.config.logoFooter | string | `"/images/blockscout_logo.svg"` |  |
| blockchain.config.mixEnv | string | `"prod"` |  |
| blockchain.config.secretKeyBase | string | `"VTIB3uHDNbvrY0+60ZWgUoUBKDn9ppLR8MI4CpRz4/qLyEFs54ktJfaNT6Z221No"` | https://docs.blockscout.com/for-developers/manual-deployment |
| blockchain.extraEnvs | list | `[]` |  |
| blockchain.jsonRpcURL | string | `"https://rpc-edgenet.polygon.technology/"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"docker.io/blockscout/blockscout"` |  |
| image.tag | string | `"4.1.8"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.extraPaths | list | `[]` | Extra ingress paths |
| ingress.hosts | list | `[]` |  |
| ingress.ingressClassName | string | `""` | The ingress class name |
| ingress.pathType | string | `"Prefix"` |  |
| ingress.paths[0] | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| name | string | `"blockscout"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgresql.auth.database | string | `"blockscout"` |  |
| postgresql.auth.password | string | `"changeme"` |  |
| postgresql.auth.username | string | `"blockscout"` |  |
| postgresql.nameOverride | string | `"blockscout-postgresql"` |  |
| readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.namedPort | string | `"http"` |  |
| service.port | int | `4000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
