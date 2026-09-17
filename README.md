# Doxary

Doxary is a mobile-first personal document and administrative assistant for people navigating German letters, notices, PDFs, and other administrative documents. Its core workflow is **Import -> Understand -> Identify actions -> Track deadlines/tasks -> Complete the case**.

This repository is in **Phase 2.6: Flutter integration with the local Doxary backend**. It retains the local-first Flutter foundation and now provides a typed, injectable client for the backend's asynchronous document-analysis API. Flutter still contains no provider SDK, provider credential, cloud account/sync, or deployment infrastructure.

Start with [PRODUCT.md](docs/PRODUCT.md), then [ARCHITECTURE.md](docs/ARCHITECTURE.md) and [DECISIONS.md](docs/DECISIONS.md). Future contributors must follow [AGENTS.md](AGENTS.md).

The product starts with German source material and Arabic explanations/UI support, while preserving language-independent domain logic for future target languages such as Tigrinya.

The permanent package/application identity is `doxary` / `de.habeero.doxary`. Run `flutter pub get`, `dart run build_runner build`, and `flutter run` to develop locally. For the Android emulator, the default endpoint is `http://10.0.2.2:5000/api/v1`; override it with `--dart-define=DOXARY_API_BASE_URL=...` for a physical device or a future HTTPS staging environment.

## Opt-in local integration check

Do not enable paid AI calls as part of normal Flutter tests. To manually verify the local path, start PostgreSQL, the backend web process, and its worker in `doxary-backend`; explicitly enable AI only if a real analysis is desired. Run Flutter with the emulator default or a LAN `DOXARY_API_BASE_URL`, submit a synthetic/non-sensitive imported PDF or ordered images through the document-analysis workflow, observe `accepted`, `processing`, and `succeeded`, then verify the structured local result and restart the app to confirm its persisted analysis remains available. Physical devices must reach a backend bound to the developer machine's LAN interface; no LAN address is committed to source.

The production import adapter uses the lightweight `file_picker` package because it supports Android/iOS PDF selection and multiple image selection while returning filesystem-backed references. It is not a scanner SDK. Supported image formats are JPEG and PNG; selected image order is retained as the logical Document's page order. System-picker cancellation is neutral, and backend validation remains authoritative.

Opening a document from the Documents tab uses `/documents/:clientDocumentId` and reads the local Document, original-file metadata, and latest persisted `DocumentAnalysis` from Drift. The detail view keeps the original separate from the analysis, which renders available structured sections and explicitly labels complete, partial, and unavailable outcomes; it never re-requests the backend just to display a local result.
