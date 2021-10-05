apiVersion: litmuschaos.io/v1alpha1
description:
  message: |
    Deletes a pod belonging to a deployment/statefulset/daemonset
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
          - apps.openshift.io
          - argoproj.io
          - batch
          - litmuschaos.io
        resources:
          - deployments
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
    imagePullPolicy: Always
    args:
      - -c
      - ./experiments -name pod-delete
    command:
      - /bin/bash
    env:
      - name: RAMP_TIME
        value: "{{if .Args.RAMP_TIME}}{{.Args.RAMP_TIME}}{{end}}"
      - name: LIB
        value: "{{if .Args.LIB}}{{.Args.LIB}}{{else}}pumba{{end}}"
      - name: TARGET_PODS
        value: "{{if .Args.TARGET_PODS}}{{.Args.TARGET_PODS}}{{end}}"
      - name: CHAOS_INTERVAL
        value: "{{if .Args.CHAOS_INTERVAL}}{{.Args.CHAOS_INTERVAL}}{{else}}5{{end}}"
      - name: FORCE
        value: "{{if .Args.FORCE}}{{.Args.FORCE}}{{else}}true{{end}}"
      - name: TOTAL_CHAOS_DURATION
        value: "{{if .Args.TOTAL_CHAOS_DURATION}}{{.Args.TOTAL_CHAOS_DURATION}}{{else}}20{{end}}"
      - name: PODS_AFFECTED_PERC
        value: "{{if .Args.PODS_AFFECTED_PERC}}{{.Args.PODS_AFFECTED_PERC}}{{end}}"
      - name: SEQUENCE
        value: "{{if .Args.SEQUENCE}}{{.Args.SEQUENCE}}{{else}}parallel{{end}}"
    labels:
      name: {{.Name}}
      app.kubernetes.io/part-of: litmus
      app.kubernetes.io/component: experiment-job
      app.kubernetes.io/version: latest
