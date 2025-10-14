{{/*
Expand the name of the chart.
*/}}
{{- define "zkevm-prover.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zkevm-prover.fullname" -}}
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
{{- define "zkevm-prover.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zkevm-prover.labels" -}}
helm.sh/chart: {{ include "zkevm-prover.chart" . }}
{{ include "zkevm-prover.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
tags.datadoghq.com/env: {{ .Values.env }}
tags.datadoghq.com/service: zkevm-prover
tags.datadoghq.com/version: {{ .Values.image.tag }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zkevm-prover.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zkevm-prover.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "zkevm-prover.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "zkevm-prover.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}