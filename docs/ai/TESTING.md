# AI testing

Validate every structured schema, required/optional/unknown handling, enum values, evidence requirements, multilingual output, and no-invention behavior. Use redacted or synthetic German administrative fixtures and structured expected assertions; never use raw production documents.

## Required coverage

- Schema validation for complete, partial, and unavailable outcomes; malformed provider output; quality reasons; nested values; evidence; and schema-version compatibility.
- Extraction behavior for sender, dates, actions, deadlines, appointments, amounts, required documents, classification suggestions, uncertainties, and absent facts without fabrication.
- Explanation behavior for Arabic and German outputs, German-only `simple` style, language/style separation, source-grounded answers, and transparent consequential-matter caveats.
- Provider behavior for routing, bounded retries, timeouts, fallback, normalized provider errors, and model/provider swaps that preserve the validated public schema.
- Assistant outputs that remain within supplied context and do not invent facts, identity, events, or documents.

Prompt regression suites use immutable prompt/version fixtures and expected structured assertions. Provider/model replacement requires evidence that quality, latency, reliability, privacy, and cost remain acceptable.
