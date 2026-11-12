---
name: backend-sqlite-data-development
description: Plan, implement, or review SQLite persistence for native Apple apps, server-side APIs, and browser-based WebAssembly/OPFS storage, including offline synchronization and conflict handling.
---

# SQLite Data Development

Use this skill when a project stores data in SQLite on iOS, iPadOS, macOS, a server, or in a browser. First identify which runtime owns each database and whether it is a source of truth, a cache, a local working copy, or a server database. SQLite in one runtime is not automatically shared or synchronized with SQLite in another runtime.

Follow the approved Spec and Plan for substantial changes. Use `$spec-driven-development` and `$feature-planning` when behavior or architecture is unclear. Preserve the selected backend: local SQLite can complement Supabase, NestJS/PostgreSQL, or C#/SQL Server as an offline store or cache; do not silently replace the project's server backend with SQLite.

## Discover the data ownership model

Before designing a schema or sync implementation, establish:

- target runtime and platforms, supported OS/browser versions, and the SQLite implementation/library already used
- data owner and scope: device-local, browser-profile-local, user-owned, tenant-shared, or globally shared
- source of truth for each record: local SQLite, a remote API/database, or an explicitly defined conflict-resolution model
- whether offline use is read-only, permits local edits, or supports the full workflow
- which data must synchronize, in which direction, and whether sync is automatic, manual, or both
- expected data volume, write frequency, simultaneous writers, retention, deletion, export, backup, and recovery needs
- behavior at first launch, upgrade, sign-out/account switch, network loss/recovery, and database corruption or quota exhaustion

Do not infer that “offline-capable” means bidirectional sync or that a local cache is authoritative. If data ownership, multi-device behavior, or conflict policy would change user-visible outcomes and is unspecified, mark it as an open decision and ask before implementing that behavior.

## Native Apple apps (iOS, iPadOS, macOS)

- Follow the existing persistence architecture and minimum OS targets. Inspect whether the project uses SQLite directly, SwiftData, Core Data, GRDB, SQLite.swift, or another established layer; do not add or replace a library without a requirement and plan.
- Keep database access behind the application's persistence boundary. Define schema ownership, versioned migrations, constraints, indexes, transactions, and recovery behavior. Do not perform blocking database work on the UI thread.
- Keep the database in the app's appropriate container and account for iOS/iPadOS background suspension, macOS lifecycle, app upgrades, backups, and platform file-protection requirements. Store sensitive data only with an explicitly reviewed protection policy.
- If remote synchronization is required, implement it through the selected authenticated API/backend. Define incremental checkpoints, retry/backoff, idempotency, duplicate handling, deletion propagation/tombstones, and user-visible sync status.
- Define conflict behavior per data type: server wins, client wins, field merge, append-only/event merge, or user resolution. Do not pick a general “last write wins” policy without checking whether timestamps, clock skew, and concurrent edits make it safe.
- Ensure account changes cannot reveal a prior user's local records. Specify whether sign-out retains, locks, clears, or queues local data, and handle pending writes consistently.

## Web applications: server-side SQLite

- SQLite may be used behind a server-side API, with the database file and application code on the same host/storage system. Clients must call the API; never expose the database file or accept arbitrary client SQL.
- Confirm the hosting platform provides durable file storage, correct file locking, backup/restore, and an operational process for schema migrations. Ephemeral container filesystems must not be treated as durable storage.
- Assess write contention, request concurrency, data size, deployment topology, and scaling needs. SQLite permits many readers but only one writer at a time per database file. A write-light workload with a single application server may fit; high write concurrency, multiple app instances sharing the file, direct network-filesystem access, or growth beyond the planned operating envelope points toward a client/server database such as PostgreSQL.
- Keep API authentication and per-user/tenant authorization at the server boundary. A shared SQLite file is not an authorization model.
- Use explicit transactions, short write transactions, bounded busy handling, and safe parameterized queries or the selected ORM. Never copy a live database file as a backup without using a consistent SQLite backup mechanism.
- If server-side SQLite is selected as the primary backend, record the decision and operational limits in the project description/architecture. Do not assume it is compatible with multi-instance or serverless deployment.

## Web applications: browser SQLite with WebAssembly

- Treat browser SQLite as storage local to a browser origin/profile, not as a shared multi-user database and not as an automatic backup. The application must separately design any sync, export, recovery, or backup behavior.
- Inspect the current SQLite WASM implementation and its official persistence documentation. OPFS-backed configurations have worker-context requirements; keep database I/O out of the UI thread and verify support in the project's actual browser matrix.
- Select and document the persistence/VFS mode based on browser support, multi-tab behavior, locking, required headers/isolation, and product needs. Do not assume all OPFS modes have identical concurrency or deployment requirements.
- Define behavior when OPFS, workers, persistent storage, or browser quota is unavailable. Provide a supported fallback or an explicit user-facing limitation; do not silently report a successful save when storage failed.
- Test reload, tab duplication/concurrency, browser restart, storage denial/quota, sign-out/account switching, and schema upgrade. Consider origin changes and browser-managed deletion as data-loss scenarios.
- For user-specific records, partition data by authenticated account locally and prevent cross-account leakage. Do not put secrets, credentials, or authorization decisions in a client database.

## Synchronization design

When local and remote stores both exist, document the synchronization contract before implementation:

- stable record IDs and ownership/tenant binding
- local pending-operation/outbox representation and durable transaction boundaries
- API contract, authentication, pagination, delta cursor/checkpoint, and idempotency key behavior
- ordering, retry/backoff, partial failure recovery, duplicate delivery, and cancellation behavior
- conflict resolution by entity/field and how rejected changes are surfaced
- deletion propagation, retention, data export, and account deletion behavior
- sync status and user-visible guarantees, including what remains available offline

Make local writes and their pending-sync records atomic where the design uses an outbox. Make retries safe. A successful local write must not be presented as remotely synchronized until the server confirms it. Avoid destructive full refreshes that can erase unuploaded local edits.

## Security and privacy

- Treat every local database as potentially inspectable by someone with access to the device/browser profile. Apply platform storage protections appropriate to data sensitivity; do not claim encryption solely because data is in SQLite or OPFS.
- Enforce server-side authentication and authorization independently of the local database and UI. Validate ownership again when syncing or accepting mutations.
- Avoid secrets and unnecessary personal data in records, debug logs, fixtures, and exported database files. Define retention and deletion across local copies, sync queues, server data, backups, and exports.
- Use `$dsgvo` when personal data is processed and the selected backend skill for the remote API/database.

## Verification

Select checks matching the platform and the approved Plan. Relevant checks may include:

- create/open/migrate the database from both a clean install and each supported previous schema version
- test constraints, transaction rollback, concurrent reads/writes, busy/locked behavior, and recovery from an interrupted operation
- verify local-only behavior with the network disabled, then reconnect and validate idempotent synchronization and the agreed conflict policy
- verify account/tenant isolation, sign-out behavior, deletion propagation, and unauthorized server requests
- test browser worker/OPFS availability, target browsers, multiple tabs, quota/storage errors, and persistence across reload/restart
- verify server durability, backup/restore procedure, and migrations against a local/test copy; do not point setup checks at production
- confirm backups and exports are consistent and contain no unintended secrets

Do not run destructive resets, production migrations, or hosted data changes without explicit authorization for that environment and action. Use `$verify-setup` for runtime/environment readiness, `$swiftui-app-development`, `$nextjs-app-development`, or `$angular-app-development` for platform conventions, and the selected backend skill for remote integration. Report executed checks, unrun checks, open decisions, and known storage limits.

## Official documentation

Use documentation matching the selected SQLite/WASM library and platform versions. Start with:

- [Appropriate Uses For SQLite](https://www.sqlite.org/whentouse.html)
- [SQLite Over a Network, Caveats and Considerations](https://www.sqlite.org/useovernet.html)
- [SQLite Wasm Persistent Storage Options](https://sqlite.org/wasm/doc/trunk/persistence.md)
- [SQLite Online Backup API](https://www.sqlite.org/backup.html)
