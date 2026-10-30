{{/*
Expand the name of the chart.
*/}}
{{- define "agglayer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agglayer.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "agglayer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agglayer.labels" -}}
helm.sh/chart: {{ include "agglayer.chart" . }}
{{ include "agglayer.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
deployment: {{ htmlDateInZone (now) "UTC" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "agglayer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agglayer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "agglayer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "agglayer.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Parent domain of .Values.gatewayAPI.hostname (everything after the first label).
  agglayer.domain.com -> domain.com
*/}}
{{- define "agglayer.hostnameBase" -}}
{{- .Values.gatewayAPI.hostname | splitList "." | rest | join "." -}}
{{- end }}

{{/*
Directory where the Succinct cluster mTLS certs are mounted, one subdirectory per cluster name.
*/}}
{{- define "agglayer.succinctClusterMtlsDir" -}}
/etc/agglayer-mtls
{{- end }}

{{/*
Fail the render if a config.succinctClusterMtls entry has an invalid name, no endpoint,
or an endpoint already used by another entry.
*/}}
{{- define "agglayer.validateSuccinctClusterMtls" -}}
{{- $endpoints := list }}
{{- range $name, $cluster := .Values.config.succinctClusterMtls }}
{{- if not (regexMatch "^[A-Za-z0-9_]+$" $name) }}
{{- fail (printf "config.succinctClusterMtls.%s: name must contain only letters, digits and underscores" $name) }}
{{- end }}
{{- $endpoint := required (printf "config.succinctClusterMtls.%s.endpoint is required" $name) $cluster.endpoint }}
{{- if has $endpoint $endpoints }}
{{- fail (printf "config.succinctClusterMtls.%s: endpoint %s is already used by another entry" $name $endpoint) }}
{{- end }}
{{- $endpoints = append $endpoints $endpoint }}
{{- end }}
{{- end }}
