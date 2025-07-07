#!/bin/bash

# Couleur rouge pour les titres
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}🧨 Suppression complète de Kafka, Prometheus, Grafana, Strimzi, et les configurations associées...${NC}"
echo "⏳ Cela peut prendre quelques instants..."

NAMESPACE="kafka"

# Suppression de Grafana
echo "📊 Suppression de Grafana..."
kubectl delete -f grafana.yaml -n $NAMESPACE --ignore-not-found

# Suppression de Prometheus instance
echo "📈 Suppression de Prometheus..."
kubectl delete -f prometheus.yaml -n $NAMESPACE --ignore-not-found

# Suppression des règles Prometheus
echo "📏 Suppression des règles Prometheus..."
kubectl delete -f prometheus-rules.yaml -n $NAMESPACE --ignore-not-found

# Suppression du PodMonitor
echo "📡 Suppression du PodMonitor..."
kubectl delete -f strimzi-pod-monitor.yaml -n $NAMESPACE --ignore-not-found

# Suppression du secret de scrape
echo "🔐 Suppression du secret 'additional-scrape-configs'..."
kubectl delete secret additional-scrape-configs -n $NAMESPACE --ignore-not-found

# Suppression des topics Kafka
echo "📚 Suppression des topics Kafka..."
kubectl delete -f kafka-topic.yaml -n $NAMESPACE --ignore-not-found

# Suppression du Kafka cluster
echo "🚫 Suppression du cluster Kafka..."
kubectl delete -f kafka-metrics-cluster.yaml -n $NAMESPACE --ignore-not-found

# Suppression de Strimzi
echo "🧹 Suppression de Strimzi..."
kubectl delete -f bundle.yaml -n $NAMESPACE --ignore-not-found

# Suppression des CRDs de Strimzi (si souhaité)
echo "🧨 Suppression des CRDs de Strimzi..."
kubectl delete crd kafkas.kafka.strimzi.io kafkatopics.kafka.strimzi.io kafkausers.kafka.strimzi.io \
  kafkausers.kafka.strimzi.io kafkaentities.kafka.strimzi.io --ignore-not-found

# Suppression du namespace complet
echo "🧼 Suppression du namespace complet '$NAMESPACE'..."
kubectl delete namespace $NAMESPACE --ignore-not-found

echo -e "\n✅ ${RED}Nettoyage terminé !${NC}"

