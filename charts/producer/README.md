# Application Helm Chart Module

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

This Helm chart module creates and manage the following application resources:

* Config Map
* Deployment
* Frontend Config
* Horizontal Pod Autoscaling
* Ingress
* Managed Certificate
* Service

## Getting started

To quickly get started, use the following:

```yaml
name: <APPLICATION_NAME>
commonLabels:
  <LABELS>

containers:
  - name: <CONTAINER_NAME>
    image: <IMAGE_NAME:TAG>
      pullPolicy: IfNotPresent
    port: <PORT>

service:
  type: <SERVICE_TYPE>
  port: <PORT>

ingress:
  annotations:
    kubernetes.io/ingress.class: gce
    networking.gke.io/v1beta1.FrontendConfig: <APPLICATION_NAME>-frontendconfig
    kubernetes.io/ingress.global-static-ip-name: <GLOBAL_STATIC_IP>
    networking.gke.io/managed-certificates: <APPLICATION_NAME>-certificate
  hosts:
    - host: <HOSTNAME>
      paths:
      - path: <PATH>
        pathType: <PATH_TYPE>
        backend:
          service:
            name: <APPLICATION_NAME>-service
            port: 
              number: <PORT>

```

**Note**: The provided snippet is not recommended for long use. It is for swiftly deploying a simple bare-bones application, experimenting, and subsequently deleting it.

For higher environments like dev, stage, and prod etc. consider the following:

* Setting number of replicas to be created
* Enabling and setting Liveness and readiness probes
* Setting up autoscaling configurations
* Adding additional settings to container configuration such as resources.requests, command, envFromEnabled in case configmap is to be referenced, and onepasswords InjectorEnvs.
* Add podAnnotations in case 1password is used

Here is an example snippet with recommended options

```yaml
name: <APPLICATION_NAME>
commonLabels:
  <LABELS>

replicaCount: <REPLICA_COUNT>

podAnnotations: 
  operator.1password.io/inject: <CONTAINER_NAME>

containers:
  - name: <CONTAINER_NAME>
    image: <IMAGE_NAME:TAG>
      pullPolicy: IfNotPresent
    port: <PORT>
    securityContext: {}
    command: ["<COMMAND>",]
    envFromEnabled: true
    onePassword:
      InjectorEnvs:
        <INJECTOR_ENVS>
    resources: 
      requests:
        cpu: <CPU_REQUEST>
        memory: <MEMORY_REQUEST>
    
service:
  type: <SERVICE_TYPE>
  port: <PORT>

ingress:
  annotations:
    kubernetes.io/ingress.class: gce
    networking.gke.io/v1beta1.FrontendConfig: <APPLICATION_NAME>-frontendconfig
    kubernetes.io/ingress.global-static-ip-name: <GLOBAL_STATIC_IP>
    networking.gke.io/managed-certificates: <APPLICATION_NAME>-certificate
  hosts:
    - host: <HOSTNAME>
      paths:
      - path: <PATH>
        pathType: <PATH_TYPE>
        backend:
          service:
            name: <APPLICATION_NAME>-service
            port: 
              number: <PORT>

livenessProbe: 
  httpGet:
    path: <PORT_PATH>
    port: <PORT_NAME>
readinessProbe: 
  httpGet:
    path: <PORT_PATH>
    port: <PORT_NAME>

autoscaling: 
  minReplicas: <MIN_REPILCAS>
  maxReplicas: <MAX_REPLICAS>
  targetCPUUtilizationPercentage: <TARGET_CPU_UTILIZATION>
  targetMemoryUtilizationPercentage: <TARGET_MEMORY_UTILAIZATION>

configMapData: 
    <CONFIG_MAP_DATA>
```

## Deploying webflow-api helm chart

Before deploying this Helm chart, ensure that you have performed the following steps:

* Confirm your ability to connect to the cluster.
* Install the Helm binary.
* Obtain the vault connect credentials: _1password-credentials.json_ and access token.
* Reserve a global static IP and configure the name in the values file polygon-webflow-apis.yaml. (In the current configuration it is reserved as `webflow-api-ingress-static-ip`)

## Provisioning

To provision the helm chart, perform the following steps:

1. Run helm template to check if the values provided does not throw any syntax errors
```bash
    helm template <RELATIVE_HELM_DIRECTORY> -f <RELATIVE_HELM_DIRECTORY>/<VALUES_FILE>
```
2. If no errors are thrown by the above step, run helm install to install the helm chart
```bash
    helm install <RELATIVE_HELM_DIRECTORY> -f <RELATIVE_HELM_DIRECTORY>/<VALUES_FILE> <CHART_NAME>
```
3. Once the helm chart is installed, the helm chart name as well as relevant info will be output to confirm the installation.

## Parameters

When configuring the values, make sure to double check the Immutable options. These  parameters can not be modified later.

### Required Parameters

| Parameter | Notes | Immutable |
|---|---|---|
| name | The name of the application | Yes |
| commonLabels | The labels used by all resources of the application | No |
| containers.name | The name of the container | Yes |
| containers.image | The image of the container | No |
| service.port | The service port used to listen to incoming traffic | No |
| service.targetPort | The target port to which the service sends requests to | No |


### Recommended variables

Few of the varibles will be mandatory based on your helm template configuration

| Parameter | Notes | Immutable | Default |
|---|---|---|---|
| replicaCount | The number of replicas to be created   | No | 1 |
| deploymentAnnotations | Annotations to be provided in deployment metadata | No | 
| podAnnotations | Annotations to be provided for a given pod | No | 
| imagePullSecrets | Secrets that are need to access images | No | 
| podSecurityContext | Security context for users in a pod | No |
| containers.SecurityContext | Security contextfor users in a container | No |
| containers.imagePullPolicy | Image pull policy of a container | No | "IfNotPresent" |
| containers.command | list of string specifying commands to be performed inside container | No | 
| containers.env | Environment varibles to be used inside a container | No |
| containers.onePassword | If specified, will provide environment variables of 1password inside container | No | 
| containers.onePassword.connectHost | The host used to connect to 1password | No | "http://onepassword-connect.op:8080" |
| containers.onePassword.secretName | The name of the token used to connect to 1password | No | "connect-token" |
| containers.onePassword.secretKey | The key of the token used to connect to 1password | No | "token" |
| containers.onePassword.InjectorEnvs | List of objects which specifies the 1password secret name and related vault directory | No | 
| containers.envFromEnabled | If enabled, references environments from config maps or secrets | No | 
| containers.port | The port of the container | No | 
| containers.resources | The cpu and memory requests for the container | No | 
| nodeSelector |  Constrains pods to nodes with specific labels | No |
| affinity | Constrains pods to nodes with specific labels and specified rules | No |
| tolerations | Allow the scheduler to schedule pods with matching taints | No |
| configMapData | If specified, will create config map and sets the data for config map | Yes | 
| ingress | If provided, creates Ingress, frontend config and managed certificate   | Yes | |
| ingress.annotations | The annotations required by ingress | No |
| ingress.hosts | A list of objects that specifies the hosts and related paths and ports | No |
| ingress.hosts.host | A hostname used by the ingress | No |
| ingress.hosts.paths | A list of objects that specifies the path and related service name and ports and ports | No |
| ingress.hosts.paths.path | The path that is used by the specified backend | No |
| ingress.hosts.paths.pathType | The path type of the path provided | No |
| ingress.hosts.paths.backend.service.name | The name of the service related to the provided path | No |
| ingress.hosts.paths.backend.service.port.number | The port of the service related to the provided path | No |
| autoscaling | If specified, creates HorizontalPodAutoscaler | No |
| autoscaling.minReplicas | The minimum number of replicas to be created | No | 1 |
| autoscaling.maxReplicas | The maximum number of replicas to be created | No | 100 |
| autoscaling.targetCPUUtilizationPercentage | The target CPU Utilization percentage for the pod | No | 80 |
| autoscaling.targetMemoryUtilizationPercentage | The target Memory Utilization percentage for the pod | No | 80 |
| httpsRedirect | Boolean Value to check if redirect to https is enabled | No | 






### Templatetized Configuration

Certain configurations are Templetized to provide ease in referencing certain parameters which may be specific to certain resources.

| Config | Notes | Immutable |
|---|---|---|
| deploymentLabels | Role and name of resource deployment | No |
| serviceLabels | Role and name of resource service | No |
| configmapLabels | Role and name of resource configmap | No |
| frontendLabels | Role and name of resource frontend | No |
| ingressLabels | Role and name of resource ingress | No |
| managedCertificateLabels | Role and name of resource Managed certificate | No |


## Resources Provisioned

1. Deployment with provided configurations
2. If config map is enabled, configmap with provided data
3. If Ingress is enabled, frontend config with redirecttoHttps config
4. If autoscaling is enabled, Horizontal pod Autoscaling with provided configurations
5. If Ingress is enabled, Ingress with provided configurations
6. If Ingress is enabled, managed certificate with provided domains
7. Service with provided configurations