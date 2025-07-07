#!/bin/bash

# Définir le namespace
NAMESPACE="monitoring"

# Fonction pour afficher un titre centré
function print_centered_title() {
  local title="📈 Monitoring Setup 🚀"
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

# Namespace monitoring
if ! kubectl get namespace $NAMESPACE &>/dev/null; then
  echo "✅ Création du namespace 'monitoring'..."
  kubectl create namespace $NAMESPACE
  countdown 3
else
  echo "⚠️  Namespace 'kafka' déjà existant."
fi
# Prometheus Operator
echo "📥 Récupération et application du Prometheus Operator..."
curl -s https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release/bundle.yaml | \
  sed -e "s/namespace: .*/namespace: $NAMESPACE/" > bundle.yaml
kubectl apply -f bundle.yaml -n "$NAMESPACE"
countdown 15

# Secret Prometheus
if ! kubectl get secret additional-scrape-configs -n "$NAMESPACE" &>/dev/null; then
  echo "🔐 Création du secret 'additional-scrape-configs'..."
  kubectl create secret generic additional-scrape-configs --from-file=prometheus-additional.yaml -n "$NAMESPACE"
  countdown 10
else
  echo "⚠️  Secret déjà existant."
fi

# PodMonitor
if ! kubectl get podmonitor strimzi-pod-monitor -n "$NAMESPACE" &>/dev/null; then
  echo "📡 Déploiement du PodMonitor Strimzi..."
  kubectl apply -f strimzi-pod-monitor.yaml -n "$NAMESPACE"
  countdown 15
else
  echo "⚠️  PodMonitor déjà appliqué."
fi

# Prometheus Rules
if ! kubectl get prometheusrule kafka-rules -n "$NAMESPACE" &>/dev/null; then
  echo "📏 Application des règles Prometheus..."
  kubectl apply -f prometheus-rules.yaml -n "$NAMESPACE"
  countdown 15
else
  echo "⚠️  Règles Prometheus déjà existantes."
fi

# Prometheus
if ! kubectl get prometheus kafka -n "$NAMESPACE" &>/dev/null; then
  echo "📈 Déploiement de Prometheus..."
  kubectl apply -f prometheus.yaml -n "$NAMESPACE"
  countdown 15
else
  echo "⚠️  Prometheus déjà déployé."
fi

# Grafana
if ! kubectl get deployment grafana -n "$NAMESPACE" &>/dev/null; then
  echo "📊 Déploiement de Grafana..."
  kubectl apply -f grafana.yaml -n "$NAMESPACE"
  countdown 15
else
  echo "⚠️  Grafana déjà présent."
fi

# Services & Pods
echo -e "\n📋 Services disponibles dans le namespace $NAMESPACE :"
kubectl get svc -n "$NAMESPACE"

echo -e "\n✅ Pods dans le namespace $NAMESPACE :"
kubectl get pods -n "$NAMESPACE"

echo -e "\n🎉 Monitoring déployé avec succès !"

