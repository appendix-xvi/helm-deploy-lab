#!/usr/bin/env bash

set -euo pipefail

RELEASE_NAME="${RELEASE_NAME:-monitor}"
VALUES_FILE="${VALUES_FILE:-values-prod.yaml}"
NAMESPACE="${NAMESPACE:-default}"

minikube status >/dev/null 2>&1 || minikube start --memory=4096 --cpus=2

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo update

helm upgrade --install "${RELEASE_NAME}" prometheus-community/kube-prometheus-stack \
  --namespace "${NAMESPACE}" \
  --create-namespace \
  -f "${VALUES_FILE}"

kubectl rollout status "deployment/${RELEASE_NAME}-grafana" -n "${NAMESPACE}" --timeout=5m
kubectl get pods -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE_NAME}"

echo "Deployment completed."
echo "To open Grafana, run:"
echo "kubectl port-forward svc/${RELEASE_NAME}-grafana 3000:80 -n ${NAMESPACE}"
