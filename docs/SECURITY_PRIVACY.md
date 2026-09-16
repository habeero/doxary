# Security and privacy

Administrative documents can expose identity, address, health, immigration, employment, and financial information. Minimize collection: V1 keeps originals on-device, sends only the selected file for requested analysis, uses server temporary storage, returns structured results, and deletes temporary server artifacts on a documented bounded schedule. Assistant requests similarly send only the scoped analysis, evidence/text, and conversation turns required for one operation; that context is temporary and is not a durable server document. Permanent server originals require future explicit opt-in; analysis metadata/cloud sync are separate choices.

Transport requires TLS. Secrets live in server-side secret management, never Flutter or source control. Evaluate device encryption/secure storage, database encryption tradeoffs, lock-screen/redaction behavior, certificate/network protections, file MIME/content validation, size limits, malware handling, authorization, quotas, rate limiting, and abuse controls before implementation.

For local development only, Android's debug manifest permits cleartext HTTP so the emulator or a LAN test device can reach a developer-run backend. Release builds do not weaken cleartext/TLS policy; staging and production must use HTTPS. `DOXARY_API_BASE_URL` is a compile-time runtime setting, not a location for credentials.

File import uses the platform document provider via `file_picker` and retains the returned local reference; it does not request broad storage access or duplicate the selected bytes. PDF and JPEG/PNG validation is basic proactive UX only; the backend remains authoritative for signatures, limits, and security checks. Camera permission is not requested because direct camera capture is deferred.

Logs, crash reports, and analytics use redacted categories and correlation IDs only. Never include raw document text, names, addresses, account/insurance numbers, income, or image payloads. Privacy-safe analytics are opt-in where required and measure product events, not document contents. Access to operational data is least-privilege and auditable.

Deletion must remove local originals and derived content on user request; future server deletion includes temporary data, stored analysis, account data, backups/retention disclosures, and sync tombstones. Provide clear consent/transparency for AI processing, provider data handling, retention, and limitations. GDPR legal roles, lawful basis, DPIA need, processor agreements, data residency, and retention durations require legal/product review; this design is not a compliance certification.

Threats include lost devices, malicious files, unauthorized API use, accidental telemetry disclosure, prompt injection in document text, hallucinated advice, and cross-user data exposure. Mitigate through local safeguards, validation/isolation, scoped prompts, schema/evidence validation, authorization boundaries, rate limits, redaction, and user-visible uncertainty.
