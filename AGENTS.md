# Doxary agent guidance

## Before changing anything

1. Read this `AGENTS.md`.
2. Determine the documentation domain relevant to the requested task.
3. Read only that domain under `docs/`.
4. Do not read unrelated domains unless the task has a real cross-domain dependency.
5. Treat the relevant domain documentation as authoritative.
6. Do not invent product requirements when documentation is ambiguous.

## Documentation routing

- UI / UX -> `docs/ui-ux/`
- Application logic -> `docs/app-logic/`
- App / backend integration -> `docs/app-backend/`
- AI -> `docs/ai/`
- Monetization -> `docs/monetization/`

For cross-domain work, inspect only the additional domain required.

## Root-level cross-domain documentation

- Product definition -> `docs/PRODUCT.md`
- MVP scope -> `docs/MVP_SCOPE.md`
- Cross-domain architecture -> `docs/ARCHITECTURE.md`
- Decision history / ADRs -> `docs/DECISIONS.md`
- Roadmap / planning -> `docs/ROADMAP.md`
- Release governance -> `docs/RELEASE.md`
- Security / privacy governance -> `docs/SECURITY_PRIVACY.md`
- Repository-wide testing governance -> `docs/TESTING.md`

Read these root documents only when a task directly concerns their purpose or a real cross-domain dependency requires them. Do not read them by default for ordinary UI/UX, application-logic, app/backend, AI, or monetization work.

ADRs preserve historical rationale. Current domain documentation remains authoritative for current implementation behavior.

## Scope discipline

Stay within the requested scope.

Do not expand work into unrelated:
- features,
- refactors,
- architecture changes,
- documentation domains.

If another domain is genuinely required, identify that dependency before expanding the implementation unless the task explicitly authorizes it.

## Documentation ownership

Each durable rule, decision, contract, or behavior must have one authoritative documentation location.

Do not duplicate authoritative documentation across domains.

When durable behavior changes:
- update the affected domain documentation;
- update that domain's `CHANGELOG.md`.

Do not update the root `CHANGELOG.md` unless explicitly requested.

## Validation policy

Do not run slow or expensive Flutter commands unless explicitly requested.

Do not run by default:
- `flutter analyze`
- `flutter test`
- `flutter run`
- `flutter build`
- emulator/device/debug operations
- full generators

Allowed by default only when fast and bounded:
- inspect/edit files
- `dart format` on explicitly touched Dart files
- `git diff --check`
- lightweight targeted inspection

Report the exact heavier validation commands the user should run manually when needed.

### Command execution limits

Keep agent-side command execution fast and bounded.

If a command is expected to take noticeable time, require Flutter startup,
scan a large part of the repository, or may block unpredictably, do not run it.
Report the exact command for the user to run manually instead.

If any command:
- hangs;
- exceeds a short interactive wait;
- fails because of environment/tooling/permission issues;

stop after the first attempt.

Do not retry the same command or an equivalent heavier command unless the user
explicitly asks for a retry.

This applies even to commands otherwise allowed by default.

For `dart format`:
- run it only on explicitly touched Dart files;
- if it does not complete promptly, stop immediately;
- do not retry;
- report the exact formatting command for the user to run manually.

Prefer completing the code change and reporting pending manual validation over
spending time troubleshooting local tooling.

## General repository safety

- Never commit secrets.
- Do not modify generated files manually unless explicitly required.
- Preserve behavior outside the requested scope.
- Do not add dependencies without a clear reason.
- Do not claim commands were run if they were not run.

## Completion report

Report concisely:
- what changed,
- which domain was affected,
- important files changed,
- documentation updated,
- validation actually performed,
- manual validation still recommended.
