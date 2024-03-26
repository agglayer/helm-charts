# The Polygon Library for Kubernetes

Common applications, ready to launch on Kubernetes using [Helm](https://github.com/helm/helm). See the [charts](./charts) 
directory for available packages.

## TL;DR

```shell
helm install my-release charts/<chart>
```

## Before You Begin

Each Helm chart contains one or more containers. Those containers use images provided by Polygon through its test & 
release pipeline. Source code can be found in the respective project in GitHub.

Some images are only available via private image repositories. In this case, your application will need to run within a 
Polygon-supported platform or you will need to build and store the image yourself. (This primarily applies to external 
parties, all internal Polygon applications should already have access. If you encounter issues or have questions, reach 
out to the SPEC team in Slack.) Images pulled from Polygon private image repositories are scanned for vulnerabilities at 
build-time and signed by Polygon for use.

### Prerequisites 

- Kubernetes 1.23+
- Helm 3.8.0+

### A Kubernetes Cluster

No surprises here, but you will need a kubernetes cluster. [MicroK8s](https://microk8s.io/) is great for working locally. 
Kubernetes clusters for dev, test, and production use are available for Polygon Engineering. Reach out to the SPEC team if 
you need assistance or clarification.

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources. These packages 
are built to help you build and deploy common infrastructure resources in a safe, reliable, consistent manner. Head over to 
the [helm website](https://helm.sh/) if you need to install helm.

Some packages may be available via private, internal registries within Polygon. Consult the README for your particular 
application for specific details.

## License

Copyright (c) 2024 PT Services DMCC

Licensed under the Apache + MIT License (the "License"); you may not use this file except in compliance with the License. 

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" 
BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language 
governing permissions and limitations under the License.
