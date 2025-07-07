#!/bin/bash

set -e
# Fonction pour afficher un titre centré
function print_centered_title() {
  local title="🚀 Déploiement de la stack EFK (Elasticsearch, Fluentd, Kibana)... 🚀"
  local width=$(tput cols)
  local padding=$(( (width - ${#title}) / 2 ))
  printf "\n%*s\n\n" $((padding + ${#title})) "$title"
}

clear
print_centered_title

# Dossier des manifests
MANIFEST_DIR="./manifests"

# Liste des fichiers dans l'ordre d'application
FILES=(
  "1-efk-logging-ns.yaml"
  "2-elasticsearch-svc.yaml"
  "3-elasticsearch-sts.yaml"
  "4-kibana.yaml"
  "5-fluentd.yaml"
)

echo "🔍 Vérification de la validité des manifests..."

for file in "${FILES[@]}"; do
  echo "→ Vérification de $file..."
  kubectl apply --dry-run=client -f "$MANIFEST_DIR/$file"
done

echo "✅ Tous les manifests sont valides."

echo "🚀 Déploiement des manifests dans le cluster..."

for file in "${FILES[@]}"; do
  echo "📦 Application de $file..."
  kubectl apply -f "$MANIFEST_DIR/$file"
done

echo "🎉 Déploiement terminé avec succès."

