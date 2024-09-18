# Service Account Permissions

This chart deploys a ClusterRole and ClusterRoleBinding for granting all permissions to a service account.

## Usage

This chart is primarily used for self-hosted Github Actions runners deployed with Github's scaleset helm chart. It's needed because the service account created by Github doesn't have enough permissions to manage resources like secrets in other namespaces.
