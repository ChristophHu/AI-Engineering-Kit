---
name: app-dev-angular
description: Plan, implement, or review features in an existing Angular application while preserving its Angular version and project conventions.
---

# Angular App Development

Use this skill for work in an Angular project. Start with the approved Spec and Plan when available; for substantial work, use `$spec-driven-development` and `$feature-planning` first.

## Discover the project before changing it

1. Read project instructions, `.codex/PROJECT.md`, and `docs/design-system.md` if present.
2. Inspect `package.json`, the lockfile, Angular version, `angular.json`, build and test scripts, route configuration, and relevant source and test files.
3. Identify the project's component model, dependency-injection patterns, routing, forms, HTTP/data access, state approach, supported browsers, and deployment setup.
4. Follow existing conventions. Do not convert components, replace state management, or add a library without a requirement and an explicit plan.

## Plan and implement

For the feature at hand, consider the relevant areas:

- standalone components and their templates, following the project's current style
- dependency injection and service boundaries
- routing, guards, forms, validation, and navigation
- RxJS or Signals according to existing code and the needs of the feature
- HTTP calls, loading and error states, authentication, and authorization
- if SQLite is required, distinguish server-side SQLite behind an API from browser-local SQLite/WASM; plan OPFS/worker/browser constraints and any sync contract with `$backend-dev-sqlite-data`
- accessibility in templates, including semantic elements, labels, focus, and keyboard behavior
- build configuration, environments, and browser support

Keep components and services consistent with existing responsibilities. Update the Spec or Plan if implementation reveals a necessary behavior or architecture change.

## Hand off UI verification

For changed UI, use `$frontend-design-accessibility` for a focused quality review and `$verify-ui` to select and report the relevant checks. Base build and test commands on the repository scripts; verify central flows in the supported browsers and viewports when available.
