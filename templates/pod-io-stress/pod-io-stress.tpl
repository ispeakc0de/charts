apiVersion: litmuschaos.io/v1alpha1
description:
  message: |
    IO stress on a app pods belonging to an app deployment
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
    image: litmuschaos/go-runner:ci
    imagePullPolicy: Always
    args:
      - -c
      - ./experiments -name pod-io-stress
    command:
      - /bin/bash
    env:
      - name: TOTAL_CHAOS_DURATION
        value: "{{if .Args.TOTAL_CHAOS_DURATION}}{{.Args.TOTAL_CHAOS_DURATION}}{{else}}120{{end}}"
      - name: FILESYSTEM_UTILIZATION_PERCENTAGE
        value: "{{if .Args.FILESYSTEM_UTILIZATION_PERCENTAGE}}{{.Args.FILESYSTEM_UTILIZATION_PERCENTAGE}}{{else}}10{{end}}"
      - name: FILESYSTEM_UTILIZATION_BYTES
        value: "{{if .Args.FILESYSTEM_UTILIZATION_BYTES}}{{.Args.FILESYSTEM_UTILIZATION_BYTES}}{{end}}"
      - name: NUMBER_OF_WORKERS
        value: "{{if .Args.NUMBER_OF_WORKERS}}{{.Args.NUMBER_OF_WORKERS}}{{else}}4{{end}}"
      - name: PODS_AFFECTED_PERC
        value: "{{if .Args.PODS_AFFECTED_PERC}}{{.Args.PODS_AFFECTED_PERC}}{{end}}"
      - name: VOLUME_MOUNT_PATH
        value: "{{if .Args.VOLUME_MOUNT_PATH}}{{.Args.VOLUME_MOUNT_PATH}}{{end}}"
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
