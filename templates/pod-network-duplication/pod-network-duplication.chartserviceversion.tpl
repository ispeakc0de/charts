apiVersion: litmuchaos.io/v1alpha1
kind: ChartServiceVersion
metadata:
  createdAt: 2020-07-01T10:28:08Z
  name: {{.Name}}
  version: 0.1.3
  annotations:
    categories: Kubernetes
    vendor: CNCF
    support: https://slack.kubernetes.io/
spec:
  displayName: pod-network-duplication
  categoryDescription: |
    Pod-network-duplication contains chaos to disrupt network connectivity to kubernetes pods. Experiments can inject percentage packet duplication on the app replica pods. 
    - Causes lossy access to application replica by injecting packet duplication using pumba.
    - The application pod should be healthy once chaos is stopped. Service-requests should be served (say, via alternate replicas) despite chaos.
  keywords:
    - Kubernetes
    - Network
    - Duplication
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
  chaosexpcrdlink: https://raw.githubusercontent.com/litmuschaos/chaos-charts/master/charts/generic/pod-network-duplication/experiment.yaml 
