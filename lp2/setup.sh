#!/bin/bash

retry() {
  local retries="$1" # First argument
  local command="$2" # Second argument

  # Run the command, and save the exit code
  $command
  local exit_code=$?

  # If the exit code is non-zero (i.e. command failed), and we have not
  # reached the maximum number of retries, run the command again
  if [[ $exit_code -ne 0 && $retries -gt 0 ]]; then
    retry $(($retries - 1)) "$command"
  else
    # Return the exit code from the command
    return $exit_code
  fi
}

# Updated Helm repos
echo "Updating helm repos..."
helm repo update

# Install LGTM
echo
echo "Installing LGTM..."
retry 3 "helm upgrade --install lgtm grafana-ps/lgtm -f /home/grafana/lgtm-values.yaml"

# Install K8s Monitoring
echo
echo "Installing k8s monitoring..."
retry 3 "helm upgrade --install k8s-monitoring grafana/k8s-monitoring -f /home/grafana/k8s-monitoring-values.yaml --set clusterMetrics.enabled=false --set clusterEvents.enabled=false --set nodeLogs.enabled=false"
