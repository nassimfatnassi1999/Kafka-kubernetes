#!/bin/bash

# Fonction pour afficher un titre centré
function print_centered_title() {
  local title="🧹 Uninstall Kafka Setup - Nassim Engineer 🧹"
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

# Suppression des topics Kafka
if kubectl get kafkatopic my-topic -n kafka &>/dev/null; then
  echo "🗑️  Suppression du topic Kafka 'my-topic'..."
  kubectl delete -f kafka-topic.yaml -n kafka
  countdown 5
else
  echo "⚠️  Topic 'my-topic' introuvable."
fi

# Suppression de AKHQ
if kubectl get deployment akhq -n kafka &>/dev/null; then
  echo "🗑️  Suppression de AKHQ..."
  kubectl delete -f akhq-deployment.yaml
  countdown 10
else
  echo "⚠️  AKHQ non déployé."
fi

# Suppression du Kafka cluster
if kubectl get kafka my-cluster -n kafka &>/dev/null; then
  echo "🗑️  Suppression du Kafka cluster..."
  kubectl delete -f kafka-metrics-cluster.yaml -n kafka
  countdown 20
else
  echo "⚠️  Kafka cluster 'my-cluster' non trouvé."
fi

# Suppression de Strimzi (CRDs et opérateur)
if kubectl get crd kafkas.kafka.strimzi.io &>/dev/null; then
  echo "🗑️  Suppression de Strimzi..."
  kubectl delete -f https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.45.0/strimzi-cluster-operator-0.45.0.yaml -n kafka
  countdown 10
else
  echo "⚠️  Strimzi non trouvé ou déjà supprimé."
fi

# Suppression du namespace Kafka
if kubectl get namespace kafka &>/dev/null; then
  echo "🗑️  Suppression du namespace 'kafka'..."
  kubectl delete namespace kafka
  countdown 10
else
  echo "⚠️  Namespace 'kafka' introuvable."
fi

echo -e "\n✅ Désinstallation terminée. Clôture des ressources Kafka."

