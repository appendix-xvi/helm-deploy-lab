# Helm Deploy Lab

A Kubernetes monitoring deployment lab using Helm, Minikube or K3s, Prometheus, Grafana, and Alertmanager.

This repository demonstrates how to deploy and validate a working observability stack in a lightweight Kubernetes environment while keeping the workflow simple enough to reproduce locally.

## Overview

The lab focuses on practical Kubernetes deployment skills:

- Installing a monitoring stack with Helm
- Running the stack on Minikube or K3s
- Managing deployment values through Helm configuration
- Rendering manifests in CI before applying anything to a cluster
- Validating Prometheus, Grafana, and Alertmanager components
- Separating deployment from smoke testing

## Technology stack

| Component | Purpose |
|---|---|
| Minikube / K3s | Local or lightweight Kubernetes runtime |
| Helm | Kubernetes package management |
| Prometheus | Metrics collection and alerting |
| Grafana | Dashboard visualization |
| Alertmanager | Alert routing and notification handling |
| GitLab CI/CD | Validation, linting, and manifest rendering |

## Project structure

```text
helm-deploy-lab/
├── values-prod.yaml
├── k3s-bootstrap.sh
├── uninstall.sh
├── scripts/
│   ├── deploy-local.sh
│   └── smoke-test.sh
├── .gitlab-ci.yml
├── README.md
├── LICENSE
└── docs/
```

## Quick start

Deploy locally:

```bash
chmod +x scripts/*.sh
./scripts/deploy-local.sh
```

Run a smoke test after deployment:

```bash
./scripts/smoke-test.sh default
```

Open Grafana manually when needed:

```bash
kubectl port-forward svc/monitor-grafana 3000:80 -n default
```

Then open:

```text
http://127.0.0.1:3000
```

## Grafana access

Retrieve the Grafana admin password:

```bash
kubectl get secret monitor-grafana \
  -n default \
  -o jsonpath="{.data.admin-password}" | base64 -d
```

Default username:

```text
admin
```

## CI pipeline

The GitLab pipeline is intentionally validation-focused. It does not apply manifests to a real cluster.

| Job | Stage | Purpose |
|---|---|---|
| `validate_yaml` | `validate` | Runs YAML lint against `values-prod.yaml` |
| `helm_lint` | `lint` | Runs Helm lint against kube-prometheus-stack with this repo's values |
| `lint_scripts` | `lint` | Runs ShellCheck against helper scripts |
| `render_manifests` | `render` | Renders manifests and stores them as a CI artifact |

This keeps the repository safe for portfolio demonstration because CI proves the configuration can render without requiring cluster credentials.

## Validation

A successful local deployment should confirm:

- Helm release is installed successfully.
- Grafana deployment reaches rollout success.
- Prometheus stack pods are running.
- Grafana service exists.
- `scripts/smoke-test.sh` can reach the Grafana login endpoint through port forwarding.
- Uninstall steps remove the lab cleanly.

## Documentation

| Topic | Path |
|---|---|
| K3s bootstrap guide | `docs/bootstrap.md` |
| Minikube walkthrough | `docs/minikube-monitoring.md` |
| General deployment guide | `docs/deploy.md` |
| Grafana dashboard notes | `docs/grafana-dashboards.md` |
| Uninstall procedure | `docs/uninstall.md` |
| Scenario examples | `docs/scenarios.md` |

## Screenshots and demo

Screenshots or GIFs should only be referenced here when the files exist under `docs/images/`.

## Notes

- This repository is intended for local or lab environments.
- `values-prod.yaml` is production-like for demonstration, not a hardened production baseline.
- Review storage, ingress, authentication, alert routing, and resource limits before adapting this to a shared cluster.

## License

MIT. See [LICENSE](LICENSE).
