# Permissionless Nodes erigon

This chart deploys resources for an Erigon-based permissionless node used by the Agglayer. The chart will deploy:

TODO: detail what's deployed

This will expose a load-balanced, internal IP address. It is used by the agglayer to verify proofs for each rollup.
To add a new permissionless node to the agglayer, add the IP address created by this helm chart to the appropriate agglayer
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

Config values are stored in the [main yaml file](./values.yaml).
