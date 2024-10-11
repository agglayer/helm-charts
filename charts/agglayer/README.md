# Agglayer

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Installs and configures the agglayer service on Kubernetes using Helm. This repo is used to create & manage the helm chart.
Deployments should be done from the [agglayer repo](https://github.com/0xPolygon/agglayer).

## Development

This chart creates a load-balanced service using the `0xPolygon/agglayer` docker image.

### certificate.yaml

Creates a Google-managed SSL certificate used by the ingress. Domain name is specified in `values.yaml` as `.Values.domain`.

### config.yaml

Renders the template [config.toml](./config/config.toml) with parameters from 1Password to create the config file. Mounts in the pod
container at `/etc/agglayer/config.toml`. Will require a OnePasswordItem in your k8s cluster to synchronize the data from the 1Password
vault into your k8s namespace. See [1password/vault.yaml](./1password/vault.yaml) for reference.

### deployment.yaml

Creates the deployment spec; Pretty standard deployment, uses the autoscaling parameters from `values.yaml`. Some noteworthy stuff:

- `template.metadata.annotations`: instructs Datadog to scrape the metrics endpoint for metrics, filtered to desired metrics
- `labels`: uses [\_helpers.tpl](./templates/_helpers.tpl) to annotate labels on pods for cost tracking

### ingress.yaml

Creates the k8s ingress for the service. Contains two noteworthy annotations:

- `networking.gke.io/managed-certificates`: provisions the Google-managed SSL certificate using the domain name specified in `values.yaml`
- `ingressClassName: "gce"`: creates the GCP-managed load balancer

⚠️The ingress will expose an IP address. This address must be added to DNS using your domain name. The SSL cert will not provision
until this step is completed.

⚠️ This is not using a static IP address. Provisioning a static IP address requires a manual step outside the control of this
helm chart, and probably isn't needed anyway. The IP address created here will persist for the life of the ingress. I.e., as
long as you don't delete this ingress, you'll retain the same IP address. If you do delete the ingress, you've removed the ability
to receive traffic anyway, so you probably don't need the static IP address.

TL;DR: It's fine. DNS is easy. Don't make this harder than it has to be.

### service.yaml

Creates the kubernetes service. 🤷‍♂️Nuff said.

### serviceaccount.yaml

Creates a **kubernetes** service account, _not_ a GCP IAM service account. But, this is the account that will impersonate your
GCP IAM Service Account. Specifically, we will assign CryptoKey Encrypter/Decrypter permissions to our GCP IAM Service Account
(see below). This Service Account will impersonate the IAM Service Account, which is permitted to use the HSM KMS Key to sign
transactions.

This impersonation is accomplished via the service account annotation in `values.yaml`.

## Set IAM Permissions to Permit Using the KMS Key

See the polygon-searce-gcp [repo](https://github.com/maticnetwork/polygon-searce-gcp/blob/main/landing-zone/service_accounts.tf) for
examples of setting up a service account via terraform, specifically [creating the service account](https://github.com/maticnetwork/polygon-searce-gcp/blob/main/apps/agglayer/dev/main.tf#L99)
and [assigning KMS permissions](https://github.com/maticnetwork/polygon-searce-gcp/blob/main/apps/agglayer/dev/main.tf#L134C1-L142C2).

Alternatively, executes something like this manually:

- Create IAM service account `gcloud iam service-accounts create agglayer-gke-dev --project=prj-polygonlabs-shared-dev`
- Add permissions needed by the service account. In this case, I added CryptoKey Encrypter/Decrypter permissions to the cdk-bali key in the CDK-Dev project via the GCP console.
- Set permissions to allow the k8s service account to impersonate the IAM service account

```shell
gcloud iam service-accounts add-iam-policy-binding agglayer-gke-dev@prj-polygonlabs-shared-dev.iam.gserviceaccount.com \
--role roles/iam.workloadIdentityUser \
--member "serviceAccount:prj-polygonlabs-shared-dev.svc.id.goog[agglayer/agglayer]"
```

- annotate the k8s service account (see serviceaccount.yaml)
