apiVersion: litmuschaos.io/v1alpha1
description:
  message: |
    Kills a container belonging to an application pod 
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
          - apps
          - batch
          - apps.openshift.io
          - argoproj.io
          - litmuschaos.io
        resources:
          - jobs
          - pods
          - pods/log
          - events
          - replicationcontrollers
          - deployments
          - statefulsets
          - daemonsets
          - replicasets
          - deploymentconfigs
          - rollouts
          - pods/exec
          - chaosengines
          - chaosexperiments
          - chaosresults
        verbs:
          - create
          - list
          - get
          - update
          - patch
          - delete
          - deletecollection
    image: litmuschaos/go-runner:latest
    imagePullPolicy: Always
    Args:
      - -c
      - ./experiments -name container-kill
    command:
      - /bin/bash
    env:
      - name: TARGET_CONTAINER
        value: "{{if .Args.TARGET_CONTAINER}}{{.Args.TARGET_CONTAINER}}{{end}}"
      - name: RAMP_TIME
        value: "{{if .Args.RAMP_TIME}}{{.Args.RAMP_TIME}}{{end}}"
      - name: LIB
        value: "{{if .Args.LIB}}{{.Args.LIB}}{{else}}pumba{{end}}"
      - name: TARGET_PODS
        value: "{{if .Args.TARGET_PODS}}{{.Args.TARGET_PODS}}{{end}}"
      - name: CHAOS_INTERVAL
        value: "{{if .Args.CHAOS_INTERVAL}}{{.Args.CHAOS_INTERVAL}}{{else}}10{{end}}"
      - name: SIGNAL
        value: "{{if .Args.SIGNAL}}{{.Args.SIGNAL}}{{else}}SIGKILL{{end}}"
      - name: SOCKET_PATH
        value: "{{if .Args.SOCKET_PATH}}{{.Args.SOCKET_PATH}}{{else}}/var/vcap/sys/run/docker/docker.sock{{end}}"
      - name: CONTAINER_RUNTIME
        value: "{{if .Args.CONTAINER_RUNTIME}}{{.Args.CONTAINER_RUNTIME}}{{else}}docker{{end}}"
      - name: TOTAL_CHAOS_DURATION
        value: "{{if .Args.TOTAL_CHAOS_DURATION}}{{.Args.TOTAL_CHAOS_DURATION}}{{else}}20{{end}}"
      - name: PODS_AFFECTED_PERC
        value: "{{if .Args.PODS_AFFECTED_PERC}}{{.Args.PODS_AFFECTED_PERC}}{{end}}"
      - name: LIB_IMAGE
        value: "{{if .Args.LIB_IMAGE}}{{.Args.LIB_IMAGE}}{{else}}litmuschaos/go-runner:latest{{end}}"
      - name: SEQUENCE
        value: "{{if .Args.SEQUENCE}}{{.Args.SEQUENCE}}{{else}}parallel{{end}}"
    labels:
      name: {{.Name}}
      app.kubernetes.io/part-of: litmus
      app.kubernetes.io/component: experiment-job
      app.kubernetes.io/version: latest
