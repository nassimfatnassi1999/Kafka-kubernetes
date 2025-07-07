#!/bin/bash

echo "⏳ Lancement des port-forwarding pour Grafana, Prometheus et AKHQ..."

# Forward Prometheus
gnome-terminal -- bash -c "echo '🔄 Forwarding Prometheus on http://localhost:9090'; kubectl port-forward -n kafka svc/prometheus-operated 9090:9090; exec bash"

# Forward Grafana
gnome-terminal -- bash -c "echo '📊 Forwarding Grafana on http://localhost:3000'; kubectl port-forward -n kafka svc/grafana 3000:3000; exec bash"

# Forward AKHQ
gnome-terminal -- bash -c "echo '🛰️ Forwarding AKHQ on http://localhost:8080'; kubectl port-forward -n kafka svc/akhq 8080:80; exec bash"

echo "✅ Tous les port-forwardings ont été lancés dans des terminaux séparés."

