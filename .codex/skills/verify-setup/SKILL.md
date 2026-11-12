---
name: verify-setup
description: Verify an existing app's local development prerequisites, selected backend tooling, configuration, and separation between development and hosted environments without exposing secrets.
---

# Verify Setup

Use this skill to determine whether a project is ready for local development or a planned environment workflow. It supports projects using Supabase, NestJS with PostgreSQL, or C# with Microsoft SQL Server alongside SwiftUI, Next.js, or Angular. Verification is read-only by default; setup changes belong to a separately requested repair or setup task.

## Discover the expected setup

1. Read project instructions, `.codex/PROJECT.md`, the relevant PRD/Spec, and the selected environment strategy. Identify whether the project uses Supabase, NestJS with PostgreSQL, C# with Microsoft SQL Server, another backend, or no backend. If the project description and codebase do not establish the backend, mark **Needs decision** and ask for the backend choice before backend-specific setup checks.
2. Inspect existing setup files before checking the machine: as applicable, `supabase/config.toml`, NestJS manifests/configuration, `.sln`/`.csproj`/`global.json`, ORM or database migration files, seeds, `.env.example`, `.gitignore`, lockfiles, runtime/version files, app configuration, CI workflows, and setup documentation.
3. Detect the app platform and its intended runtime from the repository. Follow the project's pinned versions, package manager, scripts, Xcode scheme, and configuration. Do not replace them with global defaults.
4. Report missing or conflicting information as **Needs decision**; do not infer a production project, environment, region, or runtime from an example architecture.

## Verify local prerequisites

Check only what applies to the project:

- required app runtime and version (for example, Node.js/package manager or Xcode/Swift toolchain)
- required package manager and whether the lockfile matches the project configuration
- Supabase CLI availability and version, using the project-pinned CLI when it has one
- `supabase/config.toml` presence and basic validity when the repository uses the Supabase CLI
- local runtime support and availability: the default Supabase local stack needs a Docker-compatible runtime; use another runtime only if the installed CLI and host support it and the project has chosen it
- local Supabase service state, migrations/schema, seeds, and relevant local tests when they are part of the setup
- app configuration for connecting to the intended local or development backend
- for NestJS/PostgreSQL: Node.js and package-manager versions, project scripts, selected ORM/driver CLI, local PostgreSQL/runtime availability, migration status, and app-to-API/database endpoint configuration
- for C#/SQL Server: pinned .NET SDK/runtime and target framework, solution/project restore/build configuration, EF Core/provider tooling if used, intended local/test SQL Server availability and migration status, and API/database endpoint configuration
- when SQLite is selected: verify the configured library/runtime and schema migration files, and confirm the intended local/server/browser storage location is available and persistent for the target environment

Do not install tools, download dependencies, initialize a new Supabase project, edit configuration, or start services in verify-only mode. If a check requires a stack to be started, report that prerequisite and ask before changing machine or project state. A running local stack is for development only and must not be exposed as a production service.

## Check configuration and credentials safely

- Inspect example/configuration files and required variable **names**, not secret values.
- Never print, quote, copy into reports, or commit values from `.env*`, shell environments, Supabase secrets, access tokens, database URLs/passwords, JWTs, publishable keys, or secret/service-role keys.
- Check that secret-bearing files are ignored by Git and that a safe `.env.example` documents required names with placeholders only.
- Check that browser and native-client configuration contains only values intended to be public. Service-role/secret keys and database passwords must remain in trusted server or function environments.
- Confirm the app points to the intended local or development endpoint without exposing credentials. Compare environment identity using redacted identifiers or boolean equality checks.
- Avoid commands whose normal output includes credentials. Supabase CLI status/start output can include local JWT and API-key values (publishable/secret keys or legacy anon/service-role keys, depending on CLI version); suppress or redact those values before they reach the terminal transcript or report. Report only whether the stack is running and non-sensitive endpoint information.
- For NestJS/PostgreSQL, do not dump process environments or connection strings. Report database reachability and environment identity only in redacted/non-sensitive form.
- For C#/SQL Server, do not dump environment configuration, connection strings, passwords, or tokens. Report SQL Server reachability and environment identity only in redacted/non-sensitive form.
- Do not dump all environment variables, `.env` files, full config files with embedded secrets, or complete process environments to diagnose one missing setting.

## Verify environment separation

Apply the project's declared strategy:

- **Local:** confirm local runtime/configuration and that development uses local credentials and endpoints. Do not link to or mutate a hosted project as part of local verification.
- **Separate dev and production projects:** confirm the configured project identities are distinct without displaying credentials. Check that local/dev configuration cannot silently target production.
- **Single hosted project:** report clearly that test and live data share one project. Do not silently reclassify this as a setup failure if it was an explicit decision.
- **Branching/preview:** confirm the intended base project and branch configuration using current provider docs. Check current availability and billing implications rather than assuming plan or price.
- **NestJS/PostgreSQL:** confirm local and hosted API/database targets follow the declared strategy, and that development cannot silently target production. Never connect to or mutate a hosted database as part of verification.
- **C#/SQL Server:** confirm the declared .NET API and SQL Server targets are aligned, local/test settings cannot silently target production, and the Windows Server/IIS runtime is documented for deployment. Never connect to or mutate a hosted database as part of setup verification.
- **SQLite:** distinguish app-container storage, durable server file storage, and browser-origin storage. For browser OPFS, check the declared browser/worker requirements; for server SQLite, check that the hosting filesystem is durable. Do not claim backup, cross-device sync, or data recovery based only on file presence.

When the strategy is missing or production may be confused with development, mark the setup **Needs decision** and stop before any remote operation.

## Safety boundaries

- Do not create, link, migrate, reset, seed, or modify a hosted project during verification.
- Do not run remote-target commands or destructive reset commands. Confirm command target and environment before any later authorized mutation.
- Do not rotate or create credentials as a setup fix unless explicitly requested.
- Do not assume that a successful CLI check means database policies, application authorization, or GDPR compliance are correct. Use `$supabase-backend-development`, `$nestjs-postgres-backend-development`, or `$csharp-sqlserver-backend-development` according to the selected backend for backend security/schema checks, and `$dsgvo` for personal-data requirements.
- If verification uncovers a fix, describe the exact gap and proposed change first. Apply changes only when the user requested setup/repair, then verify the resulting state.

## Report

Summarize results in a compact checklist with one of these statuses:

- **Ready:** verified and usable for the intended local/development workflow
- **Not ready:** a concrete prerequisite or configuration is missing or failing
- **Needs decision:** the environment, target, or expected behavior is unclear
- **Not checked:** the check could not safely or practically be run

Include the command or observation, relevant version/target, and next action for every non-ready item. Keep credentials and sensitive environment values out of the report. Distinguish verified facts from assumptions, and do not claim a full setup is ready based on a partial check.

## Official documentation

Use current documentation that matches the installed CLI and runtime. Start with:

- [Supabase Local Development and CLI](https://supabase.com/docs/guides/local-development)
- [Supabase local development workflow and project files](https://supabase.com/docs/guides/local-development/cli-workflows)
- [Supabase CLI configuration and secrets](https://supabase.com/docs/guides/local-development/managing-config)
- [Running commands against local and hosted projects](https://supabase.com/docs/guides/local-development/local-and-hosted-projects)
- [Supabase CLI status command](https://supabase.com/docs/reference/cli/supabase-status)
- [Supabase API key types](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys)
