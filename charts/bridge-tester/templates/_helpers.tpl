{{/*
Expand the name of the chart.
*/}}
{{- define "bridgeTester.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bridgeTester.fullname" -}}
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
{{- define "bridgeTester.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bridgeTester.labels" -}}
helm.sh/chart: {{ include "bridgeTester.chart" . }}
{{ include "bridgeTester.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
name: {{ include "bridgeTester.fullname" . }}
host: gcp
env: {{ .Values.env }}
role: script
team: spec
p_service: bridge-tester
tag: v3
tags.datadoghq.com/env: {{ .Values.env }}
tags.datadoghq.com/name: {{ include "bridgeTester.fullname" . }}
tags.datadoghq.com/service: {{ include "bridgeTester.fullname" . }}
deployment: {{ htmlDateInZone (now) "UTC" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bridgeTester.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bridgeTester.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bridgeTester.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bridgeTester.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
