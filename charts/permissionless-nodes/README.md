# Permissionless Nodes

This chart deploys resources for a permissionless node used by the Agglayer. The chart will deploy:

- 1 Synchronizer
- 3 load-balanced executors
- 3 load-balanced RPC nodes
- 1 postgres database server

This will expose a load-balanced, internal IP address. It is used by the agglayer to verify proofs for each rollup. To add a new permissionless node to the agglayer, add the IP address created by this helm chart to the apprpriate agglayer item in the 1Password vault ( `cdk-dev` || `cdk-test` || `cdk-prod`)

## Usage

**⚠️ Prerequisites** 

Not ideal, but here we are: you have to create the 1Password secret _first_. If you don't, template rendering will fail on install because the secrets don't exist. To create them, copy the [1password yaml](1password-vaults/bali-pless-rpc.yaml) file and modify with your item path and install in the k8s cluster with `kubectl apply -f secrets --namespace {{your_pless_namespace}}`

Required values in your 1Password item are `rpcUrl`, `dbAdminPassword` and `dbPlessPassword`.

To deploy a new permissionless node (a.k.a. _pless_), copy the [values file](nodes/wbutton-01.yaml) and modify the parameters as needed.

Deploy via helm using `helm install {name} . --namespace {namespace} -f nodes/{values file}`

For example, to create a helm installation named `pless-01` for the Cardona rollup ID 6:

```shell
helm install pless-01 ./charts/permissionless-nodes --namespace cardona-06 -f nodes/cardona-06.yaml
```

### Naming convention 

The values file should reflect the pless node being operated. Use the following format: `cardona-06` where:

- `cardona` the network, one of `bali`, `cardona`, or `mainnet`
- `06` is the rollup id

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

The executor uses the zkevm-prover image. It is deployed as an internal, load-balanced service.

TODO: monitoring/alerting

## Synchronizer

The synchronizer uses the cdk-validium-node (Validium rollups) or zkevm-node (zk rollups) docker image. It is a singleton, so only 1 synchronizer can be running per permissionless node.


## RPC

The rpc runs as a load-balanced service using the same docker image as the synchronizer. It is exposed as an http endpoint within the VPC. This endpoint is used by the agglayer for validating proofs for the given network/rollup.

## Postgresql 

Postgres is installed/configured using the [Bitnami Postgres Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql). 💜

Config values are stored in the [main yaml file](./values.yaml). Database passwords are delivered to the pods from 1Password via the OP Connector service. See #prerequites above for implmentation details.
