{{/*
Expand the name of the chart.
*/}}
{{- define "wallet-balance-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "wallet-balance-exporter.fullname" -}}
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
{{- define "wallet-balance-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wallet-balance-exporter.labels" -}}
helm.sh/chart: {{ include "wallet-balance-exporter.chart" . }}
{{ include "wallet-balance-exporter.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
tags.datadoghq.com/env: {{ .Values.env }}
tags.datadoghq.com/service: {{ include "wallet-balance-exporter.fullname" . }}
tags.datadoghq.com/version: {{ .Chart.Version | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wallet-balance-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wallet-balance-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}



