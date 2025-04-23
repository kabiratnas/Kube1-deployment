# Kube1-deployment: High Availability EKS Cluster with Multi-App Deployment

This project sets up a high availability Kubernetes cluster on AWS using `eksctl`, and deploys multiple web apps like Candy Crush, Flappy Bird, Super Mario, and Tindog. The setup uses YAML configuration files and a shell script to automate cluster provisioning and application deployment.

## Project Files
- `candycrush-cluster.yaml` – EKS config for Candy Crush
- `flappybird-cluster.yaml` – EKS config for Flappy Bird
- `supermario-cluster.yaml` – EKS config for Super Mario
- `tindog-cluster.yaml` – EKS config for Tindog
- `kube-script.sh` – Main automation script for provisioning and deploying
- `config.yaml` – Optional shared config for base cluster setup

## Cluster Config Structure
All cluster config files follow this general template:
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: my-eks-cluster
  region: us-west-2
nodeGroups:
  - name: worker-nodes
    instanceType: t3.medium
    desiredCapacity: 4
    minSize: 4
    maxSize: 4
    iam:
      withAddonPolicies:
        imageBuilder: true
```

## Requirements

Ensure the following packages are installed:

### macOS / Linux:
```bash
brew install eksctl
brew install kubectl
brew install awscli
```

### Ubuntu / Debian:
```bash
sudo apt update
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo apt install -y kubectl awscli
```

### Configure AWS CLI:
```bash
aws configure
```
Enter your AWS Access Key, Secret Key, region (e.g., `us-west-2`), and default output format (e.g., `json`).

## How to Run

1. Clone the repository:
```bash
git clone https://github.com/kabiratnas/Kube1-deployment.git
cd Kube1-deployment
```

2. Make the automation script executable:
```bash
chmod +x kube-script.sh
```

3. Run the deployment script:
```bash
./kube-script.sh
```

4. Check services and access deployed apps:
```bash
kubectl get svc
```
Use the EXTERNAL-IP of the service to open the app in your browser.

## Notes
- Adjust region, instance type, and app config in each `.yaml` file as needed.
- `deploy-webapp.sh` is deprecated — use only `kube-script.sh`.

## Kubernetes Dashboard Setup

To enable a visual interface for managing your Kubernetes cluster, this project also supports deployment of the Kubernetes Dashboard.

### Step-by-Step Installation

1. **Install Helm**:
```bash
wget https://get.helm.sh/helm-v3.17.2-linux-amd64.tar.gz
tar -zxvf helm-v3.17.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
```

2. **Add the Dashboard Helm Chart**:
```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
```

3. **Apply the Required Dashboard YAMLs**:
```bash
kubectl apply -f admin-user-dashboard.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

4. **Install the Dashboard via Helm**:
```bash
helm install k8s-dashboard kubernetes-dashboard/kubernetes-dashboard   --namespace kubernetes-dashboard   --create-namespace
```

5. **Create Access Token** (to log in to the dashboard):
```bash
kubectl -n kubernetes-dashboard create token admin-user
```

6. **Expose the Dashboard to the Internet**:
```bash
kubectl -n kubernetes-dashboard patch svc k8s-dashboard-kong-proxy   -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the external IP:
```bash
kubectl get svc -n kubernetes-dashboard
```

Open the IP in a browser and use the token from step 5 to log in.

**Security Note**: Be cautious when exposing the dashboard publicly. Always implement access controls and RBAC as needed.

**Author**: Ubuntu ([github.com/kabiratnas](https://github.com/kabiratnas))
