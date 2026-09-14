# Design system principles

Use a calm, trustworthy, mobile-first system independent of the temporary codename. Typography must support German and Arabic well, use scalable text, adequate line height, and RTL-aware alignment/order/mirroring. All UI strings use Flutter localization; domain values are localized at presentation boundaries.

Use a consistent spacing scale, touch targets suitable for mobile, semantic—not brand-dependent—colors for primary action, information, success, warning, error, and neutral states. Never rely on color alone; pair status with labels/icons. Meet platform accessibility contrast, screen-reader labels, focus order, dynamic text, and reduced-motion needs.

Components include cards for document/action summary, status chips, date/deadline rows, task rows, evidence/uncertainty disclosure, import controls, confirmation dialogs, and inline correction controls. Confidence is phrased plainly (for example, “Please verify”) rather than as a misleading precise score. Loading uses skeleton/progress states; empty states explain a useful next action; errors preserve local work and offer safe retry.
