# Application-logic changelog

## 2026-09-20

- Added normalized, analysis-owned local persistence for mapped Result facts, next actions, uncertainties, suggested tasks, and semantic metadata; analysis suggestions remain separate from user-owned operational records.
- Added forward-only local persistence for `DocumentAnalysis.action_required`; legacy analysis rows retain a null value rather than inferred action state.

## 2026-09-20

- Established result-state selection: complete action uncertainty remains complete, partial takes precedence over action state, and unavailable quality reasons distinguish corrective unreadable input from unsupported/corrupt input problems.

## 2026-09-19

- Consolidated the established local domain model, classification invariants, document lifecycle, and regression expectations into the application-logic domain.
- Recorded deferred deliberate Organization short-display-name modeling; no UI heuristic or aliasing is authorized.
- Recorded the implemented local-first document-analysis behavior: durable local identity, typed persisted analysis versions, non-promoting suggestions, and duplicate-safe reanalysis.
