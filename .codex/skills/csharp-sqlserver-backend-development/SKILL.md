---
name: csharp-sqlserver-backend-development
description: Plan, implement, or review a C# ASP.NET Core Web API with Microsoft SQL Server, Entity Framework Core or the project's established data layer, and protected Swagger/OpenAPI documentation.
---

# C# and Microsoft SQL Server Backend Development

Use this skill when the project description or established codebase selects a C# backend with Microsoft SQL Server. For web APIs, use the project's established ASP.NET Core version and application model (controllers or Minimal APIs); do not assume a new .NET version, ORM, identity provider, or hosting provider. Follow the approved Spec and Plan for substantial changes; use `$spec-driven-development` and `$feature-planning` when requirements or scope need clarification first.

## Discover the existing project

1. Read project instructions, `.codex/PROJECT.md`, relevant Specs/Plans, data-model documentation, and deployment documentation.
2. Inspect `.sln`/`.csproj`, `global.json`, target frameworks, SDK/runtime, package sources, API style, dependency-injection conventions, SQL Server version/edition, data-access layer, EF Core/provider versions if used, migrations, authentication, tests, and CI. Preserve established choices unless the approved plan calls for a change.
3. Identify whether hosting is Windows Server/IIS, another Windows Server process model, Azure App Service, or another explicit target. Determine local, development, staging, and production SQL/API targets before commands; never expose connection strings or credentials.
4. Map the relevant API layers, DTOs, validation, middleware, authorization policies, database contexts/repositories, migrations, Swagger/OpenAPI setup, health checks, and deployment configuration.
5. Consult current Microsoft documentation matching the project's .NET, ASP.NET Core, EF Core, SQL Server, and hosting versions when behavior is version-dependent.

## API structure and contracts

- Preserve the project's API style (controllers or Minimal APIs), dependency injection, routing, versioning, and error conventions. Keep endpoints focused on HTTP concerns and business logic in appropriate application services.
- Validate untrusted input at the boundary. Use request/response contracts rather than exposing persistence entities as the public API. Return consistent HTTP status codes and problem details without leaking SQL, stack traces, or internal data.
- Use asynchronous I/O and cancellation tokens for request-scoped database and network operations. Respect scoped lifetimes and avoid retaining request services in long-lived objects.
- Keep authentication and authorization server-side. Check resource ownership and tenant boundaries for each relevant operation; client-side guards are not a security boundary.
- Do not assume Windows Integrated Authentication is appropriate merely because the API runs on Windows Server. Select authentication based on the approved identity and deployment design.

## Microsoft SQL Server and data access

- Use Entity Framework Core with the Microsoft SQL Server provider when that is the project's established or approved data layer. Otherwise preserve the chosen approach, such as Dapper or parameterized `Microsoft.Data.SqlClient` access; do not introduce an ORM by default.
- Model only data required by the Spec. Define relationships, keys, constraints, indexes, concurrency behavior, tenant ownership, and deletion rules explicitly. Update `docs/data-model.md` when present.
- Make schema changes reproducible through the project's existing migration workflow. Review generated migrations and SQL, plan compatibility/backfills/locks, and coordinate deployment order with application versions.
- For production, prefer reviewed deployment scripts or migration bundles where the team's approval process requires it. Do not silently apply migrations at application startup or run `EnsureCreated` against an existing managed database.
- Use transactions for multi-step invariants, parameterized queries, and bounded retry behavior appropriate to SQL Server/Azure SQL. Do not retry non-idempotent operations without a safe idempotency design.
- Store connection strings and credentials in the approved server-side secret/configuration mechanism. Do not place them in source control, client bundles, logs, reports, or Swagger examples. Determine whether the target uses Windows authentication, managed identity, or SQL authentication rather than assuming one.

## Swagger / OpenAPI protection

- Provide OpenAPI documentation and Swagger UI as required by the project. Match the implementation to the target framework: ASP.NET Core has built-in OpenAPI support in newer versions, while Swagger UI may use Swashbuckle or NSwag; older projects may already use Swashbuckle/NSwag end to end. Do not upgrade packages or framework versions solely to change the documentation setup.
- Document DTO schemas, authentication schemes, relevant responses/errors, and API versioning accurately. Keep generated documentation aligned with the actual endpoints and avoid secrets, internal credentials, or sensitive example values.
- **Swagger UI and every served OpenAPI JSON/document endpoint must be protected and unavailable to anonymous or unauthorized users.** Apply explicit ASP.NET Core authorization or an approved access-control layer at the server/hosting boundary; protect both UI assets and document endpoints. An obscure URL, CORS, or an authentication declaration inside the OpenAPI schema does not protect the documentation route.
- Verify the protection through the actual Windows Server/IIS or reverse-proxy topology so the application cannot be reached around an outer access-control rule. Choose and document who may access the documentation and how they authenticate.
- Keep documentation enabled only in the environments where intended. If it is available in production, require an authorized operator role or equivalent protected access and verify denied as well as allowed requests.

## Windows Server hosting and operations

- Follow the explicitly selected hosting model. For IIS hosting, verify the matching .NET Hosting Bundle/runtime, application pool configuration, process identity, file permissions, HTTPS bindings, reverse-proxy/forwarded-header behavior, and deployment output. For another model, inspect its service manager, runtime, logs, startup, and recovery conventions.
- Run the API with only the filesystem and SQL permissions it needs. Keep database files/backups and application logs outside public/static directories; restrict access to secrets and deployment artifacts.
- Define health/readiness behavior without exposing connection strings or detailed infrastructure information. Verify TLS, routing, logs, startup/restart behavior, and production configuration.
- Confirm SQL Server backup, restore, monitoring, and retention responsibilities for the chosen hosting arrangement. Do not assume the Windows host itself supplies a verified backup process.

## Verification

Choose checks matching the change and existing repository setup. Relevant checks may include:

- run the repository's pinned `dotnet` build and targeted unit/integration tests
- apply/review migrations against a local or test SQL Server and confirm schema compatibility from clean and supported prior versions
- exercise valid/invalid input, authentication, authorization, tenant isolation, validation errors, and database failure behavior
- verify Swagger UI and OpenAPI document endpoints reject anonymous and unauthorized requests and allow only the intended operator identity
- validate generated OpenAPI output and frontend/client compatibility against the API contract
- verify the publish output and the documented deployment target; on Windows Server, check IIS/runtime configuration and app-pool access without revealing secrets
- confirm local/dev/test/prod endpoint separation using redacted identifiers or boolean comparisons

Do not run destructive resets, production migrations, production data changes, or secret changes without explicit authorization for that environment and action. Prefer local/test verification first. Use `$verify-setup` for SDK/database/configuration readiness, `$dsgvo` when personal data is processed, and `$deploy` for release or server deployment work. Report executed checks, open risks, and checks not run.

## Official Microsoft documentation

Use the documentation matching the project's target versions. Start with:

- [Create web APIs with ASP.NET Core](https://learn.microsoft.com/aspnet/core/web-api)
- [ASP.NET Core web API documentation with Swagger / OpenAPI](https://learn.microsoft.com/aspnet/core/tutorials/web-api-help-pages-using-swagger)
- [Microsoft SQL Server EF Core database provider](https://learn.microsoft.com/ef/core/providers/sql-server/)
- [EF Core migrations overview](https://learn.microsoft.com/ef/core/managing-schemas/migrations/)
- [Host ASP.NET Core on Windows with IIS](https://learn.microsoft.com/aspnet/core/host-and-deploy/iis/)
