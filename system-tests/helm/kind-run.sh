#!/usr/bin/bash

echo "creating new cluster..."
kind create cluster --config=kind-cluster.yaml

echo "load the images..."
kind load docker-image edc-connector-dashboard-company1:v0.2.0 edc-connector-dashboard-company2:v0.2.0 edc-connector-dashboard-company3:v0.2.0 edc-connector:v0.2.0 registration-service:v0.2.0 cli-tools:v0.2.0

echo "apply ingress..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "wait until ingress is ready..."
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s
