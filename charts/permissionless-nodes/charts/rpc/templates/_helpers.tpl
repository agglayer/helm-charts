{{/*
Expand the name of the chart.
*/}}
{{- define "rpc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rpc.fullname" -}}
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
{{- define "rpc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rpc.labels" -}}
helm.sh/chart: {{ include "rpc.chart" . }}
{{ include "rpc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
name: {{ .Values.global.name }}
host: {{ .Values.global.host }}
location: {{ .Values.global.location }}
env: {{ .Values.global.env }}
role: {{ .Values.global.role }}
team: {{ .Values.global.team }}
p_service: {{ .Values.global.p_service }}
partner: {{ .Values.global.partner }}
tag: {{ .Values.global.tag }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rpc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rpc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rpc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rpc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
