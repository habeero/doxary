# AI changelog

## 2026-09-20

- Corrected `analysis_result.v1` documentation to match the implemented `uncertainties` and `quality_issues` contract; it does not currently expose `confidence`, `warnings`, or `quality_reasons`.

## 2026-09-19

- Consolidated the established provider abstraction, structured output schemas, document-first behavior, and AI validation requirements into the AI domain.
- Recorded the validated-output boundary, explicit quality/uncertainty outcomes, scoped assistant context, and replaceable provider/model policy.
- Documented the deferred analysis-language policy and the distinction between interface localization and persisted analysis-derived content.
