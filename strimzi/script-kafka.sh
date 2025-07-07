#!/bin/bash

# Fonction pour afficher un titre centré
function print_centered_title() {
  local title="🚀 Welcome Nassim Engineer - Kafka Setup 🚀"
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

# Namespace Kafka
if ! kubectl get namespace kafka &>/dev/null; then
  echo "✅ Création du namespace 'kafka'..."
  kubectl create namespace kafka
  countdown 3
else
  echo "⚠️  Namespace 'kafka' déjà existant."
fi
# Ajout des permissions RBAC pour Strimzi
if ! kubectl get role strimzi-cluster-operator-lease -n kafka &>/dev/null; then
  echo "✅ Création des permissions RBAC pour Strimzi..."
  kubectl apply -f strimzi-rbac.yaml 
  countdown 5
else
  echo "⚠️ Permissions RBAC pour Strimzi déjà existantes."
fi

#verification RBAC
echo "⚠️ Vérifier les permissions RBAC"
kubectl get roles -n kafka
countdown 5

# Installation de Strimzi
if ! kubectl get crd kafkas.kafka.strimzi.io &>/dev/null; then
  echo "📦 Installation de Strimzi..."
  kubectl apply -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.45.0/strimzi-cluster-operator-0.45.0.yaml -n kafka

  countdown 10
else
  echo "⚠️  Strimzi déjà installé."
fi

# Déploiement Kafka
if ! kubectl get kafka my-cluster -n kafka &>/dev/null; then
  echo "🚀 Déploiement Kafka avec la config fournie..."
  kubectl apply -f kafka-metrics-cluster.yaml -n kafka
  countdown 90
else
  echo "⚠️  Kafka déjà déployé."
fi

# Déploiement de AKHQ
if ! kubectl get deployment akhq -n kafka &>/dev/null; then
  echo "🚀 Déploiement de AKHQ avec manifest YAML..."
  kubectl apply -f akhq-deployment.yaml
  countdown 10
else
  echo "⚠️  AKHQ déjà installé."
fi


echo -e "\n✅ Kafka prêt. Pods en cours d'exécution :"
kubectl get pods -n kafka

