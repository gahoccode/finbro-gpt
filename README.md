# Finbro-GPT

[![Docker Build](https://github.com/gahoccode/finbro-gpt/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/gahoccode/finbro-gpt/actions/workflows/docker-publish.yml)
[![Docker Image](https://ghcr-badge.deta.dev/gahoccode/finbro-gpt/latest_tag?trim=major&label=latest)](https://github.com/gahoccode/finbro-gpt/pkgs/container/finbro-gpt)

A standalone AI-powered financial analysis tool for Vietnamese stock market analysis.

## Features

- 🤖 AI-powered financial analysis using PandasAI
- 📊 Real-time Vietnamese stock data via Vnstock API
- 📈 Chart generation and data visualization
- 🎯 Stock symbol selection and configuration
- 🔑 Direct OpenAI API key integration
- 🎨 Professional finance theme styling
- 🐳 Docker support with multi-platform builds
- 🚀 Automated CI/CD with GitHub Actions

## Requirements

- Python 3.10.11
- OpenAI API key
- Vnstock API key (optional, for premium data access — get one at https://vnstocks.com)

## Installation

### Method 1: Docker (Recommended)

#### Step 1: Pull the image

```bash
docker pull ghcr.io/gahoccode/finbro-gpt:latest
```

#### Step 2: Run the container

**Mac/Linux:**

```bash
docker run -d \
  --name finbro-gpt \
  -p 8501:8501 \
  -e OPENAI_API_KEY=your-openai-api-key \
  -e VNSTOCK_API_KEY=your-vnstock-api-key \
  -v $(pwd)/exports:/app/exports \
  -v $(pwd)/vnstock_cache:/app/.vnstock \
  ghcr.io/gahoccode/finbro-gpt:latest
```

**Windows (Command Prompt):**

```cmd

docker run -d ^
  --name finbro-gpt ^
  -p 8501:8501 ^
  -e OPENAI_API_KEY=your-openai-api-key ^
  -e VNSTOCK_API_KEY=your-vnstock-api-key ^
  -v %cd%\exports:/app/exports ^
  -v %cd%\vnstock_cache:/app/.vnstock ^
  ghcr.io/gahoccode/finbro-gpt:latest
```

**Windows (PowerShell):**

```powershell
docker run -d `
  --name finbro-gpt `
  -p 8501:8501 `
  -e OPENAI_API_KEY=your-openai-api-key `
  -e VNSTOCK_API_KEY=your-vnstock-api-key `
  -v ${PWD}/exports:/app/exports `
  -v ${PWD}/vnstock_cache:/app/.vnstock `
  ghcr.io/gahoccode/finbro-gpt:latest
```

#### Container Management

```bash
# View logs
docker logs finbro-gpt

# Stop container
docker stop finbro-gpt

# Start container
docker start finbro-gpt

# Remove container
docker rm finbro-gpt
```

### Method 2: Docker Compose

1. Clone the repository:

   ```bash
   git clone https://github.com/gahoccode/finbro-gpt.git
   cd finbro-gpt
   ```

2. Set up environment:

   ```bash
   cp .env.example .env
   # Edit .env with your OPENAI_API_KEY and (optionally) VNSTOCK_API_KEY
   ```

3. Run with docker-compose:
   ```bash
   docker-compose up --build
   ```

### Method 3: Local Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/gahoccode/finbro-gpt.git
   cd finbro-gpt
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   # or using pyproject.toml
   pip install -e .
   ```

## Usage

### For Docker Users

After running the Docker container, open your browser and navigate to `http://localhost:8501`

### For Local Installation

1. Set your OpenAI API key:

   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   ```

   Or enter it directly in the app interface

2. Run the application:

   ```bash
   streamlit run app.py
   # or using the configured script (after pip install -e .)
   finbro-gpt
   ```

3. Open your browser and navigate to `http://localhost:8501`

## Configuration

- **Data Sources**: VCI (default) or TCBS for stock data
- **Period**: Annual or quarterly financial data
- **Chart Export**: Charts saved to `exports/charts/` directory

## File Structure

```
finbro-gpt/
├── app.py                    # Main application
├── pyproject.toml            # Project configuration
├── requirements.txt          # Dependencies
├── Dockerfile               # Docker configuration
├── docker-compose.yml       # Docker Compose setup
├── .env.example             # Environment template
├── .github/
│   └── workflows/
│       └── docker-publish.yml # CI/CD workflow
├── .streamlit/
│   └── config.toml          # Theme configuration
├── exports/charts/          # Generated charts
├── CLAUDE.md               # Development guide
├── DOCKER.md               # Docker deployment guide
└── README.md               # This file
```

## Dependencies

- `streamlit>=1.47.0` - Web framework
- `pandas==1.5.3` - Data processing
- `pandasai==2.3.0` - AI analysis
- `vnstock>=3.4.0` - Vietnamese stock data
- `openai>=1.61.0` - LLM integration
- `altair>=5.5.0` - Visualizations

## Deployment

### Pre-built Images

Pre-built Docker images are automatically published to GitHub Container Registry:

- `ghcr.io/gahoccode/finbro-gpt:latest` - Latest stable version
- `ghcr.io/gahoccode/finbro-gpt:v1.0.0` - Specific version tags

### Supported Architectures

- linux/amd64 (Intel/AMD)
- linux/arm64 (Apple Silicon, ARM servers)

### Environment Variables

- `OPENAI_API_KEY` - Required for AI functionality
- `VNSTOCK_API_KEY` - Optional, for premium Vnstock data access
- `OPENAI_MODEL` - Optional model selection (default: gpt-4o-mini)

## Development

See [CLAUDE.md](CLAUDE.md) for detailed development instructions and [DOCKER.md](DOCKER.md) for Docker deployment options.

## Notes

- Requires internet connection for Vnstock API and OpenAI services
- All financial data is fetched in real-time, no local database
- Charts are automatically generated and displayed in the chat interface
- Multi-platform Docker support for various architectures
