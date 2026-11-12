---
name: nextjs-app-development
description: Plan, implement, or review features in an existing Next.js application while preserving its version, router, runtime, and project conventions.
---

# Next.js App Development

Use this skill for work in a Next.js project. Start with the approved Spec and Plan when available; for substantial work, use `$spec-driven-development` and `$feature-planning` first.

## Discover the project before changing it

1. Read project instructions, `.codex/PROJECT.md`, and `docs/design-system.md` if present.
2. Inspect `package.json`, the lockfile, Next.js version, scripts, configuration, route tree, and relevant components and tests.
3. Identify whether the project uses App Router, Pages Router, or a deliberate mix; determine its runtime, rendering and data-fetching patterns, authentication, and deployment constraints.
4. Follow existing conventions. Do not migrate routers, change rendering strategy, or add a state/data library without a requirement and an explicit plan.

## Plan and implement

For the feature at hand, consider the relevant areas:

- Server and Client Component boundaries and where code executes
- rendering strategy, routing, layouts, metadata, and navigation
- data fetching, mutations, caching, and invalidation
- loading, error, empty, and not-found states
- authentication and authorization across browser, server, API, and backend boundaries
- runtime compatibility and treatment of secrets and server-only dependencies
- responsive behavior and accessibility of the affected routes and components

Keep privileged access and secrets server-side. Preserve the project's current router, rendering, and data-flow patterns unless the Spec requires a change. Update the Spec or Plan if implementation reveals a necessary behavior or architecture change.

## Hand off UI verification

For changed UI, use `$frontend-design-accessibility` for a focused quality review and `$ui-verification` to select and report the relevant checks. Base build and test commands on the repository scripts; verify central flows in the supported browsers and viewports when available.
