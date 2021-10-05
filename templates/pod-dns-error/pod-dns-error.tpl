apiVersion: litmuschaos.io/v1alpha1
description:
  message: |
    Pod DNS Error injects dns failure/error in target pod containers
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
          - create
          - list
          - get
          - patch
          - update
          - delete
          - deletecollection
    image: litmuschaos/go-runner:latest
    args:
      - -c
      - ./experiments -name pod-dns-error
    command:
      - /bin/bash
    env:
      - name: TARGET_CONTAINER
        value: "{{if .Args.TARGET_CONTAINER}}{{.Args.TARGET_CONTAINER}}{{end}}"
      - name: RAMP_TIME
        value: "{{if .Args.RAMP_TIME}}{{.Args.RAMP_TIME}}{{end}}"
      - name: TARGET_PODS
        value: "{{if .Args.TARGET_PODS}}{{.Args.TARGET_PODS}}{{end}}"
      - name: SOCKET_PATH
        value: "{{if .Args.SOCKET_PATH}}{{.Args.SOCKET_PATH}}{{else}}/var/vcap/sys/run/docker/docker.sock{{end}}"
      - name: CONTAINER_RUNTIME
        value: "{{if .Args.CONTAINER_RUNTIME}}{{.Args.CONTAINER_RUNTIME}}{{else}}docker{{end}}"
      - name: TOTAL_CHAOS_DURATION
        value: "{{if .Args.TOTAL_CHAOS_DURATION}}{{.Args.TOTAL_CHAOS_DURATION}}{{else}}60{{end}}"
      - name: PODS_AFFECTED_PERC
        value: "{{if .Args.PODS_AFFECTED_PERC}}{{.Args.PODS_AFFECTED_PERC}}{{end}}"
      - name: LIB_IMAGE
        value: "{{if .Args.LIB_IMAGE}}{{.Args.LIB_IMAGE}}{{else}}litmuschaos/go-runner:latest{{end}}"
      - name: SEQUENCE
        value: "{{if .Args.SEQUENCE}}{{.Args.SEQUENCE}}{{else}}parallel{{end}}" 
      - name: TARGET_HOSTNAMES
        value: "{{if .Args.TARGET_HOSTNAMES}}{{.Args.TARGET_HOSTNAMES}}{{end}}"
      - name: MATCH_SCHEME
        value: "{{if .Args.MATCH_SCHEME}}{{.Args.MATCH_SCHEME}}{{else}}exact{{end}}"
    labels:
      experiment: {{.Name}}
      app.kubernetes.io/part-of: litmus
      app.kubernetes.io/component: experiment-job
      app.kubernetes.io/version: latest
