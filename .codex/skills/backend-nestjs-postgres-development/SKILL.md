---
name: backend-nestjs-postgres-development
description: Plan, implement, or review a NestJS API with PostgreSQL, including authentication, authorization, schema migrations, and protected Swagger/OpenAPI documentation.
---

# NestJS and PostgreSQL Backend Development

Use this skill when the project description or established codebase selects a NestJS backend with PostgreSQL. It is especially suited to web applications that need a separately operated API. Follow the approved Spec and Plan for substantial changes; use `$spec-driven-development` and `$feature-planning` when requirements or scope need clarification first. Do not substitute this stack for Supabase or another established backend without an explicit project decision.

## Discover the existing project

1. Read project instructions, `.codex/PROJECT.md`, relevant Specs/Plans, data-model documentation, and deployment documentation.
2. Inspect the NestJS, Node.js, TypeScript, package-manager, PostgreSQL, ORM/query-builder, migration, validation, authentication, and test versions and conventions already in use. Preserve established choices unless the approved plan calls for a change.
3. Identify local, development, staging/preview, and production environments and how each is selected. Determine database targets before invoking commands; never expose credentials.
4. Inspect module boundaries, controllers, providers, DTOs, guards, interceptors, exception handling, database access, migrations, seeds, CI, and deployment configuration relevant to the work.
5. Consult current official NestJS, PostgreSQL, and selected ORM/tool documentation when behavior depends on version or configuration.

## API and module design

- Organize modules around product responsibilities and keep controllers focused on HTTP concerns. Put business rules in providers/services and database access behind clear persistence boundaries consistent with the codebase.
- Define request and response DTOs; validate and transform untrusted input at the API boundary. Avoid using database entities as public response contracts.
- Use consistent HTTP semantics, pagination, error shapes, and API versioning where the project requires them. Do not expose stack traces, SQL details, or internal identifiers without a product need.
- Keep secrets and privileged operations on the server. Treat browser and native-client code as public and enforce authorization in the API, regardless of client-side route guards or UI state.

## PostgreSQL schema and migrations

- Model only data required by the Spec. Make ownership, relationships, constraints, indexes, deletion behavior, and tenant boundaries explicit; update `docs/data-model.md` when present.
- Use the repository's existing migration tool and workflow. Make schema changes reproducible; review generated migrations and account for backfills, lock duration, and compatibility with deployed application versions.
- Keep development, preview, and production databases distinct according to the agreed environment strategy. Seed only synthetic or otherwise authorized non-production data.
- Use parameterized queries or the selected ORM's safe query APIs. Apply transactions and database constraints where needed for correctness; do not rely only on application checks for invariants the database can enforce.
- Keep database URLs and passwords in trusted environment configuration or an approved secret store. Never put them in browser bundles, logs, reports, or version control.

## Authentication and authorization

- Implement only authentication methods and account lifecycle behavior required by the Spec and existing project. State whether identity is managed by this API or by a separately selected identity provider; do not assume a provider.
- Authenticate each protected request and enforce resource-level authorization server-side. Check object ownership and tenant membership on every relevant operation; do not treat a valid JWT or role name alone as permission for arbitrary records.
- Use established password hashing, session/token validation, rotation, expiration, and revocation patterns appropriate to the selected auth design. Never log credentials, tokens, authorization headers, or sensitive personal data.
- Cover relevant denied-access cases as well as successful operations. Keep authorization decisions independent of Swagger UI access controls.

## Protected Swagger / OpenAPI

- Provide OpenAPI documentation and Swagger UI when API documentation is in scope. Describe DTO schemas, authentication schemes, relevant success/error responses, and versioning accurately; keep the generated document aligned with the actual API.
- **Swagger UI and any served OpenAPI JSON/document endpoint must not be publicly reachable.** Protect them with an explicit server-side authentication/authorization mechanism appropriate to the project (for example, an authenticated operator/admin guard or deployment-level access control). Do not rely on an obscure URL, CORS, frontend routing, or an undocumented query token.
- Default documentation endpoints to disabled or access-restricted in production unless the approved deployment design explicitly provides protected access. Production routes must remain inaccessible to anonymous and ordinary unauthorized users; test both allowed and denied access.
- Avoid embedding secrets, real credentials, internal hostnames, or sensitive example data in the OpenAPI document. Use non-sensitive examples and declare bearer/API authentication schemes without including actual tokens.
- Document how authorized developers/operators reach the UI. If access control is provided by an ingress or identity-aware proxy, record that dependency and verify the application cannot be reached around it in the intended deployment topology.

## Verification

Choose checks that match the change and existing repository setup. Relevant checks may include:

- apply migrations to a clean local/test database and confirm the resulting schema; verify migration ordering and rollback strategy where supported
- run unit/integration tests for changed services, controllers, validation, transactions, and error mapping
- exercise authenticated and unauthenticated requests, ownership/tenant boundaries, and expected denied operations
- verify Swagger UI and OpenAPI document access for authorized operators and confirm anonymous/unauthorized requests are denied, including in production-equivalent configuration
- validate the generated OpenAPI document against current DTOs and authentication behavior
- validate the backend build and frontend integration against the API contract
- confirm environment configuration uses the intended database without revealing its URL or credentials

Do not run destructive database resets, production migrations, production data changes, or secret changes without explicit authorization for that environment and action. Prefer local/test verification first. Use `$verify-setup` for runtime, CLI, configuration, and environment readiness, `$dsgvo` when personal data is processed, and `$deploy` for release/deployment work. Report executed checks, open risks, and checks not run.

## Official documentation

Use documentation matching the installed versions. Start with:

- [NestJS OpenAPI](https://docs.nestjs.com/openapi/introduction)
- [NestJS authentication](https://docs.nestjs.com/security/authentication)
- [NestJS authorization](https://docs.nestjs.com/security/authorization)
- [NestJS validation](https://docs.nestjs.com/techniques/validation)
- [PostgreSQL documentation](https://www.postgresql.org/docs/)
