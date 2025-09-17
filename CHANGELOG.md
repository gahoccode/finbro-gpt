# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-01-17

### Added
- 🤖 AI-powered financial analysis using PandasAI and OpenAI
- 📊 Real-time Vietnamese stock data via Vnstock API (VCI/TCBS sources)
- 📈 Interactive chart generation and data visualization
- 🎯 Stock symbol selection and configuration interface
- 🔑 Direct OpenAI API key integration (environment or UI)
- 🎨 Professional finance-themed styling and responsive design
- 🐳 Docker support with multi-platform builds (linux/amd64, linux/arm64)
- 🚀 GitHub Actions workflow for automated Docker image publishing to ghcr.io
- 📁 File upload support for CSV/Excel analysis
- 💬 Interactive chat interface with financial AI assistant
- 🔄 Session state management for chat history and dataframes
- 📋 Pre-defined sample questions for common financial analysis
- 🗂️ Comprehensive .gitignore and .dockerignore configurations
- 📖 Cross-platform Docker run commands for Mac/Linux and Windows
- 💾 Volume mounting support for persistent chart storage
- 🛠️ Container management commands in documentation

### Changed
- Updated README.md with enhanced Docker installation instructions
- Improved project documentation with CLAUDE.md and DOCKER.md guides
- Streamlined ignore patterns to only include project-relevant files

### Fixed
- AttributeError when clicking "Show Table" button before loading data
- TypeError when clicking quick question buttons before analyzing stock data
- Null pointer exceptions in `get_or_create_agent()` function
- Runtime error from duplicate Streamlit bootstrap initialization
- Added proper null checks throughout the application

### Removed
- Unnecessary files from git tracking (build artifacts, cache files, package manager locks)
- Redundant patterns from .gitignore and .dockerignore
- Problematic main() function that caused Streamlit runtime conflicts

### Security
- Proper exclusion of environment files and secrets from Docker builds
- Security certificates and keys excluded from version control
- Non-root user implementation in Docker containers