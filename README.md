# Doxary

Doxary is a mobile-first personal document and administrative assistant for people navigating German letters, notices, PDFs, and other administrative documents. Its core workflow is **Import → Understand → Identify actions → Track deadlines/tasks → Complete the case**.

The product starts with German source material and supports Arabic and German explanations while keeping its domain logic language-independent for future languages.

## Repository structure

The documentation is organized by working domain:

- `docs/ui-ux/` — interface, navigation, interaction, and visual behavior.
- `docs/app-logic/` — local domain data and application behavior.
- `docs/app-backend/` — Flutter/backend API contract and integration behavior.
- `docs/ai/` — provider architecture, structured outputs, and AI behavior.
- `docs/monetization/` — entitlement and commercial-access decisions.

Cross-domain product, architecture, ADR, roadmap, security/privacy, release, and testing-governance documents remain directly under `docs/`.

## Working with this repository

Coding agents follow [AGENTS.md](AGENTS.md). It determines which documentation is relevant to a task; documentation should not be loaded wholesale by default.

## Application identity

- Dart package: `doxary`
- Android/iOS identity: `de.habeero.doxary`

## Product status

The document-analysis foundation, local document organization, and Flutter/backend integration foundation exist. Current work focuses on product-ready UI/UX and remaining MVP work before beta hardening and release preparation. See [the roadmap](docs/ROADMAP.md) for detailed status.

## Development

This repository is the Flutter client. The backend lives in the sibling `doxary-backend` repository. Environment, setup, and integration details live in their owning documentation domains.
