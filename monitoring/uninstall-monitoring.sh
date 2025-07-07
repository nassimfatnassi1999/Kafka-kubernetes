#!/bin/bash

# Définir le namespace
NAMESPACE="monitoring"

# Fonction pour afficher un titre centré
function print_centered_title() {
  local title="🧹 Désinstallation du Monitoring"
  local width=$(tput cols)
  local padding=$(( (width - ${#title}) / 2 ))
  printf "\n%*s\n\n" $((padding + ${#title})) "$title"
}

function countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "⏳ Attente : $seconds seconde(s)...\r"
    sleep 1
    ((seconds--))
  done
  echo ""
}

clear
print_centered_title

echo "📦 Suppression de Grafana..."
kubectl delete -f grafana.yaml -n "$NAMESPACE"
countdown 5

echo "📦 Suppression de Prometheus..."
kubectl delete -f prometheus.yaml -n "$NAMESPACE"
countdown 5

echo "📏 Suppression des règles Prometheus..."
kubectl delete -f prometheus-rules.yaml -n "$NAMESPACE"
countdown 5

echo "📡 Suppression du PodMonitor..."
kubectl delete -f strimzi-pod-monitor.yaml -n "$NAMESPACE"
countdown 5

echo "🔐 Suppression du secret 'additional-scrape-configs'..."
kubectl delete secret additional-scrape-configs -n "$NAMESPACE" --ignore-not-found
countdown 3

echo "🗑️ Suppression du Prometheus Operator..."
kubectl delete -f bundle.yaml -n "$NAMESPACE"
countdown 5

echo "🧼 Suppression des CRDs (optionnel, attention si utilisées ailleurs)..."
kubectl delete crd alertmanagers.monitoring.coreos.com \
  podmonitors.monitoring.coreos.com \
  prometheuses.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  thanosrulers.monitoring.coreos.com \
  --ignore-not-found
countdown 5

echo "📁 Suppression du namespace $NAMESPACE (optionnel)..."
read -p "Voulez-vous supprimer le namespace '$NAMESPACE' ? [y/N]: " delete_ns
if [[ "$delete_ns" =~ ^[Yy]$ ]]; then
  kubectl delete namespace "$NAMESPACE"
  echo "📛 Namespace supprimé."
else
  echo "✅ Namespace conservé."
fi

echo -e "\n✅ Désinstallation terminée."

