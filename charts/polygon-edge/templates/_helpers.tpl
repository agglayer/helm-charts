{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "polygon-edge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}

{{- define "polygon-edge.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create genesis name and version as used by the chart label.
*/}}
{{- define "polygon-edge.genesis.fullname" -}}
{{- printf "%s-%s" (include "polygon-edge.fullname" .) .Values.genesis.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create validator name and version as used by the chart label.
*/}}
{{- define "polygon-edge.validator.fullname" -}}
{{- printf "%s-%s" (include "polygon-edge.fullname" .) .Values.validator.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create blockscout name and version as used by the chart label.
*/}}
{{- define "polygon-edge.blockscout.fullname" -}}
{{- printf "%s-%s" (include "polygon-edge.fullname" .) .Values.extraFeatures.blockscout.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the genesis service account to use
*/}}
{{- define "polygon-edge.genesisServiceAccountName" -}}
{{- if .Values.genesis.serviceAccount.create -}}
    {{ default (include "polygon-edge.genesis.fullname" .) .Values.genesis.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.genesis.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the validator service account to use
*/}}
{{- define "polygon-edge.validatorServiceAccountName" -}}
{{- if .Values.validator.serviceAccount.create -}}
    {{ default (include "polygon-edge.validator.fullname" .) .Values.validator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.validator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "polygon-edge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "polygon-edge.labels" -}}
helm.sh/chart: {{ include "polygon-edge.chart" .context }}
{{ include "polygon-edge.selectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/part-of: polygon-edge 
{{- with .context.Values.global.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "polygon-edge.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ include "polygon-edge.name" .context }}-{{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress
*/}}
{{- define "polygon-edge.apiVersion.ingress" -}}
{{- if .Values.apiVersionOverrides.ingress -}}
{{- print .Values.apiVersionOverrides.ingress -}}
{{- else if semverCompare "<1.14-0" (include "polygon-edge.kubeVersion" $) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" (include "polygon-edge.kubeVersion" $) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "polygon-edge.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride }}
{{- end -}}

{{/*
Merge Polygon Edge Configuration with Preset Configuration
*/}}
{{- define "polygon-edge.config" -}}
  {{- if .Values.server.configEnabled -}}
{{- toYaml (mergeOverwrite (default dict (fromYaml (include "polygon-edge.config.presets" $))) .Values.server.config) }}
  {{- end -}}
{{- end -}}

{{/*
Return the default Polygon Edge version
*/}}
{{- define "polygon-edge.defaultTag" -}}
  {{- default .Chart.AppVersion .Values.global.image.tag }}
{{- end -}}

{{/*
Return the appropriate apiVersion for pod disruption budget
*/}}
{{- define "polygon-edge.podDisruptionBudget.apiVersion" -}}
{{- if semverCompare "<1.21-0" (include "polygon-edge.kubeVersion" $) -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "policy/v1" -}}
{{- end -}}
{{- end -}}
