---
name: deploy
description: Prepare or execute a release and deployment for an existing SwiftUI, Next.js, or Angular project by following its configured targets, provider, and CI/CD conventions.
---

# Deploy

Use this skill when preparing a release, changing deployment configuration, or deploying an application. Follow the approved Spec and Plan for substantial changes; use `$feature-planning` and `$implementation-review` when the release work needs a tracked plan and verification.

## Discover the current release setup

1. Read project instructions, `.codex/PROJECT.md`, and relevant Specs and Plans.
2. Inspect the repository, package/build configuration, CI workflows, release scripts, environment-variable documentation, and recent release conventions.
3. Identify platform, application version, target environment (local, test, staging, production), hosting or store provider, deployment mode, required secrets, database changes, and rollback method.
4. Preserve the current provider and release workflow. Do not infer Hostinger, App Store Connect, or any other provider from the kit's reference diagrams. If target environment, provider, or release channel is unclear, record the decision as open before changing deployment behavior.
5. For current provider-specific requirements, consult that provider's official documentation and the current project configuration. Record relevant sources and verification date when a changing requirement affects the release.

## Prepare the release

Plan and verify only the steps relevant to the project:

- run the repository's configured build and release checks
- confirm the target environment and required runtime/platform versions
- identify required environment variables and secrets without revealing their values
- keep secrets in the configured CI or hosting secret store; never commit them or embed server secrets in client bundles
- check domain, TLS, routing, health checks, static assets, and server/runtime configuration as applicable
- identify database migrations, compatibility requirements, backup needs, and rollback constraints
- define deployment order, smoke checks, success criteria, and a practical rollback or recovery path
- confirm versioning, release notes, signing, and store metadata when applicable

Do not invent deployment infrastructure or add a new provider when an existing process can meet the Spec.

## Platform profiles

### SwiftUI and Apple release

- Detect supported Apple platforms, deployment targets, schemes, configurations, bundle identifiers, signing setup, and existing archive/export process.
- Preserve signing identities, provisioning profiles, entitlements, and identifiers. Do not create, replace, revoke, or expose credentials as an incidental release step.
- Plan the configured build/archive and any existing TestFlight or App Store Connect handoff.
- Verify the submitted build and release metadata against the project's release criteria. Store submission, phased release, or public publication is a distinct external action.

### Next.js deployment

- Detect Next.js version, App or Pages Router, Node/runtime requirements, rendering mode, build/start scripts, and provider configuration.
- Verify server/client boundaries, production environment variables, health behavior, routing, and any cache/revalidation behavior affected by release.
- Confirm whether the target expects a Node server, serverless output, or static export; do not switch deployment mode without an approved plan.

### Angular deployment

- Detect Angular version, production configuration in `angular.json`, output mode, SSR setup if present, and hosting configuration.
- Verify build output, base path, client-side route fallback, cache behavior, and runtime configuration for the selected host.
- Do not assume Angular is static-only or add SSR without an explicit requirement and an implementation plan.

## Deploy and verify

Before deployment, confirm that the required checks pass or that exceptions are documented. Execute deployment commands only for the environment and scope authorized by the user. Production deployment, store submission, or public release requires explicit authorization when it has not already been given.

After an authorized deployment:

1. Verify the deployed version and target environment.
2. Run the planned health and smoke checks, including central user flows where available.
3. Check relevant logs and service health without exposing personal data or secrets.
4. Compare results to release criteria. If checks fail, follow the planned rollback/recovery path when authorized; otherwise stop and report the failure and required action.
5. Report what was built, deployed or submitted, where it went, which checks ran, their results, and any open risks or follow-up work.

Use `$ui-verification` for user-facing flows when appropriate and `$dsgvo` when the release changes personal-data processing or its operational handling. Never claim a release or deployment succeeded unless the resulting environment or store state was verified.
