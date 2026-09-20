# AI analysis-quality roadmap

## Status

This is a **deferred** major workstream. Current Flutter application completion, remaining application behavior, navigation, and interaction work must not be blocked by AI-reading optimization.

`analysis_result.v1` remains the working contract until this phase deliberately changes it through a documented contract decision. During ordinary application work, Codex must not casually alter AI semantics, prompts, or schema to compensate for presentation or application behavior.

## Future scope

The later phase will evaluate and improve document understanding quality, including:

- document classification, sender/Organization identification, document-type identification, and a concise document naming/display-title strategy;
- action-required determination, uncertainty handling, and the distinction between facts, suggestions, and uncertainty;
- deadline/date extraction, amount/payment interpretation, required-document extraction, appointment extraction, and suggested tasks/next actions;
- useful summary quality and reduction of irrelevant or intermediate extracted facts;
- source/evidence grounding and mixed German/Arabic output;
- evaluation of real analysis results against representative German documents; and
- a repeatable, privacy-safe evaluation and regression set.

This scope is intentionally a future measured-improvement phase, not permission to change the current behavior piecemeal. Its output, validation criteria, and any contract revision must be explicitly designed before implementation.
