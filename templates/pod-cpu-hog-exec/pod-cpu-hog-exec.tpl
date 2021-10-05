apiVersion: litmuschaos.io/v1alpha1
description:
  message: |
    Injects cpu consumption on pods belonging to an app deployment
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
          - patch
          - update
          - delete
          - deletecollection
    image: litmuschaos/go-runner:ci
    imagePullPolicy: Always
    args:
      - -c
      - ./experiments -name pod-cpu-hog-exec
    command:
      - /bin/bash
    env:
      - name: TOTAL_CHAOS_DURATION
        value: "{{if .Args.TOTAL_CHAOS_DURATION}}{{.Args.TOTAL_CHAOS_DURATION}}{{else}}60{{end}}"
      - name: CPU_CORES
        value: "{{if .Args.CPU_CORES}}{{.Args.CPU_CORES}}{{else}}1{{end}}"
      - name: PODS_AFFECTED_PERC
        value: "{{if .Args.PODS_AFFECTED_PERC}}{{.Args.PODS_AFFECTED_PERC}}{{end}}"
      - name: RAMP_TIME
        value: "{{if .Args.RAMP_TIME}}{{.Args.RAMP_TIME}}{{end}}"
      - name: LIB
        value: "{{if .Args.LIB}}{{.Args.LIB}}{{else}}pumba{{end}}"
      - name: CHAOS_KILL_COMMAND
        value: "{{if .Args.CHAOS_KILL_COMMAND}}{{.Args.CHAOS_KILL_COMMAND}}{{else}}kill $(find /proc -name exe -lname '*/md5sum' 2>&1 | grep -v 'Permission denied' | awk -F/ '{print $(NF-1)}'){{end}}"
      - name: TARGET_PODS
        value: "{{if .Args.TARGET_PODS}}{{.Args.TARGET_PODS}}{{end}}"
      - name: SEQUENCE
        value: "{{if .Args.SEQUENCE}}{{.Args.SEQUENCE}}{{else}}parallel{{end}}"
    labels:
      name: {{.Name}}
      app.kubernetes.io/part-of: litmus
      app.kubernetes.io/component: experiment-job
      app.kubernetes.io/version: latest
