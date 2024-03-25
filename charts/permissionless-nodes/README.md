# Permissionless Nodes

This chart deploys resources for a permissionless node used by the Agglayer. The chart will deploy:

- 1 Synchronizer
- 3 load-balanced executors
- 3 load-balanced RPC nodes
- 1 postgres database server (optional)

## Usage

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

TODO: add secrets for db connection
TODO: add secret for RPC url
TODO: set executor URL from executor service
TODO: what is MTClient URI in config?
TODO: template config file to use secrets (above)

## RPC

TODO: same config stuff as on executor, they share the same config file

## Postgresql (optional)

TODO: persistent volume mounts

## Docker config from [website](https://docs.polygon.technology/zkEVM/get-started/deploy-zkevm/configure-prover/?h=ports#configure-services):

```yaml
zkevm-permissionless-node:
    container_name: zkevm-permissionless-node
    image: hermeznetwork/zkevm-node:v0.2.1
    ports:
      - 8125:8125
    environment:
      - ZKEVM_NODE_ISTRUSTEDSEQUENCER=false
      - ZKEVM_NODE_STATEDB_USER=test_user
      - ZKEVM_NODE_STATEDB_PASSWORD=test_password
      - ZKEVM_NODE_STATEDB_NAME=state_db
      - ZKEVM_NODE_STATEDB_HOST=zkevm-permissionless-db
      - ZKEVM_NODE_POOL_DB_USER=test_user
      - ZKEVM_NODE_POOL_DB_PASSWORD=test_password
      - ZKEVM_NODE_POOL_DB_NAME=pool_db
      - ZKEVM_NODE_POOL_DB_HOST=zkevm-permissionless-db
      - ZKEVM_NODE_RPC_PORT=8125
      - ZKEVM_NODE_RPC_SEQUENCERNODEURI=http://zkevm-json-rpc:8123
      - ZKEVM_NODE_MTCLIENT_URI=zkevm-permissionless-prover:50061
      - ZKEVM_NODE_EXECUTOR_URI=zkevm-permissionless-prover:50071
    volumes:
      - ./config/environments/testnet/public.node.config.toml:/app/config.toml
      - ./config/environments/testnet/public.genesis.config.json:/app/genesis.json
    command:
      - "/bin/sh"
      - "-c"
      - '/app/zkevm-node run --network custom --custom-network-file /app/genesis.json --cfg /app/config.toml --components "rpc,synchronizer"'

```
