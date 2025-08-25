# GitOps Kubernetes Django Library Management System

A complete GitOps workflow for deploying a Django-based Library Management System to Kubernetes using ArgoCD. This project demonstrates modern DevOps practices with automated CI/CD pipelines, containerization, and infrastructure as code.

## 🏗️ Architecture

- **Backend**: Django 5.2.5 + MySQL 8.0
- **Container**: Docker with Python 3.13-slim + Gunicorn WSGI server
- **Orchestration**: Kubernetes with Helm charts
- **CI/CD**: GitHub Actions (CI) + ArgoCD (CD)
- **Registry**: Docker Hub

## 🚀 Quick Start

### Prerequisites

- ✅ ArgoCD installed and configured
- ✅ Kubernetes cluster running (k3s, minikube, or cloud provider)
- ✅ Docker Hub account
- ✅ GitHub repository with secrets configured

### 1. Setup GitHub Secrets

Add these secrets to your GitHub repository:

- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token

### 2. Update Configuration

1. **Update Docker Hub username** in `helm/values.yaml`:
   ```yaml
   image:
     repository: your-dockerhub-username/library-management-system
   ```

2. **Update GitHub repository URL** in `infra/argocd-app.yaml`:
   ```yaml
   source:
     repoURL: https://github.com/your-username/gitops-k8s-django.git
   ```

### 3. Deploy MySQL Database

```bash
kubectl apply -f infra/mysql-deployment.yaml
```

### 4. Deploy ArgoCD Application

```bash
kubectl apply -f infra/argocd-app.yaml
```

### 5. Access the Application

The application will be available at:
- **NodePort**: `http://your-node-ip:30080`
- **ArgoCD UI**: Check ArgoCD dashboard for deployment status

## 🔄 GitOps Workflow
<img width="916" height="437" alt="Image" src="https://github.com/user-attachments/assets/fcf76200-6bdc-4034-a1e7-ceb4051abebe" />

### CI Pipeline (GitHub Actions)

**File**: `.github/workflows/docker_build_and_push.yml`

1. **Trigger**: Push to `main` branch or manual workflow dispatch
2. **Build**: Docker image with GitHub run number tag
3. **Push**: Image to Docker Hub
4. **Update**: Helm chart values.yaml with new image tag
5. **Commit**: Changes back to Git repository

**Features**:
- Automated builds on main branch pushes
- Manual workflow dispatch support
- Docker layer caching with GitHub Actions
- Automatic Helm chart updates

### CD Pipeline (ArgoCD)

**File**: `infra/argocd-app.yaml`

1. **Monitor**: Git repository for changes
2. **Detect**: New image tag in values.yaml
3. **Deploy**: Updated application to Kubernetes
4. **Verify**: Deployment health and status

**Features**:
- Automated sync with pruning and self-healing
- Namespace creation on demand
- Revision history tracking (10 revisions)

## 🛠️ Application Features

### Library Management System

**Models**:
- **Member**: User registration, authentication, profile management
- **Book**: Inventory management, availability tracking, metadata
- **Loan**: Book borrowing, due dates, fine calculation
- **Reservation**: Book reservation system with status tracking
- **Staff**: Administrative users with role-based access

**Key Functionality**:
- User authentication with bcrypt password hashing
- Role-based access control (Member/Staff/Admin)
- Book borrowing and return management
- Reservation system
- Fine calculation for overdue books
- Comprehensive admin interface

### Security Features

- bcrypt password hashing
- Non-root container user
- Session-based authentication
- Role-based access control
- Environment variable configuration

## 🔧 Configuration

### Environment Variables

The application uses these environment variables (via python-decouple):

- `SECRET_KEY`: Django secret key
- `DEBUG`: Django debug mode
- `ALLOWED_HOSTS`: Allowed hosts for Django
- `DB_NAME`: MySQL database name
- `DB_USER`: MySQL username
- `DB_PASSWORD`: MySQL password
- `DB_HOST`: MySQL host
- `DB_PORT`: MySQL port

### Helm Values

Key configuration options in `helm/values.yaml`:

- `image.repository`: Docker image repository
- `image.tag`: Docker image tag
- `service.type`: Service type (NodePort)
- `service.nodePort`: NodePort for external access (30080)
- `django.secretKey`: Django secret key
- `database.*`: Database configuration
- `replicaCount`: Number of application replicas

### Database Configuration

**MySQL Setup** (`infra/mysql-deployment.yaml`):
- MySQL 8.0 with persistent storage
- Pre-configured database: `library_db`
- User: `library_user`
- Secrets for password management
- ClusterIP service for internal access

## 📊 Monitoring & Operations

### Check Application Status

```bash
# Check pods
kubectl get pods -n library-system

# Check services
kubectl get svc -n library-system

# Check logs
kubectl logs -f deployment/library-management-system -n library-system

# Check ArgoCD application
argocd app get library-management-system
```

### ArgoCD Dashboard

Access ArgoCD UI to monitor:
- Application sync status
- Deployment health
- Resource status
- Sync history
- Git repository changes

## 🐳 Container Details

### Docker Image

**Entrypoint**: Automated database migrations and static file collection

### Kubernetes Resources

- **Deployment**: Application with health checks
- **Service**: NodePort service on port 30080
- **HPA**: Horizontal Pod Autoscaler (disabled by default)
- **ServiceAccount**: Dedicated service account
- **Probes**: Liveness and readiness probes

## 🔒 Security Considerations

- Database credentials stored in Kubernetes Secrets
- Django secret key stored in Kubernetes Secret
- Non-root user in Docker container
- Environment variables for configuration
- bcrypt password hashing
- Session-based authentication

## 🐛 Troubleshooting

### Debug Commands

```bash
# Check ArgoCD application events
kubectl describe application library-management-system -n default

# Check pod events
kubectl describe pod -l app=library-management-system -n library-system

# Check service endpoints
kubectl get endpoints -n library-system

# Check MySQL connectivity
kubectl exec -it deployment/mysql -n library-system -- mysql -u library_user -p
```

### Manual Operations

```bash
# Build and test locally
cd app
docker build -t library-management-system .
docker run -p 8000:8000 library-management-system

# Helm operations
helm install library-system helm/ --namespace library-system
helm upgrade library-system helm/ --namespace library-system
helm uninstall library-system

# ArgoCD operations
argocd app sync library-management-system
argocd app get library-management-system
```
