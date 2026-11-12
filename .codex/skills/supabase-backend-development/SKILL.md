---
name: supabase-backend-development
description: Plan, implement, or review Supabase database, authentication, authorization, storage, and Edge Function changes using the project's existing schema and deployment workflow.
---

# Supabase Backend Development

Use this skill when a project uses Supabase for backend behavior. It supports SwiftUI, Next.js, and Angular clients. Follow the approved Spec and Plan for substantial changes; use `$spec-driven-development` and `$feature-planning` when requirements or scope need to be clarified first.

## Discover the existing project

1. Read project instructions, `.codex/PROJECT.md`, relevant Specs/Plans, and `docs/data-model.md` if present.
2. Inspect the Supabase CLI version, `supabase/config.toml`, migration history, schema files, seeds, SQL tests, generated types, client SDKs, and deployment workflow.
3. Determine whether the project uses imperative migrations, declarative schemas, or another established database workflow. Preserve it; do not mix schema-management approaches without an explicit plan.
4. Identify local, development, staging/preview, and production projects. Determine which database and credentials commands will target before invoking them. Never print, commit, or expose secret values.
5. Consult current official Supabase documentation when behavior depends on CLI/SDK version, Postgres version, security features, or provider configuration.

Use `$verify-setup` when local runtime, CLI, configuration, credentials presence, or environment separation needs a readiness check.

## Database schema and migrations

- Model only data required by the Spec. Keep ownership, relationships, constraints, indexes, and deletion behavior explicit in the schema and `docs/data-model.md` when that project document exists.
- Make schema and policy changes reproducible through the repository's established migration or declarative workflow. Review generated SQL rather than accepting it blindly.
- Keep migrations compatible with the release sequence where possible: account for old and new application versions during rollout, backfills, locks, and data retention.
- Seed only synthetic or otherwise authorized non-production data. Do not copy production personal data into local or preview environments unless the project has an approved, protected process for it.
- Re-generate database types using the project's configured command when schema changes require it; review the resulting diff.

## Security and Row Level Security

- Treat database authorization as a security boundary, independent of client UI, route guards, or application checks.
- For tables exposed through Supabase APIs, inspect grants as well as RLS. Enable RLS and define least-privilege grants and policies for the operations and roles the product actually needs.
- Check both allowed and denied access: anonymous versus authenticated users, different user IDs, and tenant boundaries where applicable. Test `SELECT`, `INSERT`, `UPDATE`, and `DELETE` only where those operations are intended.
- Avoid permissive policies such as unconditional access unless public access is an explicit product requirement. Review views, functions, RPCs, and `SECURITY DEFINER` code for privilege or RLS bypasses.
- A publishable key (or legacy anon key) is not a substitute for authorization. Secret (or legacy service-role) keys bypass normal RLS protections; keep them in trusted server or function environments only, never in browser or native client code.

## Authentication and user data

- Implement only the authentication methods and account lifecycle required by the Spec and existing project.
- Keep user-facing profile/application data in project-owned tables with explicit foreign keys, grants, and RLS. Do not expose Supabase's internal `auth` schema through application APIs.
- When a signup trigger or other automatic provisioning is used, keep it minimal and test its failure behavior because a failed trigger can block signup. Follow the project's established profile-provisioning approach rather than introducing a trigger by default.
- Cover relevant lifecycle cases such as email verification, session refresh, sign-out, account deletion, and orphaned data when they are in scope.

## Storage and Edge Functions

- For Storage, define bucket visibility and per-operation policies for upload, read, update/overwrite, and delete as required. Restrict access by user, tenant, and object path where applicable; do not make a bucket public merely to simplify delivery.
- Validate file types, sizes, ownership, and processing requirements at the appropriate trust boundary. Use signed access when the files should not be public.
- Use Edge Functions or another established server-side boundary when the feature needs secrets, privileged operations, webhooks, or server-only integration logic. Verify identity and authorization in the function itself.
- Keep local function secrets out of Git and configure hosted secrets through the project's approved secret store. Never echo secret values into terminal output or reports.

## Client and framework boundaries

- Keep platform SDK usage aligned with the existing SwiftUI, Next.js, or Angular patterns and SDK versions.
- In Next.js, respect Server/Client Component and runtime boundaries; privileged operations and service keys stay server-side.
- In Angular and SwiftUI clients, treat bundled code and client keys as public. Enforce sensitive access with RLS and trusted server-side code.
- Avoid duplicating business authorization rules only in the client. The database policies or trusted backend must enforce access.

## Verification and changes to remote projects

Choose checks that match the change and existing test setup. Relevant checks may include:

- apply/rebuild migrations against the local Supabase project and confirm the schema from a clean state
- test RLS and grants with allowed and denied identities, using existing SQL tests or the project's configured test command
- exercise signup/profile provisioning, session behavior, Storage access, and Edge Function authorization when affected
- validate generated types and the client build/tests that consume them
- inspect the migration target and compare environments before any hosted change

Remote schema changes, production data changes, secret changes, and destructive reset commands can have external or irreversible effects. Run them only when the user explicitly authorized that environment and action. Prefer local verification first; do not infer authorization from a request to implement code.

Use `$dsgvo` when personal data is processed and `$deploy` when Supabase changes are part of a release. Report executed checks, open risks, and checks not run.

## Official documentation

Use the documentation matching the project's current CLI, SDK, and Postgres versions. Useful entry points include:

- [Local development and CLI](https://supabase.com/docs/guides/local-development)
- [Database migrations and CLI workflow](https://supabase.com/docs/guides/local-development/cli-workflows)
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Managing user data](https://supabase.com/docs/guides/auth/managing-user-data)
- [Storage access control](https://supabase.com/docs/guides/storage/security/access-control)
- [Edge Function secrets](https://supabase.com/docs/guides/functions/secrets)
