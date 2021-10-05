{{ $data := . }}
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: {{.Workflow.Name}}
  namespace: default
spec:
  entrypoint: custom-chaos
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
  serviceAccountName: argo-chaos
  templates:
    - name: custom-chaos
      steps:
        - - name: install-chaos-experiments
            template: install-chaos-experiments
{{- range $experimentName := .Workflow.Experiments -}}
	{{- $experimentNameFull := printf "%s-%s" $.Name $experimentName }}
        - - name: {{$experimentNameFull}}
            template: {{$experimentNameFull}}
{{- end }}
    - name: install-chaos-experiments
      inputs:
        artifacts:
{{- range $experimentName := .Workflow.Experiments -}}
    {{- $experimentNameFull := printf "%s-%s" $.Name $experimentName }}
          - name: {{$experimentNameFull}}
            path: /tmp/{{$experimentNameFull}}.yaml
            raw:
              data: >
{{- GetTemplate $data $experimentNameFull | nindent 16 -}}{{- end -}}
      container:
        args:
        command:
          - sh
          - -c
        image: litmuschaos/k8s:latest
{{ range $experimentName := .Workflow.Experiments }}
    {{ $experimentNameFull := printf "%s-%s" $.Name $experimentName }}
    - name: {{$experimentNameFull}}
      inputs:
        artifacts:
          - name: {{$experimentNameFull}}
            path: /tmp/chaosengine-{{$experimentNameFull}}.yaml
            raw:
              data: |
{{ GetEngine $data $experimentNameFull | nindent  16 }}
      container:
        args:
          - -file=/tmp/chaosengine-{{$experimentNameFull}}.yaml
          - -saveName=/tmp/engine-name
        image: litmuschaos/litmus-checker:latest
{{- end -}}