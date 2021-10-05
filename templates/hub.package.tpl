packageName: {{.Name}}
experiments:
{{- range $Name, $experiment := .Experiments }}
  - name: {{$Name}}
    CSV: {{$Name}}.chartserviceversion.yaml
    desc: "{{$Name}}"
{{- end}}
