#!/bin/bash

# List of apps to deploy from Docker Hub
declare -A apps
apps=(
  ["tindog"]="kabiratnas/tindog tindog-cluster.yaml"
  ["flappybird"]="zizizach/flappybird flappybird-cluster.yaml"
  ["supermario"]="pengbai/docker-supermario supermario-cluster.yaml"
  ["candycrush"]="sevenajay/candycrush candycrush-cluster.yaml"
)

for app in "${!apps[@]}"; do
  IFS=' ' read -r IMAGE YAML <<< "${apps[$app]}"

  echo "íº€ Deploying $app"
  echo "í³¦ Using Docker Hub image: $IMAGE"
  
  echo "í³ Applying $YAML to Kubernetes"
  kubectl apply -f $YAML

  echo "âœ… $apps deployed"
  echo ""
done

echo "í´ Current Kubernetes services and pods:"
kubectl get services
kubectl get pods
