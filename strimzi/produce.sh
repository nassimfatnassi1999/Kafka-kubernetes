#!/bin/bash

# Paramètres
NAMESPACE="kafka"
CLUSTER_NAME="my-cluster"
PARTITIONS=3
REPLICATION=1

# Topics et messages associés
declare -A TOPIC_MESSAGES

TOPIC_MESSAGES["topic-tarek"]="Kafka est une plateforme distribuée de streaming.\nElle permet de publier, souscrire, stocker et traiter des flux de données."
TOPIC_MESSAGES["topic-walid"]="Un topic Kafka est une catégorie à laquelle les messages sont envoyés.\nIl peut être découpé en partitions pour paralléliser le traitement."
TOPIC_MESSAGES["topic-zied"]="Chaque partition est un journal ordonné et immuable.\nLes messages y sont ajoutés dans l’ordre d’arrivée."
TOPIC_MESSAGES["topic-mohamed"]="La réplication permet d’assurer la haute disponibilité.\nChaque partition peut avoir plusieurs copies (réplicas)."

# Créer un topic Kafka via un CRD KafkaTopic
create_topic() {
  local topic_name=$1
  cat <<EOF | kubectl apply -n $NAMESPACE -f -
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaTopic
metadata:
  name: $topic_name
  labels:
    strimzi.io/cluster: $CLUSTER_NAME
spec:
  partitions: $PARTITIONS
  replicas: $REPLICATION
EOF
}

# Produire des messages dans un topic
produce_messages() {
  local topic_name=$1
  local messages="${TOPIC_MESSAGES[$topic_name]}"

  while IFS= read -r msg; do
    echo "$msg" | kubectl exec -i -n $NAMESPACE $CLUSTER_NAME-kafka-0 -- \
      bin/kafka-console-producer.sh \
      --bootstrap-server localhost:9092 \
      --topic $topic_name > /dev/null
    echo "Message envoyé à $topic_name : $msg"
  done <<< "$messages"
}

# Boucle principale
for topic in "${!TOPIC_MESSAGES[@]}"; do
  echo "Création du topic : $topic"
  create_topic "$topic"
  sleep 2
  echo "Production de messages dans $topic"
  produce_messages "$topic"
done
