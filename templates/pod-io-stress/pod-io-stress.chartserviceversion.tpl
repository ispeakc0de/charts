apiVersion: litmuchaos.io/v1alpha1
kind: ChartServiceVersion
metadata:
  createdAt: 2020-09-13T10:28:08Z
  name: {{.Name}}
  version: 0.1.1
  annotations:
    categories: Kubernetes
    vendor: CNCF
    support: https://slack.kubernetes.io/
spec:
  displayName: pod-io-stress
  categoryDescription: |
    This experiment causes disk stress on the application pod. The experiment aims to verify the resiliency of applications that share this disk resource for ephemeral or persistent storage purposes.    
    - Consumes the disk available by executing filesystem IO stress as available memory or by providing the value in GB
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
  chaosexpcrdlink: https://raw.githubusercontent.com/litmuschaos/chaos-charts/master/charts/generic/pod-io-stress/experiment.yaml