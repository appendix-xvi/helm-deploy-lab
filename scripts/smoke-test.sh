#!/usr/bin/env bash

set -euo pipefail

RELEASE_NAME="${RELEASE_NAME:-monitor}"
NAMESPACE="${1:-${NAMESPACE:-default}}"
LOCAL_PORT="${LOCAL_PORT:-3000}"
SERVICE_NAME="${RELEASE_NAME}-grafana"

cleanup() {
  if [[ -n "${PORT_FORWARD_PID:-}" ]]; then
    kill "${PORT_FORWARD_PID}" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

kubectl rollout status "deployment/${RELEASE_NAME}-grafana" -n "${NAMESPACE}" --timeout=5m
kubectl get pods -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE_NAME}"
kubectl get svc -n "${NAMESPACE}" "${SERVICE_NAME}"

kubectl port-forward -n "${NAMESPACE}" "svc/${SERVICE_NAME}" "${LOCAL_PORT}:80" >/tmp/helm-deploy-lab-port-forward.log 2>&1 &
PORT_FORWARD_PID="$!"

sleep 5

curl -fsS "http://127.0.0.1:${LOCAL_PORT}/login" >/dev/null

echo "Smoke test passed: Grafana login endpoint is reachable on http://127.0.0.1:${LOCAL_PORT}/login"
