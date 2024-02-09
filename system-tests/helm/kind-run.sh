#!/usr/bin/bash

#echo "deleting existing cluster..."
#kind delete cluster

echo "creating new cluster..."
kind create cluster --config=kind-cluster.yaml

echo "create the docker images..."
docker compose -f docker-compose.yml build

echo "load the images..."
kind load docker-image edc-connector-dashboard-company1:v.01 edc-connector-dashboard-company2:v.01 edc-connector-dashboard-company3:v.01 edc-connector:v.01 registration-service:v.01 cli-tools:v.01

echo "apply ingress..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "wait until ingress is ready..."
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
