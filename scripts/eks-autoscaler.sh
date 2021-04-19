#!/bin/bash
KUBEVERSION="$(kubectl version --short | tail -1 | awk '{print $NF}' | awk -F . '{print $2}')"
sed -i "s/CLUSTERNAME/$2/g" ./config/kubernetes/clusterautoscaler.yaml
case "$KUBEVERSION" in
   "17") sed -i "s/VERSION/1.17.3/g" ./config/kubernetes/clusterautoscaler.yaml
   kubectl apply -f ./config/kubernetes/clusterautoscaler.yaml
   ;;
   "18") sed -i "s/VERSION/1.18.3/g" ./config/kubernetes/clusterautoscaler.yaml
   kubectl apply -f ./config/kubernetes/clusterautoscaler.yaml
   ;;
   "19") sed -i "s/VERSION/1.19.1/g" ./config/kubernetes/clusterautoscaler.yaml
   kubectl apply -f ./config/kubernetes/clusterautoscaler.yaml
   ;;
   "20") sed -i "s/VERSION/1.20.0/g" ./config/kubernetes/clusterautoscaler.yaml
   kubectl apply -f ./config/kubernetes/clusterautoscaler.yaml
   ;;
esac
kubectl annotate serviceaccount cluster-autoscaler \
  -n kube-system \
  eks.amazonaws.com/role-arn=$1
kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
<<'COMMENTS'
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
kubectl annotate serviceaccount cluster-autoscaler \
  -n kube-system \
  eks.amazonaws.com/role-arn=$1
kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
kubectl patch deployment \
  cluster-autoscaler \
  --namespace kube-system \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/command", "value": [
  "./cluster-autoscaler",
  "--v=4",
  "--stderrthreshold=info",
  "--cloud-provider=aws",
  "--skip-nodes-with-local-storage=false",
  "--expander=least-waste",
  "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/$2",
  "--balance-similar-node-groups",
  "--skip-nodes-with-system-pods=false"
]}]'
COMMENTS