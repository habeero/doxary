# Security and privacy

Administrative documents can expose identity, address, health, immigration, employment, and financial information. Doxary minimizes collection, keeps data boundaries explicit, and treats document information as privacy-sensitive throughout its lifecycle.

## Repository-wide expectations

- Keep secrets out of Flutter and source control; use appropriate server-side secret management.
- Use transport and storage protections appropriate to the environment, and evaluate device protection, network protections, file validation, authorization, abuse controls, and least-privilege access before release.
- Redact logs, crash reports, analytics, and observability. Never include raw document text, names, addresses, account/insurance numbers, income, or image payloads.
- Make analytics privacy-safe and opt-in where required; measure product events rather than document contents.
- Provide transparent consent and limitations for AI processing and data handling.
- Support deletion and retention governance for local, temporary, and future synchronized data; do not present this design as legal-compliance certification.

## Threat model and review

Threats include lost devices, malicious files, unauthorized API use, accidental telemetry disclosure, prompt injection in document text, hallucinated advice, and cross-user data exposure. Mitigations include validation/isolation, scoped processing, schema/evidence validation, authorization boundaries, rate limits, redaction, and user-visible uncertainty.

GDPR legal roles, lawful basis, DPIA need, processor agreements, data residency, and retention durations require legal/product review. Detailed local-data, integration-boundary, and AI-provider rules are owned by [Application logic](app-logic/README.md), [App/backend integration](app-backend/README.md), and [AI](ai/README.md).
