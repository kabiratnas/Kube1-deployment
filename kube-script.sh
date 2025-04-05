#!/bin/bash

# List of apps to deploy
declare -A apps
apps=(
  ["tindog"]="kabiratnas/tindog tindog-cluster.yaml"
  ["flappybird"]="zizizach/flappybird flappybird-cluster.yaml"
  ["supermario"]="pengbai/docker-supermario supermario-cluster.yaml"
  ["candycrush"]="sevenajay/candycrush candycrush-cluster.yaml"
)

for app in "${!apps[@]}"; do
  IFS=' ' read -r IMAGE YAML <<< "${apps[$app]}"
  DEPLOYMENT_NAME="$app"
  SERVICE_NAME="${app}-service"

  echo "�️  Deleting existing $app deployment and service (if any)..."
  kubectl delete deployment "$DEPLOYMENT_NAME" --ignore-not-found
  kubectl delete service "$SERVICE_NAME" --ignore-not-found

  echo "� Deploying $app using $YAML"
  kubectl apply -f "$YAML"

  echo "⏳ Waiting for $app pod to be ready..."
  while true; do
    STATUS=$(kubectl get pods -l app=$app -o jsonpath='{.items[0].status.phase}')
    if [ "$STATUS" == "Running" ]; then
      echo "✅ $app pod is Running"
      break
    else
      echo "⌛ $app status: $STATUS ...waiting..."
      sleep 5
    fi
  done

  echo ""
done

echo "� Final status:"
kubectl get services
kubectl get pods
