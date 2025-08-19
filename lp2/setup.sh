#!/bin/bash

# Updated Helm repos
helm repo update

# Install LGTM
helm upgrade --install lgtm grafana-ps/lgtm -f /home/grafana/lgtm-values.yaml

# Install K8s Monitoring
helm upgrade --install k8s-monitoring grafana/k8s-monitoring -f /home/grafana/k8s-monitoring-values.yaml --set clusterMetrics.enabled=false --set clusterEvents.enabled=false --set nodeLogs.enabled=false
