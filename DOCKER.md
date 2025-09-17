# Finbro-GPT Docker Deployment Guide

## Quick Start

### Prerequisites
- Docker installed on your system
- OpenAI API key
- For docker-compose: Docker Compose installed

### Environment Setup

1. **Create .env file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env file with your OpenAI API key:**
   ```bash
   OPENAI_API_KEY=your-openai-api-key-here
   ```

### Deployment Options

#### Option 1: Using Docker Compose (Recommended for Development)

1. **Build and run:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   Open your browser and navigate to `http://localhost:8501`

3. **Run in background:**
   ```bash
   docker-compose up -d
   ```

4. **Stop the application:**
   ```bash
   docker-compose down
   ```

#### Option 2: Using Docker Directly

1. **Build the image:**
   ```bash
   docker build -t finbro-gpt .
   ```

2. **Run the container:**
   ```bash
   docker run -d \
     --name finbro-gpt \
     -p 8501:8501 \
     -e OPENAI_API_KEY=your-openai-api-key \
     -v $(pwd)/exports:/app/exports \
     --restart unless-stopped \
     finbro-gpt
   ```

3. **Access the application:**
   Open your browser and navigate to `http://localhost:8501`

#### Option 3: Production Deployment

1. **Build with build args for production:**
   ```bash
   docker build -t finbro-gpt:prod .
   ```

2. **Run with resource limits:**
   ```bash
   docker run -d \
     --name finbro-gpt \
     -p 8501:8501 \
     -e OPENAI_API_KEY=your-openai-api-key \
     -v $(pwd)/exports:/app/exports \
     --memory=2g \
     --cpus=1.0 \
     --restart unless-stopped \
     --health-cmd="curl -f http://localhost:8501/_stcore/health || exit 1" \
     --health-interval=30s \
     --health-timeout=10s \
     --health-retries=3 \
     finbro-gpt:prod
   ```

## Management Commands

### View container logs:
```bash
docker logs finbro-gpt
# or with docker-compose
docker-compose logs -f finbro-gpt
```

### Check container status:
```bash
docker ps finbro-gpt
# or health check
docker inspect finbro-gpt --format='{{.State.Health.Status}}'
```

### Stop and remove:
```bash
docker stop finbro-gpt && docker rm finbro-gpt
# or with docker-compose
docker-compose down
```

### Access container shell:
```bash
docker exec -it finbro-gpt /bin/bash
```

## Environment Variables

| Variable | Required | Description | Default |
|----------|----------|-------------|---------|
| `OPENAI_API_KEY` | Yes | OpenAI API key for AI functionality | None |
| `PYTHONUNBUFFERED` | No | Python output buffering | `1` |

## Volume Management

### Charts and Exports:
- The `/app/exports` directory is mounted to persist generated charts
- Charts are saved to `exports/charts/` directory

### Data Persistence:
- All data is fetched in real-time, no database persistence needed
- Chat history is stored in session state (not persisted)

## Security Considerations

1. **API Key Security:**
   - Never commit API keys to version control
   - Use environment variables or Docker secrets for production

2. **Container Security:**
   - Runs as non-root user (`appuser`)
   - Minimal base image (Python 3.10.11-slim)
   - Health checks enabled

3. **Network Security:**
   - Only port 8501 exposed
   - Default bridge network isolation

## Troubleshooting

### Common Issues:

1. **Container fails to start:**
   ```bash
   docker logs finbro-gpt
   # Check for missing OPENAI_API_KEY
   ```

2. **Application not accessible:**
   - Verify port 8501 is not in use
   - Check firewall settings
   - Verify container is running: `docker ps`

3. **Memory issues:**
   - Increase memory limit: `--memory=4g`
   - Monitor usage: `docker stats finbro-gpt`

4. **API connection issues:**
   - Verify internet connectivity
   - Check OpenAI API key validity
   - Monitor API usage limits

### Health Check Failures:
```bash
# Check health status
docker inspect finbro-gpt --format='{{.State.Health.Log}}'

# Restart if unhealthy
docker restart finbro-gpt
```

## Scaling and Performance

### Horizontal Scaling:
```bash
# Run multiple instances
docker run -d --name finbro-gpt-1 -p 8501:8501 finbro-gpt
docker run -d --name finbro-gpt-2 -p 8502:8501 finbro-gpt
```

### Resource Monitoring:
```bash
# Monitor resource usage
docker stats finbro-gpt

# Set resource limits
docker run --memory=2g --cpus=1.0 finbro-gpt
```

## Kubernetes Deployment (Optional)

For Kubernetes deployment, create the following files:

### `finbro-gpt-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: finbro-gpt
spec:
  replicas: 2
  selector:
    matchLabels:
      app: finbro-gpt
  template:
    metadata:
      labels:
        app: finbro-gpt
    spec:
      containers:
      - name: finbro-gpt
        image: finbro-gpt:latest
        ports:
        - containerPort: 8501
        env:
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: finbro-secrets
              key: openai-api-key
        resources:
          limits:
            memory: "2Gi"
            cpu: "1"
          requests:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /_stcore/health
            port: 8501
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /_stcore/health
            port: 8501
          initialDelaySeconds: 5
          periodSeconds: 5
```

### `finbro-gpt-service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: finbro-gpt-service
spec:
  selector:
    app: finbro-gpt
  ports:
  - port: 80
    targetPort: 8501
  type: LoadBalancer
```