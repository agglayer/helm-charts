{{/*
Generate the name of the chart.
*/}}
{{- define "blockscout.name" -}}
{{- default (.Chart.Name | default "blockscout") .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Generate the full name of the release.
*/}}
{{- define "blockscout.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if hasPrefix .Release.Name $name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Generate a name for a component of the release.
*/}}
{{- define "blockscout.componentName" -}}
{{- $releaseName := default "default-release" $.Release.Name }}
{{- $chartName := default "blockscout" ($.Chart.Name | default "blockscout") }}

{{- if hasKey .Values.blockscout (.componentNameKey | toString) }}
  {{- $component := index .Values.blockscout (.componentNameKey | toString) }}
  {{- $componentName := default "default" $component.componentName }}
  {{- printf "%s-%s-%s" $releaseName $chartName $componentName | trunc 63 | trimSuffix "-" -}}
{{- else }}
  {{- printf "%s-%s-unknown" $releaseName $chartName | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{/*
Generate labels for resources.
*/}}
{{- define "blockscout.labels" -}}
helm.sh/chart: {{ include "blockscout.chart" . }}
{{ include "blockscout.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Generate selector labels for resources.
*/}}
{{- define "blockscout.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blockscout.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Generate chart name and version as used by the chart label.
*/}}
{{- define "blockscout.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}
