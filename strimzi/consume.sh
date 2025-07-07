#!/bin/bash

# Configuration
NAMESPACE="kafka"
CLUSTER_NAME="my-cluster"
KAFKA_POD="${CLUSTER_NAME}-kafka-0"

# Vérifier que le pod Kafka est en cours d'exécution
if ! kubectl get pod "$KAFKA_POD" -n "$NAMESPACE" &> /dev/null; then
  echo "❌ Le pod Kafka $KAFKA_POD n'est pas disponible dans le namespace $NAMESPACE."
  exit 1
fi

# Lister les topics disponibles
echo "📋 Liste des topics disponibles :"
kubectl exec -n "$NAMESPACE" "$KAFKA_POD" -- \
  bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

# Demander à l'utilisateur de choisir un topic
read -p "📝 Entrez le nom du topic que vous souhaitez consommer : " TOPIC

# Vérifier que le topic existe
if ! kubectl exec -n "$NAMESPACE" "$KAFKA_POD" -- \
  bin/kafka-topics.sh --bootstrap-server localhost:9092 --list | grep -q "^$TOPIC$"; then
  echo "❌ Le topic '$TOPIC' n'existe pas."
  exit 1
fi

# Consommer les messages du topic depuis le début
echo "📥 Consommation des messages du topic '$TOPIC' depuis le début :"
kubectl exec -n "$NAMESPACE" "$KAFKA_POD" -- \
  bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic "$TOPIC" --from-beginning

