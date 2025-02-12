# Blockscout

Helm chart to deploy the zkEVM flavor of blockscout (which uses the `blockscout/blockscout-zkevm` docker image for blockscout-backend).

## Prerequisites

This chart makes the following assumptions:

- You have an existing Postgres DB server deployed and available (you don't need to create any databases manually)
- You have a 1Password vault item made available as a k8s secret in the namespace you'll use for this blockscout chart. The secret name must be passed as `existingSecret` in the chart values, and the corresponding vault item should contain the following fields:
  - `l1RpcURL`
  - `dbUser`
  - `dbUserPassword`
  - `dbHost`
  - `dbPort`
