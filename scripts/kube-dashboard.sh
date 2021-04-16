#!/bin/sh
#Installing Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#Installing kubernetes dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
#Creating Service Account to access kubernetes dashboard
kubectl apply -f ./config/kubernetes/eks-admin-service-account.yaml
#Fetching the eks-admin Secret
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
#Attaching Load balancer for Kubernetes Dashboard
kubectl patch svc/kubernetes-dashboard -n kubernetes-dashboard -p '{"spec":{"type": "loadbalancer"}}'