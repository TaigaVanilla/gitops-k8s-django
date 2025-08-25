# GitOps Deployment Commands - Library Management System

Quick reference for deploying and managing the Django Library Management System using ArgoCD and Kubernetes.

## 🚀 Quickstart

### Prerequisites Check
```bash
kubectl cluster-info
argocd version
helm version
```

### Deploy Database & Application
```bash
# 1. Deploy MySQL
kubectl apply -f infra/mysql-deployment.yaml

# 2. Deploy ArgoCD Application
kubectl apply -f infra/argocd-app.yaml

# 3. Verify deployment
kubectl get all -n library-system
argocd app get library-management-system
```

## 🔐 ArgoCD Access

### Port-Forward to ArgoCD UI
```bash
# Access ArgoCD UI locally
kubectl port-forward --address 0.0.0.0 svc/argocd-server 8080:443

# Open browser: https://localhost:8080
```

### Get Admin Credentials
```bash
# Retrieve default admin password
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Login via CLI
argocd login localhost:8080 --username admin --password <password>
```

## 🛠️ Core Operations

### Application Management
```bash
# Sync application
argocd app sync library-management-system

# Check status
argocd app get library-management-system

# View resources
kubectl get all -n library-system
```

### Monitoring & Debugging
```bash
# Check pod status
kubectl get pods -n library-system

# View application logs
kubectl logs -f deployment/library-management-system -n library-system

# Check service endpoints
kubectl get endpoints -n library-system
```

### Database Operations
```bash
# Check MySQL status
kubectl get pods -n library-system -l app=mysql

# Connect to MySQL
kubectl exec -it deployment/mysql -n library-system -- mysql -u library_user -p
# Password: library_password
```

## 🚨 Emergency Procedures

### Force Restart & Rollback
```bash
# Force restart deployment
kubectl rollout restart deployment/library-management-system -n library-system

# Rollback to previous version
kubectl rollout undo deployment/library-management-system -n library-system

# Check rollout status
kubectl rollout status deployment/library-management-system -n library-system
```

### Troubleshooting
```bash
# Check events
kubectl get events -n library-system --sort-by='.lastTimestamp'

# Describe resources
kubectl describe pod -l app=library-management-system -n library-system

# Check resource usage
kubectl top pods -n library-system
```

## 🧹 Cleanup

### Remove Application
```bash
# Delete ArgoCD application
kubectl delete -f infra/argocd-app.yaml

# Delete namespace
kubectl delete namespace library-system
```

### Remove Database
```bash
# Delete MySQL deployment
kubectl delete -f infra/mysql-deployment.yaml
```
