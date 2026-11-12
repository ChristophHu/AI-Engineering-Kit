---
name: init
description: Turn a raw app idea into an agreed product brief, design-system direction, and prioritized feature map through an adaptive one-question-at-a-time interview before coding.
---

# Init

## Goal

Help the user turn a raw idea into a clear product vision and a prioritized feature map before implementation code is written. Use a focused discovery interview to uncover decisions that would otherwise lead to the wrong product or features.

This skill is for new projects, early product concepts, or existing projects whose purpose and scope are still unclear. For a well-defined feature in an established project, use `$spec-driven-development` instead.

## Before starting

1. Read `AGENTS.md`, `.codex/PROJECT.md`, existing project documentation, and the relevant repository structure before asking questions.
2. If present, inspect `docs/PRD.md` and `features/INDEX.md`; distinguish an empty scaffold from an already completed product brief and feature map. Also inspect existing `docs/data-model.md`, `docs/app-shell.md`, and `docs/design-system.md` rather than creating parallel artifacts.
3. Detect the project's working language from its instructions and existing product documents. Conduct the interview and write artifacts in that language. When an English scaffold is being filled for a project using another language, translate headings and guiding prose while preserving filenames and HTML comments. Do not create or edit `CLAUDE.md` for a Codex project. If the working language is genuinely unclear, ask one question with a recommended language and record the choice in the project brief.
4. If `docs/PRD.md` or the project's canonical product brief is already substantively complete, do not repeat initialization or overwrite it. Tell the user this project is initialized and recommend `$spec-driven-development` for a feature or a targeted update to a specific artifact. Stop and ask which direction they want to take. End that handoff turn with exactly one question on the final line and wait. Continue only if the user explicitly asks for a targeted missing artifact or update.

The short description written by the installer in `.codex/PROJECT.md` is not by itself a completed product initialization.

## The Discovery Interview

Interview until there is a complete shared understanding of the product direction. Follow these rules:

### End every interview and review turn with exactly one question — critical

This is the most important interaction rule of this skill. During the interview and at every review checkpoint:

- Make the final line of the message exactly one clear question. Put all context, recommendations, and summaries before it. Never end on a statement or status note.
- Ask one question only. Do not bundle subquestions into the final line.
- After asking, stop and wait for the user's reply. Do not keep working, infer an answer, update artifacts, or move to another phase until the user responds.
- If a work chunk is complete and the next action is unclear, ask the single question that best determines what should happen next.

- Ask exactly one question per turn. Never bundle questions or present a questionnaire.
- Include a recommended answer with every question so the user can confirm or correct it. Make clear that it is a recommendation, not a presumed decision.
- Follow the conversation. Choose each next question based on the user's answer and open relevant branches; do not follow a fixed script mechanically.
- Explore before asking. Read existing project files, instructions, product notes, manifests, and relevant code to answer questions the repository can already resolve.
- Do not impose a fixed question count. Continue while an unresolved decision could materially change the product vision, scope, or feature priorities.
- Keep questions focused and avoid asking again for information already established. Mark facts, user decisions, and assumptions distinctly.
- If the user does not know an answer, offer a concrete recommended default, explain its practical impact briefly, and record it as an assumption until confirmed.
- If the user provides a full briefing, treat it as interview input: extract and retain decisions already provided, inspect the repository for more context, and do not ask the user to repeat resolved points. Ask only about material gaps, including the required backend/environment, privacy, and design-system decisions when they are still unresolved. If no material gaps remain, prepare the artifacts and move to the review checkpoint without filler questions.

Explore the areas that matter to this project, adapting the order and depth to the answers:

- problem, purpose, target users, and value
- target platform and devices (for Apple apps, supported platforms and minimum OS versions; for web apps, browsers and viewports)
- the primary user journey, initial experience, important states, and user actions
- product boundaries, explicit exclusions, and likely MVP scope
- existing alternatives or competitors and the product's intended difference
- candidate features, relative priority, dependencies, and sequencing
- relevant business model, integrations, data, privacy, accessibility, permissions, and quality goals
- success measures and relevant constraints such as timeline, budget, and team capacity
- important unknowns

Do not ask about technical implementation details until the product behavior and constraints are sufficiently clear. When a technical constraint materially affects feasibility or product direction, ask one focused question and record the answer or assumption without turning the interview into an architecture plan.

## Decisions required before the feature map

Resolve the following branches before prioritizing features. First inspect the project and use what is already decided; ask only for decisions that remain open. Ask one question per turn, include a recommended answer, and wait for the reply before proceeding.

### Backend and data environment

For a new app or an unresolved backend choice, ask whether it needs a hosted/shared backend, an existing backend, or can work entirely on-device/in the browser. Recommend based on the product: local-only storage for a genuinely single-user offline tool; the project's existing backend when one is established; Supabase, NestJS with PostgreSQL, or C# with Microsoft SQL Server when user accounts, shared data, or the project's architecture call for a server backend. The project description is authoritative for the selected backend. If it does not name one and the codebase does not establish it, ask the user directly to choose before finalizing the architecture or implementation plan. Do not infer a backend from the reference diagrams.

If Supabase is selected:

- Do not add “Supabase infrastructure setup” as a product feature. Project initialization, local services, client wiring, and environment configuration are setup work, not user-facing behavior. Record them as setup dependencies for `$verify-setup`; keep them out of the user-facing feature map.
- If accounts are required, include a real **User Accounts & Authentication** feature with user-facing signup/login behavior and its necessary user-data foundation. Record the profile data and per-user isolation pattern in `docs/data-model.md` when present, or in the technical handoff; plan profile provisioning using the project's established pattern. Features that rely on per-user data depend on this feature. Do not make authentication a prerequisite when the product does not need accounts.
- Hand off Supabase schema, Auth, RLS, Storage, and Edge Function planning to `$backend-dev-supabase`; the initializer records product behavior and feature dependencies but does not design detailed SQL or implement backend setup.
- Before finalizing the feature map, ask one question to choose the environment strategy: local development with Supabase CLI and a supported runtime; separate hosted development and production projects; a single hosted project; or Supabase branching/preview environments if currently available and suitable. Recommend local development when the user's machine and workflow support it; otherwise recommend separate dev/prod projects. Explain that a single hosted project makes test and live data the same. Do not quote plan requirements or prices without checking current official documentation.
- Record the chosen strategy plainly in the project brief/PRD Constraints, for example `Environment strategy: local`, `two-projects`, `single`, or `branching`, including what the choice means for test and production data.
- If a hosted project is planned, resolve its data region before feature-map approval. Ask one question if it is not already specified. Recommend an exact region based on the users and any contractual data-location requirements; Frankfurt (`eu-central-1`) is a suitable recommendation for a German/EU data-location preference. Do not claim GDPR requires that region or that region selection proves compliance. Record the user's actual choice. Treat changing the region as a consequential migration decision and verify current provider guidance before setup.

For these choices, consult the current [Supabase local development guide](https://supabase.com/docs/guides/local-development), [deployment and branching guide](https://supabase.com/docs/guides/deployment), and [available regions](https://supabase.com/docs/guides/platform/regions). Supabase documents that a region change requires creating a new project and migrating; verify the current [region-change procedure](https://supabase.com/kb/troubleshooting/change-project-region-eWJo5Z) when explaining this decision. Region selection controls data location and is not, on its own, a GDPR compliance determination.

If NestJS with PostgreSQL is selected:

- Do not add “NestJS/PostgreSQL infrastructure setup” as a user-facing product feature. Record API/database provisioning, local services, configuration, and migrations as setup dependencies for `$verify-setup` and `$backend-nestjs-postgres-development`.
- Hand off API modules, DTO validation, authentication/authorization, database schema/migrations, and backend verification to `$backend-nestjs-postgres-development`.
- Include Swagger/OpenAPI when API documentation is in scope. Swagger UI and its OpenAPI document endpoint must be protected and not publicly reachable; record the authorized access method and production behavior in the technical handoff.
- Record the selected local/development/staging/production database environment strategy in the project brief or technical handoff. Never assume a production target or expose database credentials.

If C# with Microsoft SQL Server is selected:

- Do not add “C# backend/SQL Server setup” as a user-facing product feature. Record the .NET API, SQL Server, local configuration, and migration workflow as setup dependencies for `$verify-setup` and `$backend-csharp-sqlserver-development`.
- Hand off API structure, SQL Server schema/data access, migrations, authentication/authorization, protected Swagger/OpenAPI, and backend verification to `$backend-csharp-sqlserver-development`.
- Record the target .NET version, SQL Server environment, and hosting model (for example Windows Server/IIS) in the technical handoff. Do not assume Windows authentication, Azure hosting, or production credentials.

### Local and offline data

When offline use, local copies, or local-first behavior is a product requirement, clarify the storage location and ownership instead of assuming that local storage syncs automatically:

- For native Apple apps, consider an app-internal SQLite store when the app needs durable device-local data or continued work without connectivity.
- For web apps, distinguish SQLite on the server behind an API from SQLite/WASM stored in the browser. Server storage can serve shared records through the API; browser storage is local to that browser origin/profile.
- Ask whether local data is a cache, an offline working copy, or the source of truth; whether edits sync to a server or other devices; and what users should experience during conflicts, sign-out, storage loss, or quota failure.
- Hand off SQLite schemas, migrations, persistence, and sync design to `$backend-sqlite-data-development`. Do not add bidirectional sync unless the product requires it and its data ownership and conflict behavior are agreed.

If the app is genuinely frontend-only/local-only, record `No backend — local-only storage` in the project constraints, do not add an infrastructure feature, and skip backend environment-strategy questions.

### Data-protection stance

If the product processes personal data, ask the user for a preferred level of implementation focus before building the feature map:

- **Lean:** a small MVP with low-risk, limited personal data.
- **Standard (recommended):** a public-facing product with accounts and ordinary personal data.
- **Strict:** sensitive or children's data, employee data, regulated/enterprise contexts, or a request for heightened safeguards.

Explain that this choice scopes project attention and documentation; it never reduces legal obligations. Record `Data protection stance: lean | standard | strict` and flag special-category or children's data early, including health, biometric, ethnic, religious, or sexual-orientation data when applicable. Use `$dsgvo` for relevant requirements. Do not make legal determinations or infer a lawful basis.

If no personal data is involved, record that assessment briefly and skip the stance question.

### Design system

Inspect existing design tokens, brand guidance, component libraries, screenshots, and UI references first. If a usable design system exists, follow it and do not ask the user to repeat it. Otherwise, ask whether the user has a design system, brand guide, or UI reference; the user can share a file/link, describe it, or say there is none. Recommend sharing any existing reference, even if incomplete. If none exists, ask one focused follow-up about the visual character, with a recommendation based on the product and users.

Resolve the design-system direction and review its proposed artifact before building the feature map. If an existing system is being reused, record its source and relevant conventions; if proposing one, present it at a review checkpoint, end with exactly one question, and wait for approval before continuing.

Create or update `docs/design-system.md` either way. Use concrete, implementable tokens rather than adjectives alone:

- primary, secondary, accent, destructive, background, and foreground colors for light and dark themes
- restrained brand-color variants for subtle backgrounds, hover, and active states rather than one flat color on large surfaces
- typography family, scale, and heading/body weights
- radius, spacing rhythm, and elevation/border conventions
- component conventions such as button variants/sizes, form-field sizing, and loading/empty states
- applicable hover, focus, pressed, and disabled states

Use concrete values in the target stack's token format when known. Unless an existing system or explicit product requirement says otherwise, define both light and dark tokens, avoid pure black/white for large surfaces, use a consistent radius/spacing system, and provide visible focus states for keyboard input. Check text contrast against the applicable accessibility standard; do not apply one contrast threshold to every text size or UI component.

## Completion criteria

The discovery is complete when the user and agent share a coherent account of:

- who the product serves, what problem it addresses, and its intended value
- target platforms and important constraints
- the main user journey and expected outcomes
- what belongs in the first useful release and what is explicitly deferred or excluded
- a prioritized feature map with enough context to explain the ordering and dependencies
- a backend and test/live environment direction, where relevant
- a concrete design-system proposal, or an existing system identified for reuse
- success signals and unresolved questions or assumptions with their impact

The PRD is a concise product-level decision document, not a transcript of discovery or a technical architecture document. Its purpose is to state what problem the product solves, for whom, what the first release should do, and how success can be recognized. Keep these four elements at its center:

- **Vision:** the product's purpose, the problem it addresses, and the value it intends to create.
- **Target users:** the primary audience and any distinct secondary audiences, with their relevant needs.
- **Core functions:** the small set of capabilities essential to deliver the vision. Give product requirements clear priorities and observable acceptance criteria when useful. Keep the broader prioritization rationale, dependencies, and roadmap grouping in the separate feature map.
- **Critical success factors:** the conditions that must hold for the product to succeed, including observable success measures where they can be defined. Distinguish measurable indicators from assumptions; do not present guesses as validated targets.

Add concise supporting sections when they materially clarify product decisions or help judge the first release: summary/status and product owner, problem details, target-user needs, alternatives and product differentiation, business model or monetization, in/out scope, key user journeys, user-visible data and integration needs, functional requirements with IDs/priorities/acceptance criteria, and **non-functional requirements** such as accessibility, usability, performance, reliability, security, privacy, and supported devices or browsers. Make non-functional requirements observable or measurable where practical, and include acceptance criteria when useful. Also include assumptions and open questions, risks, and release or approval criteria as relevant. Adapt the sections to the product; do not fill a template mechanically or invent detail. Omit irrelevant sections explicitly or leave them out. Keep platform and constraints brief. When personal data is involved, capture only the product-level needs and constraints in the PRD, then use `$dsgvo` for deeper privacy analysis and requirements; link or cross-reference its relevant findings from the PRD when useful. Describe required product outcomes for data and integrations, but put technical architecture, implementation choices, database schemas, and engineering plans in a technical Spec and implementation plan. Avoid duplicating long requirement details across the PRD and feature map: the PRD states the user-facing requirements, while the feature map organizes feature priority, rationale, and dependencies.

If a decision remains open but does not prevent a useful product direction, record it with its impact instead of extending the interview indefinitely. If a high-impact decision is unresolved, ask the next single question that best reduces that uncertainty.

## Artifacts

After the interview, prepare or update these Markdown artifacts in the project's working language. Settle and review the design system before drafting the final feature map:

1. Product vision/PRD — use an existing `docs/PRD.md` when it is part of the project scaffold; otherwise update `.codex/PROJECT.md`. Keep it concise and centered on **Vision**, **Target users**, **Core functions**, and **Critical success factors**. Add applicable product-level sections for the problem, alternatives/differentiation, business model, first-release scope, user journeys, user-visible data/integration needs, prioritized functional requirements with observable acceptance criteria, and non-functional requirements (for example accessibility, usability, performance, reliability, security, privacy, and supported devices or browsers). State quality outcomes in testable terms where practical. If personal data is involved, use `$dsgvo` for the deeper privacy analysis and link or cross-reference relevant findings; keep the PRD focused on product-level needs and constraints. Include assumptions/open questions, risks, and release criteria when relevant. Adapt depth to the project and omit irrelevant sections rather than inventing content. The PRD describes product behavior and success, not technical architecture; put broader feature prioritization and dependencies in the separate feature map, and technical decisions and schemas in the technical Spec and implementation plan.
2. `docs/design-system.md` — create or update a concrete design direction using the user's existing system or the proposal agreed during discovery. Present a new proposal for review before moving on to the feature map.
3. Feature map — use an existing `features/INDEX.md` when it is part of the project scaffold; otherwise update `.codex/FEATURE-MAP.md`. Group features by priority, normally **MVP**, **Next**, and **Later / Out of scope**. For each feature, state the user outcome, priority rationale, and material dependencies or unresolved decisions. Do not add setup infrastructure as a user-facing feature.

Explore existing files and conventions first. Preserve unrelated project content; if either target artifact already exists, read and update it without discarding established decisions. Do not overwrite user-authored material silently.

If the project scaffold includes `docs/data-model.md` or `docs/app-shell.md`, preserve the filenames and HTML comments. When filling an English scaffold for a project whose working language is different, translate its headings and guiding prose. Only write data-model or app-shell details that are supported by agreed requirements; do not invent schema or implementation decisions during product discovery.

Present the resulting product vision, approved design system, and feature map for the user's review. These artifacts describe product intent and priorities; they are not an implementation spec or technical plan.

At the final review checkpoint, summarize the product vision, design-system direction, and feature prioritization, then end with exactly one confirmation question, such as: “Stimmen Produktvision, Designrichtung und Feature-Priorisierung für dich?” Stop and wait. If the user requests changes, update the artifacts and present them for review again, ending with one question each time. Do not hand off to implementation planning until the user confirms the direction.

## Handoff

Do not write application implementation code, create project scaffolding, or run code generators as part of this initializer. After the user accepts the product direction, hand off to `$spec-driven-development` for a concrete feature or milestone Spec, then `$feature-planning` for implementation planning. Platform skills can be selected after the target platform and stack are known.
