# Permissionless Nodes 1Password Secrets

This chart deploys resources for a permissionless node used by the Agglayer. The chart will deploy:

- 1 Synchronizer
- 1 executor
- 1 RPC node
- 1 postgres database server

This will expose a load-balanced, internal IP address. It is used by the agglayer to verify proofs for each rollup.
To add a new permissionless node to the agglayer, add the IP address created by this helm chart to the apprpriate agglayer
item in the 1Password vault ( `cdk-dev` || `cdk-test` || `cdk-prod`)

## Usage

All deployments should be done via the [rollups repo](https://github.com/0xPolygon/rollups). This document details the helm chart.

## Deployment

The chart should be packaged and deployed to GCP for use. Once your changes are approved and merged to `main`, it will be deployed to GCP in the CI (see .github/workflows/helm:publish.yaml).

\_Note that packaging follows semver with immutable tags. You must increment the version number to successfully push to the repository.

## GKE

### Namespaces

Each permissionless node is installed in its own namespace. This allows for tracking utilization, costs, and restricting access (coming soon...).

### Manual Changes:

- Added Cloudflare Zero Trust to control plane access
- Turned off Binary Authorization

## Global

Permissionless nodes are deployed to the appropriate GKE cluster per environment:

- `bali`: `dev-gke-shared`
- `cardona`: `test-gke-shared`
- `mainnet`: `prod-gke-shared`

## Executor

The executor uses the zkevm-prover image. It is deployed as an internal service.

TODO: monitoring/alerting

## Synchronizer

The synchronizer uses the cdk-validium-node (Validium rollups) or zkevm-node (zk rollups) docker image. It is a singleton, so only 1 synchronizer can be running per permissionless node.

## RPC

The rpc runs as a service using the same docker image as the synchronizer. It is exposed as an http endpoint within the VPC. This endpoint is used by the agglayer for validating proofs for the given network/rollup.

## Postgresql

Postgres is installed/configured using the [Bitnami Postgres Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql). 💜

Config values are stored in the [main yaml file](./values.yaml). Database passwords are delivered to the pods from 1Password via the OP Connector service. See #prerequites above for implmentation details.
