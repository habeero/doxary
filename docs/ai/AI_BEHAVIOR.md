# AI behavior

## Analysis and explanation

AI analysis begins with an imported document. Vision-capable processing is the MVP strategy; on-device OCR is not required. Extracted facts remain separate from explanatory prose, and domain enums remain language-neutral.

Source language and target explanation language/style are independent inputs. The supported explanation languages are Arabic and German; `simple` style is German-only. Explanations are generated from validated facts and source evidence, are informational rather than legal advice, and prompt verification for consequential matters.

## Evidence, uncertainty, and classification

The model must not fabricate sender, dates, legal obligations, citations, reply facts, or unavailable values. Uncertainty is explicit wherever evidence is missing. Evidence is bounded to the analyzed source/context and supports the associated claim where available.

Organization and Case classification are AI suggestions with provenance, never confirmed data. The model must not fabricate “Unknown” Organization or Case entities. Extracted actions, deadlines, appointments, amounts, required documents, and suggested tasks use the typed output schema and remain distinguishable from certainty or user confirmation.

## Partial and unavailable outcomes

When facts cannot be established, AI behavior returns validated `partial` or `unavailable` outcomes with relevant quality reasons and uncertainty rather than inventing a complete answer. Provider error, timeout, or fallback behavior is bounded and governed by explicit routing policy; provider internals are not exposed to users or Flutter.
