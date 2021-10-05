apiVersion: litmuschaos.io/v1alpha1
description:
  message: |
    Injects network packet duplication on pods belonging to an app deployment
kind: ChaosExperiment
metadata:
  name: {{.Name}}
  labels:
    name: {{.Name}}
    app.kubernetes.io/part-of: litmus
    app.kubernetes.io/component: chaosexperiment
    app.kubernetes.io/version: latest
spec:
  definition:
    scope: Namespaced
    permissions:
      - apiGroups:
          - ""
          - batch
          - apps
          - apps.openshift.io
          - argoproj.io
          - litmuschaos.io
        resources:
          - jobs
          - pods
          - pods/log
          - replicationcontrollers
          - deployments
          - statefulsets
          - daemonsets
          - replicasets
          - deploymentconfigs
          - rollouts
          - pods/exec
          - events
          - chaosengines
          - chaosexperiments
          - chaosresults
        verbs:
          - get
          - list
          - patch
          - create
          - update
          - delete
          - deletecollection
    image: litmuschaos/go-runner:latest
    imagePullPolicy: Always
    args:
      - -c
      - ./experiments -name pod-network-duplication
    command:
      - /bin/bash
    env:
      - name: TOTAL_CHAOS_DURATION
        value: "{{if .Args.TOTAL_CHAOS_DURATION}}{{.Args.TOTAL_CHAOS_DURATION}}{{else}}60{{end}}"
      - name: TARGET_CONTAINER
        value: "{{if .Args.TARGET_CONTAINER}}{{.Args.TARGET_CONTAINER}}{{end}}"
      - name: TC_IMAGE
        value:  "{{if .Args.TC_IMAGE}}{{.Args.TC_IMAGE}}{{else}}gaiadocker/iproute2{{end}}"
      - name: NETWORK_INTERFACE
        value:  "{{if .Args.NETWORK_INTERFACE}}{{.Args.NETWORK_INTERFACE}}{{else}}eth0{{end}}"
      - name: NETWORK_PACKET_DUPLICATION_PERCENTAGE
        value:  "{{if .Args.NETWORK_PACKET_DUPLICATION_PERCENTAGE}}{{.Args.NETWORK_PACKET_DUPLICATION_PERCENTAGE}}{{else}}100{{end}}"
      - name: PODS_AFFECTED_PERC
        value: "{{if .Args.PODS_AFFECTED_PERC}}{{.Args.PODS_AFFECTED_PERC}}{{end}}"
      - name: DESTINATION_IPS
        value: "{{if .Args.DESTINATION_IPS}}{{.Args.DESTINATION_IPS}}{{end}}"
      - name: DESTINATION_HOSTS
        value: "{{if .Args.DESTINATION_HOSTS}}{{.Args.DESTINATION_HOSTS}}{{end}}"
      - name: TARGET_PODS
        value: "{{if .Args.TARGET_PODS}}{{.Args.TARGET_PODS}}{{end}}"
      - name: RAMP_TIME
        value: "{{if .Args.RAMP_TIME}}{{.Args.RAMP_TIME}}{{end}}"
      - name: LIB
        value: "{{if .Args.LIB}}{{.Args.LIB}}{{else}}pumba{{end}}"
      - name: LIB_IMAGE
        value: "{{if .Args.LIB_IMAGE}}{{.Args.LIB_IMAGE}}{{else}}litmuschaos/go-runner:ci{{end}}"
      - name: CONTAINER_RUNTIME
        value: "{{if .Args.CONTAINER_RUNTIME}}{{.Args.CONTAINER_RUNTIME}}{{else}}docker{{end}}"
      - name: SOCKET_PATH
        value: "{{if .Args.SOCKET_PATH}}{{.Args.SOCKET_PATH}}{{else}}/var/vcap/sys/run/docker/docker.sock{{end}}"
      - name: SEQUENCE
        value: "{{if .Args.SEQUENCE}}{{.Args.SEQUENCE}}{{else}}parallel{{end}}"
    labels:
      name: {{.Name}}
      app.kubernetes.io/part-of: litmus
      app.kubernetes.io/component: experiment-job
      app.kubernetes.io/version: latest
