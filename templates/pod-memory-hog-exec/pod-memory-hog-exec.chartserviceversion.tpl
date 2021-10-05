apiVersion: litmuchaos.io/v1alpha1
kind: ChartServiceVersion
metadata:
  createdAt: 2020-04-10T10:28:08Z
  name: {{.Name}}
  version: 0.1.5
  annotations:
    categories: Kubernetes
    vendor: CNCF
    support: https://slack.kubernetes.io/
spec:
  displayName: pod-memory-hog-exec
  categoryDescription: |
    pod-memory-hog-exec contains chaos to consume Memory resouces of specified containers in Kubernetes pods.  
    - Consumes the memory specified by executing a dd command against special files /dev/zero(input) and /dev/null(output)
    - The application pod should be healthy once chaos is stopped. Expectation is that service-requests should be served despite chaos.
  keywords:
    - Kubernetes
    - Memory
  platforms:
    - PKS
    - {{.Platform}}
  maturity: alpha
  labels:
    app.kubernetes.io/component: chartserviceversion
    app.kubernetes.io/version: latest
  maintainers:
    - name: ChaosTeam
      email: _chaos@pole-emploi.fr  
  minKubeVersion: 1.0.0
  provider:
    name: Pole Emploi
  links:
    - name: Mattermost Chaos
      url: https://mattermost.pe-qvr.net/tmj/channels/chaos-engineering
    - name: Documentation
      url: http://git-scm.pole-emploi.intra/chaos/produits/litmus/chaos-charts/tree/datamap
    - name: Source Code
      url: http://git-scm.pole-emploi.intra/chaos/produits/litmus/chaos-charts/tree/datamap
  icon:
    - base64data: ""
      mediatype: ""
  chaosexpcrdlink: https://raw.githubusercontent.com/litmuschaos/chaos-charts/master/charts/generic/pod-memory-hog-exec/experiment.yaml 
