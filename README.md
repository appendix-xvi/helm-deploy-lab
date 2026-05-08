# Helm Deploy Lab

A Kubernetes monitoring deployment lab using Helm, Minikube or K3s, Prometheus, Grafana, and Alertmanager.

This repository demonstrates how to package and deploy a working observability stack in a lightweight Kubernetes environment while keeping the workflow simple enough to reproduce locally.

## Overview

The lab focuses on practical Kubernetes deployment skills:

- Installing a monitoring stack with Helm
- Running the stack on Minikube or K3s
- Managing deployment values through Helm configuration
- Validating Prometheus, Grafana, and Alertmanager components
- Documenting deployment, uninstall, and dashboard usage

## Technology Stack

| Component | Purpose |
|---|---|
| Minikube / K3s | Local or lightweight Kubernetes runtime |
| Helm | Kubernetes package management |
| Prometheus | Metrics collection and alerting |
| Grafana | Dashboard visualization |
| Alertmanager | Alert routing and notification handling |
| GitLab CI/CD | Optional pipeline demonstration |

## Project Structure

```text
helm-deploy-lab/
├── values-prod.yaml
├── k3s-bootstrap.sh
├── uninstall.sh
├── scripts/
│   └── deploy-local.sh
├── .gitlab-ci.yml
├── README.md
├── LICENSE
└── docs/
    ├── bootstrap.md
    ├── minikube-monitoring.md
    ├── deploy.md
    ├── uninstall.md
    ├── grafana-dashboards.md
    ├── scenarios.md
    └── images/
        ├── grafana-sli.png
        ├── prometheus-overview.png
        └── grafana-lab-demo.gif
```

## Quick Start

Start Minikube:

```bash
minikube start --memory=4096 --cpus=2
```

Add the Prometheus community Helm repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Install or upgrade the monitoring stack:

```bash
helm upgrade --install monitor prometheus-community/kube-prometheus-stack \
  -f values-prod.yaml
```

Forward Grafana to the local machine:

```bash
kubectl port-forward svc/monitor-grafana 3000:80 -n default
```

## Grafana Access

Retrieve the Grafana admin password:

```bash
kubectl get secret monitor-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d
```

Default username:

```text
admin
```

## Documentation

| Topic | Path |
|---|---|
| K3s bootstrap guide | `docs/bootstrap.md` |
| Minikube walkthrough | `docs/minikube-monitoring.md` |
| General deployment guide | `docs/deploy.md` |
| Grafana dashboard notes | `docs/grafana-dashboards.md` |
| Uninstall procedure | `docs/uninstall.md` |
| Scenario examples | `docs/scenarios.md` |

## Screenshots and Demo

<p align="center">
  <img src="docs/images/grafana-lab-demo.gif" width="700"/>
  <br><em>Grafana login and dashboard demonstration</em>
</p>

<p align="center">
  <img src="docs/images/grafana-sli.png" width="600"/>
  <br><em>Grafana SLI dashboard</em>
</p>

<p align="center">
  <img src="docs/images/prometheus-overview.png" width="600"/>
  <br><em>Prometheus metrics overview</em>
</p>

## Validation

A successful deployment should confirm:

- Helm release is installed successfully
- Prometheus pods are running
- Grafana service is reachable through port forwarding
- Dashboards load without missing datasource errors
- Uninstall steps remove the lab cleanly

## Notes

- This repository is intended for local or lab environments.
- `values-prod.yaml` is production-like for demonstration, not a hardened production baseline.
- Review storage, ingress, authentication, alert routing, and resource limits before adapting this to a shared cluster.

## License

MIT. See [LICENSE](LICENSE).

## Author

Nuntin Padmadin

- GitHub: [github.com/Nuntin](https://github.com/Nuntin)
- LinkedIn: [linkedin.com/in/nuntin-padmadin-97b708145](https://www.linkedin.com/in/nuntin-padmadin-97b708145/)
