{{/*
Expand the name of the chart.
*/}}
{{- define "cdk-erigon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cdk-erigon.fullname" -}}
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
{{- define "cdk-erigon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cdk-erigon.labels" -}}
helm.sh/chart: {{ include "cdk-erigon.chart" . }}
{{ include "cdk-erigon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
name: {{ .Values.tags.name }}
env: {{ .Values.tags.env }}
team: {{ .Values.tags.team }}
partner: {{ .Values.tags.partner }}
tags.datadoghq.com/env: {{ .Values.tags.env }}
tags.datadoghq.com/name: {{ include "agglayer.fullname" . }}
tags.datadoghq.com/service: {{ include "agglayer.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cdk-erigon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cdk-erigon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cdk-erigon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cdk-erigon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
