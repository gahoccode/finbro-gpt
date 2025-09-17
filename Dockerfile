# Multi-stage build for production optimization with multi-platform support
FROM --platform=linux/amd64 python:3.10.11-slim as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    VNSTOCK_CACHE_DIR=/tmp/vnstock

# Install system dependencies needed for building
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Production stage with multi-platform support
FROM --platform=linux/amd64 python:3.10.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH" \
    VNSTOCK_CACHE_DIR=/tmp/vnstock \
    HOME=/app

# Install only runtime system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security with proper home directory
RUN groupadd -r appuser && \
    useradd -r -g appuser -m -d /app appuser

# Copy virtual environment from builder stage
COPY --from=builder /opt/venv /opt/venv

# Create app directory and set permissions
RUN mkdir -p /app/exports/charts /tmp/vnstock && \
    chown -R appuser:appuser /app /tmp/vnstock

# Set working directory
WORKDIR /app

# Copy application files
COPY --chown=appuser:appuser app.py .
COPY --chown=appuser:appuser .streamlit/ .streamlit/
COPY --chown=appuser:appuser .env.example .env.example

# Create empty .env file for production
RUN touch .env && chown appuser:appuser .env

# Create vnstock cache directory with proper permissions
RUN mkdir -p /app/.vnstock && \
    chown -R appuser:appuser /app/.vnstock

# Switch to non-root user
USER appuser

# Expose Streamlit port
EXPOSE 8501

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

# Run the application
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true", "--server.enableCORS=false"]