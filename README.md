# Doxary

Doxary is a mobile-first personal document and administrative assistant for people navigating German letters, notices, PDFs, and other administrative documents. Its core workflow is **Import -> Understand -> Identify actions -> Track deadlines/tasks -> Complete the case**.

This repository is in **Phase 1: Flutter foundation**. It contains an Android-first, iOS-ready Flutter application with local-first repositories, Drift/SQLite schema v1, Riverpod, GoRouter, German/Arabic localization, and an explicit import/reminder capability boundary. It intentionally contains no Flask backend, AI provider integration, cloud accounts/sync, Docker configuration, or deployment infrastructure.

Start with [PRODUCT.md](docs/PRODUCT.md), then [ARCHITECTURE.md](docs/ARCHITECTURE.md) and [DECISIONS.md](docs/DECISIONS.md). Future contributors must follow [AGENTS.md](AGENTS.md).

The product starts with German source material and Arabic explanations/UI support, while preserving language-independent domain logic for future target languages such as Tigrinya.

The permanent package/application identity is `doxary` / `de.habeero.doxary`. Run `flutter pub get`, `dart run build_runner build`, and `flutter run` to develop locally.
