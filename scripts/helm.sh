#!/bin/bash
#Install Helm
<<'COMMENTS'
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
chown jenkins:jenkins get_helm.sh
./get_helm.sh
COMMENTS
#Install promtail
helm repo add grafana https://grafana.github.io/helm-charts --force-update
kubectl create namespace cms-container-monitoring
helm install promtail --namespace cms-container-monitoring grafana/promtail -f ./config/helm/promtailvalues.yaml || helm upgrade promtail --namespace cms-container-monitoring grafana/promtail -f ./config/helm/promtailvalues.yaml
#Install Prometheus kube state metrics and Node exporter
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts --force-update
helm install prometheus -f ./config/helm/prometheusvalues.yaml prometheus-community/prometheus --namespace cms-container-monitoring || helm upgrade prometheus -f ./config/helm/prometheusvalues.yaml prometheus-community/prometheus --namespace cms-container-monitoring