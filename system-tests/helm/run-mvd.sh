#!/usr/bin/bash
echo "installing azurite..."
helm install azurite ./helm-charts/azurite

echo "installing did-server..."
helm install did-server ./helm-charts/did-server

echo "installing registration-service..."
helm install registration-service ./helm-charts/registration-service

echo "installing company1..."
helm install company1 --set nameOverride=company1,ports.debug.port=5005 ./helm-charts/company

echo "installing company2..."
helm install company2 --set nameOverride=company2,ports.debug.port=5006 ./helm-charts/company

echo "installing company3..."
helm install company3 --set nameOverride=company3,ports.debug.port=5007 ./helm-charts/company

echo "installing newman..."
helm install newman ./helm-charts/newman

echo "installing cli-tools..."
helm install cli-tools ./helm-charts/cli-tools

echo "installing company1 data dashboard..."
helm install company1-datadashboard --set nameOverride=company1-datadashboard,companyName=company1 ./helm-charts/company-dashboard

echo "installing company2 data dashboard..."
helm install company2-datadashboard --set nameOverride=company2-datadashboard,companyName=company2 ./helm-charts/company-dashboard

echo "installing company3 data dashboard..."
helm install company3-datadashboard --set nameOverride=company3-datadashboard,companyName=company3 ./helm-charts/company-dashboard
