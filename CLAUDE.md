# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Finbro-GPT is a standalone AI-powered financial analysis tool specifically designed for Vietnamese stock market analysis. It's a Streamlit-based web application that allows users to chat with an AI assistant about financial data using natural language queries.

## Development Commands

### Setup and Installation
```bash
# Install dependencies using requirements.txt
pip install -r requirements.txt

# Or install as editable package using pyproject.toml
pip install -e .

# Copy environment template
cp .env.example .env
# Edit .env with your OpenAI API key
```

### Running the Application
```bash
# Run using Streamlit directly
streamlit run app.py

# Or use the configured script (after pip install -e .)
finbro-gpt
```

### Development Tools
```bash
# Linting with Ruff
ruff check .

# Formatting with Ruff
ruff format .

# Type checking (if needed)
mypy app.py  # Note: No type hints currently present

# Running tests
pytest  # No tests currently present
```

### Docker Deployment
```bash
# Using docker-compose (recommended)
docker-compose up --build

# Or build and run directly
docker build -t finbro-gpt .
docker run -d -p 8501:8501 -e OPENAI_API_KEY=your-key finbro-gpt

# Or use pre-built image from GitHub Container Registry
docker run -d -p 8501:8501 -e OPENAI_API_KEY=your-key ghcr.io/gahoccode/finbro-gpt:latest
```

### GitHub Actions
The repository includes automated workflows:
- **Docker Publishing**: Automatically builds and publishes Docker images to ghcr.io on push to main branch and tags
- **Multi-platform support**: Images built for linux/amd64 and linux/arm64
- **Automated tagging**: Latest, semantic versioning, and branch-based tags

## Architecture

### Core Components
- **Monolithic Architecture**: Single `app.py` file containing all functionality (768 lines)
- **Streamlit Session State**: Manages chat history, dataframes, and configuration persistence
- **PandasAI Agent**: Natural language processing for financial data analysis
- **Vnstock Integration**: Real-time Vietnamese stock market data from VCI/TCBS sources

### Key Dependencies
- `streamlit==1.47.0`: Web interface framework
- `pandasai==2.3.0`: AI-powered data analysis
- `vnstock==3.2.5`: Vietnamese stock market API
- `openai>=1.61.0`: LLM integration (gpt-4o-mini)
- `altair>=5.5.0`: Data visualization

### Data Flow
1. **Data Fetching**: Real-time stock data via Vnstock API (VCI/TCBS sources)
2. **Data Processing**: Transpose financial statements from long to wide format for AI analysis
3. **AI Processing**: PandasAI agent with OpenAI LLM processes natural language queries
4. **Visualization**: Automatic chart generation using matplotlib, saved to `exports/charts/`
5. **Session Management**: Chat history and dataframes cached in Streamlit session state

### Key Functions
- `process_agent_response()`: Core AI query processing with error handling
- `transpose_financial_dataframe()`: Converts vnstock data format for PandasAI compatibility
- `get_or_create_agent()`: Manages PandasAI agent lifecycle and caching
- `detect_latest_chart()`: Automatic chart detection for display

## Configuration

### Environment Variables
- `OPENAI_API_KEY`: Required for AI functionality (can be set via environment or UI)
- `OPENAI_MODEL`: Optional model selection (default: gpt-4o-mini)
- Python 3.10.11 is specifically required

### Project Configuration
- **pyproject.toml**: Contains project metadata, dependencies, and Ruff configuration
- **.streamlit/config.toml**: Custom finance-themed styling with professional colors (light theme)
- **Ruff**: Configured for linting and formatting (line length: 88, target: Python 3.10+)

### Styling Theme
Professional finance theme with:
- Primary colors: #56524D (brown), #204F80 (blue)
- Background: #E4E4E4 (light gray)
- Chart colors: Finance-appropriate categorical and sequential palettes

## Important Notes

- **No Authentication**: The app works standalone without requiring OAuth or user accounts
- **Internet Required**: Real-time data fetching from Vnstock API and OpenAI services
- **Chart Generation**: Automatic visualization with matplotlib, saved to `exports/charts/`
- **File Upload Support**: CSV/Excel files can be uploaded for additional analysis
- **Sample Questions**: Pre-defined financial analysis prompts available in sidebar
- **Docker Ready**: Multi-stage Dockerfile with health checks and security considerations

## Development Guidelines

- **Single File Architecture**: All code is contained in `app.py` for easy deployment
- **Error Handling**: Graceful handling of API failures and missing data
- **Professional Styling**: Finance-appropriate color scheme and layout
- **Responsive Design**: Works on desktop and mobile browsers
- **Real-time Data**: No local database, all data fetched live from APIs