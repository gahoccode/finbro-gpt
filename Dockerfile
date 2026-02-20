FROM python:3.10.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    VNSTOCK_CACHE_DIR=/tmp/vnstock \
    HOME=/app

# Runtime deps: curl for healthcheck, gcc for wordcloud wheel build on arm64
RUN apt-get update && apt-get install -y curl gcc && rm -rf /var/lib/apt/lists/*

# Python dependencies (all have pre-built wheels — no compilation needed)
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Non-root user
RUN groupadd -r appuser && useradd -r -g appuser -m -d /app appuser

# App directories
RUN mkdir -p /app/exports/charts /tmp/vnstock /app/.vnstock && \
    chown -R appuser:appuser /app /tmp/vnstock

WORKDIR /app

# App files
COPY --chown=appuser:appuser app.py .
COPY --chown=appuser:appuser .streamlit/ .streamlit/
COPY --chown=appuser:appuser .env.example .env.example
RUN touch .env && chown appuser:appuser .env

USER appuser

EXPOSE 8501

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true", "--server.enableCORS=false"]
