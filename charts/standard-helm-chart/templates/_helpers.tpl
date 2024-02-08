{{/*
Expand the name of the chart.
*/}}
{{- define "balance.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "balance.fullname" -}}
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
{{- define "balance.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "balance.labels" -}}
helm.sh/chart: {{ include "balance.chart" . }}
{{ include "balance.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "balance.selectorLabels" -}}
app.kubernetes.io/name: {{ include "balance.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "balance.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "balance.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "deploymentLabels" -}}
  role: deployment
  #name: {{ .Values.name }}-deployment
{{- end }}

{{- define "serviceLabels" -}}
    role: service
    name: {{ .Values.name }}-service
{{- end }}

{{- define "configmapLabels" -}}
    role: configmap
    name: {{ .Values.name }}-configmap
{{- end }}

{{- define "frontendLabels" -}}
    role: frontendconfig
    name: {{ .Values.name }}-frontendconfig
{{- end }}

{{- define "ingressLabels" -}}
    role: ingress
    name: {{ .Values.name }}-ingress
{{- end }}

{{- define "managedCertificateLabels" -}}
    role: managedcertificate
    name: {{ .Values.name }}-certificates
{{- end }}

# {{- define "injectContainers" -}}
# {{- printf "%s" (include "injectContainer" .) }}
# {{- end }}

{{- define "injectContainer" -}}
  {{- $result := list -}}
  {{- range . }}
    {{- if and .onePassword.InjectorEnvs (len .onePassword.InjectorEnvs) }}
      {{- $result = $result | append (list .name) }}
    {{- end }}
    {{- $result = $result | append (include "injectContainer" . ) | cat  }}
  {{- end }}
  {{- $result | join "," }}
{{- end }}