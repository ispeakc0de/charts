apiVersion: litmuchaos.io/v1alpha1
kind: ChartServiceVersion
metadata:
  createdAt: 2019-10-15T10:28:08Z
  name: {{.Name}}
  version: 0.1.14
  annotations:
    categories: Kubernetes
    vendor: CNCF
    support: https://slack.kubernetes.io/
spec:
  displayName: pod-delete
  categoryDescription: |
    Pod delete contains chaos to disrupt state of kubernetes resources. Experiments can inject random pod delete failures against specified application.
    - Causes (forced/graceful) pod failure of random replicas of an application deployment.
    - Tests deployment sanity (replica availability & uninterrupted service) and recovery workflows of the application pod. 
  keywords:
    - Kubernetes
    - State 
  platforms:
    - PKS
    - {{.Platform}}
  maturity: alpha
  maintainers:
    - name: ChaosTeam
      email: _chaos@pole-emploi.fr
  minKubeVersion: 1.12.0
  provider:
    name: Mayadata
  labels:
    app.kubernetes.io/component: chartserviceversion
    app.kubernetes.io/version: latest
  links:
    - name: Source Code
      url: https://github.com/litmuschaos/litmus-go/tree/master/experiments/generic/pod-delete
    - name: Documentation
      url: https://litmuschaos.github.io/litmus/experiments/categories/pods/pod-delete/
    - name: Video
      url: https://www.youtube.com/watch?v=X3JvY_58V9A
  icon:
    - url: 
      mediatype: ""
  chaosexpcrdlink: https://raw.githubusercontent.com/litmuschaos/chaos-charts/master/charts/generic/pod-delete/experiment.yaml
