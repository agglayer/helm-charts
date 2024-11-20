{{/*
Expand the name of the chart.
*/}}
{{- define "bridgeUI.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bridgeUI.fullname" -}}
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
{{- define "bridgeUI.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bridgeUI.labels" -}}
helm.sh/chart: {{ include "bridgeUI.chart" . }}
{{ include "bridgeUI.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
name: {{ include "bridgeUI.fullname" . }}
host: gcp
location: {{ default "unspecified" .Values.region }}
env: {{ .Values.env }}
role: application
team: cdk
p_service: bridgeUI
tag: v3
tags.datadoghq.com/env: {{ .Values.env }}
tags.datadoghq.com/name: {{ include "bridgeUI.fullname" . }}
deployment: {{ htmlDateInZone (now) "UTC" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bridgeUI.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bridgeUI.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bridgeUI.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bridgeUI.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
