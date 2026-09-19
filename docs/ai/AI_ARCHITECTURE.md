# AI architecture

## Provider boundary

Flutter invokes backend product operations only; it never calls an AI provider directly. The backend owns the `AIProvider` port with `analyze_document`, `explain_document`, `answer_question`, `draft_reply`, and `extract_structured_data`. Provider adapters, `ModelRouter`, `PromptRegistry`, and `StructuredOutputValidator` remain server-side.

Provider/model names are configuration, never domain or client-contract values. The current provider/model configuration is replaceable when measured quality, latency, reliability, privacy, cost, battery, or operational evidence justifies a documented decision. Provider-specific code remains behind backend abstractions.

## Processing and validation pipeline

1. Validate the selected analysis material or scoped assistant context, assign a correlation value, and create temporary processing state when asynchronous work is needed.
2. Extract text/layout as appropriate, then classify/extract using the configured cost-conscious model route.
3. Validate the versioned structured output before it reaches client-facing code; retry boundedly on transport or validation failure.
4. Escalate or fall back only under explicit route policy. When facts cannot be established, produce normalized partial or unavailable outcomes.
5. Generate the requested explanation from validated data and source evidence, then delete temporary material according to retention policy.

Low-cost routes may classify/extract; stronger routes may improve explanation or difficult reasoning. Provider failures and raw provider output are converted into validated internal/public outcomes and never become Flutter contracts.

## Prompting, telemetry, and provider data

Prompts are immutable, versioned records with a purpose, input contract, output-schema version, safety instructions, and evaluation fixtures. Each request records provider/model configuration identifier, token/cost metrics, latency, schema/prompt version, outcome, and a redacted error category — never raw document content.

Provider data-processing terms, retention, regional handling, and user consent require evaluation before provider selection. This architecture does not itself establish GDPR compliance. No provider-retention setting such as `store=False` is currently documented as an established rule.

## Temporary AI context

Assistant work uses a minimum operation-scoped context of validated structured analysis plus only needed source evidence/text and conversation turns. Any retained follow-up context is bounded, expiring, deletable, and limited to structured analysis, concise summary, evidence references, version, timestamps, and deletion state. It never stores original files or becomes a permanent Document resource.
