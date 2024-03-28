# Permissionless Nodes

This chart deploys resources for a permissionless node used by the Agglayer. The chart will deploy:

- 1 Synchronizer
- 3 load-balanced executors
- 3 load-balanced RPC nodes
- 1 postgres database server (optional)

## Usage

**⚠️ Prerequisites** 

Not ideal, but here we are: you have to create the 1Password secret _first_. If you don't, template rendering will fail on install because the secrets don't exist. To create them, copy the [1password yaml](1password-vaults/bali-pless-rpc.yaml) file and modify with your item path and install in the k8s cluster with `kubectl apply -f secrets --namespace {{your_pless_namespace}}`

Required values in your 1Password item are `dbAdminPassword` and `dbPlessPassword`.

To deploy a new permissionless node (a.k.a. _pless_), copy the [values file](nodes/pless-rpc-bali-astar-04.yaml) and modify the parameters as needed.

Deploy via helm using `helm install pless-rpc-cardona-idex-06 . --namespace cardona-idex-06 --create-namespace --values nodes/pless-rpc-cardona-idex-06.yaml`

### Naming convention

The values file should reflect the pless node being operated. Use the following format: `pless-rpc-cardona-idex-06` where:

- `pless-rpc` identifies the type of node (permissionless rpc)
- `cardona` the network, one of `bali`, `cardona`, or `mainnet`
- `idex` is the owner
- `06` is the rollup id

## GKE

### Manual Changes:

- Added Cloudflare Zero Trust to control plane access
- Turned off Binary Authorization

## Global

TODO: datadog sidecars w/ prometheus scraping

## Executor

TODO: add secrets for db connection
TODO: enable runHashDBServer in config_executor.json?
TODO: template dbNumberOfPoolConnections in config_executor.json
TODO: template dbMTCacheSize in config_executor.json
TODO: template dbProgramCacheSize in config_executor.json

## Synchronizer


## RPC


## Postgresql 

Postgres is installed/configured using the [Bitnami Postgres Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql). 💜

Config values are stored in the [main yaml file](./values.yaml). Database passwords are delivered to the pods from 1Password via the OP Connector service. See #prerequites above for implmentation details.
