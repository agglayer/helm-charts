# Permissionless Nodes

This chart deploys resources for a permissionless node used by the Agglayer. The chart will deploy:

- 1 Synchronizer
- 3 load-balanced executors
- 3 load-balanced RPC nodes
- 1 postgres database server (optional)

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

## Postgresql (optional)
