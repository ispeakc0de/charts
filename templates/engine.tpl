apiVersion: litmuschaos.io/v1alpha1
kind: ChaosEngine
metadata:
  name: chaos-{{if .Name}}{{.Name}}{{end}}
  namespace: oi137-litmus
spec:
  appinfo:
    appns: '{{if .Namespace}}{{.Namespace}}{{end}}'
    applabel: '{{if .Label}}{{.Label}}{{end}}'
    appkind: '{{if .Kind}}{{.Kind}}{{end}}'
  # It can be active/stop
  engineState: 'active'
  chaosServiceAccount: litmus-admin
  experiments:
    - name: {{if .Name}}{{.Name}}{{end}}
