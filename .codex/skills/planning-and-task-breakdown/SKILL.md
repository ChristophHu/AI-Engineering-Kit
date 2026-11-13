---
name: planning-and-task-breakdown
description: Breaks work into ordered tasks. Use when you have a spec or clear requirements and need to break work into implementable tasks. Use when a task feels too large to start, when you need to estimate scope, or when parallel work is possible.
---

# Planning and Task Breakdown

Bei der Planung einer abgestimmten Spec ist `$feature-planning` der Einstieg. Nutze diesen Skill bei Bedarf für die detaillierte Aufgabenzerlegung desselben maßgeblichen Plans, gemäß `.codex/rules/WORKFLOW.md`. Bewahre vorhandene Projektkonventionen und erstelle keine parallelen Planungs- oder Statuslisten.

## Overview

Decompose work into small, verifiable tasks with explicit acceptance criteria. Good task breakdown is the difference between an agent that completes work reliably and one that produces a tangled mess. Every task should be small enough to implement, test, and verify in a single focused session.

## When to Use

- You have a spec and need to break it into implementable units
- A task feels too large or vague to start
- Work needs to be parallelized across multiple agents or sessions
- You need to communicate scope to a human
- The implementation order isn't obvious

**When NOT to use:** Single-file changes with obvious scope, or when the spec already contains well-defined tasks.

## The Planning Process

### Step 1: Enter Plan Mode

Before writing any code, operate in read-only mode:

- Read the spec and relevant codebase sections
- Identify existing patterns and conventions
- Map dependencies between components
- Note risks and unknowns

**Do NOT write code during planning.** Update the authoritative plan at the project's established planning location, or use `.codex/rules/templates/PLAN.md` when no project structure exists. Record tasks in that plan or reference the existing task system as described below; do not maintain duplicate status lists.

### Step 2: Identify the Dependency Graph

Map what depends on what:

```
Database schema
    │
    ├── API models/types
    │       │
    │       ├── API endpoints
    │       │       │
    │       │       └── Frontend API client
    │       │               │
    │       │               └── UI components
    │       │
    │       └── Validation logic
    │
    └── Seed data / migrations
```

Implementation order follows the dependency graph bottom-up: build foundations first.

### Step 3: Slice Vertically

Instead of building all the database, then all the API, then all the UI — build one complete feature path at a time:

**Bad (horizontal slicing):**
```
Task 1: Build entire database schema
Task 2: Build all API endpoints
Task 3: Build all UI components
Task 4: Connect everything
```

**Good (vertical slicing):**
```
Task 1: User can create an account (schema + API + UI for registration)
Task 2: User can log in (auth schema + API + UI for login)
Task 3: User can create a task (task schema + API + UI for creation)
Task 4: User can view task list (query + API + UI for list view)
```

Each vertical slice delivers working, testable functionality.

### Step 4: Write Tasks

Each task follows this structure, whether it lands in the markdown task list or as an item in an external tracker (see Output Files):

```markdown
## Task [N]: [Short descriptive title]

**Description:** One paragraph explaining what this task accomplishes.

**Acceptance criteria:**
- [ ] [Specific, testable condition]
- [ ] [Specific, testable condition]

**Verification:**
- [ ] Tests pass: [the repository's focused-test command]
- [ ] Build succeeds: [the repository's build command]
- [ ] Manual check: [description of what to verify]

**Dependencies:** [Task numbers this depends on, or "None"]

**Files likely touched:**
- `src/path/to/file.ts`
- `tests/path/to/test.ts`

**Estimated scope:** [Small: 1-2 files | Medium: 3-5 files | Large: 5+ files]
```

### Step 5: Order and Checkpoint

Arrange tasks so that:

1. Dependencies are satisfied (build foundation first)
2. Each task leaves the system in a working state
3. Verification checkpoints match the risks, dependencies and user request
4. High-risk tasks are early (fail fast)

Add checkpoints where the work warrants them; use the project's applicable checks and request human review only when required or agreed:

```markdown
## Checkpoint: After Tasks 1-3
- [ ] All tests pass
- [ ] Application builds without errors
- [ ] Core user flow works end-to-end
- [ ] Review with human when required or agreed
```

## Task Sizing Guidelines

| Size | Files | Scope | Example |
|------|-------|-------|---------|
| **XS** | 1 | Single function or config change | Add a validation rule |
| **S** | 1-2 | One component or endpoint | Add a new API endpoint |
| **M** | 3-5 | One feature slice | User registration flow |
| **L** | 5-8 | Multi-component feature | Search with filtering and pagination |
| **XL** | 8+ | **Too large — break it down further** | — |

If a task is L or larger, it should be broken into smaller tasks. An agent performs best on S and M tasks.

**When to break a task down further:**
- It would take more than one focused session (roughly 2+ hours of agent work)
- You cannot describe the acceptance criteria in 3 or fewer bullet points
- It touches two or more independent subsystems (e.g., auth and billing)
- You find yourself writing "and" in the task title (a sign it is two tasks)

## Output Files

- **Maßgeblicher Plan:** Nutze den bestehenden Planungsort und die vorhandene Planstruktur. Falls keine vorhanden sind, nutze `.codex/rules/templates/PLAN.md` als Vorlage für einen Plan an einem zum Projekt passenden Ort. Kleine, eindeutige Aufgaben können nach `.codex/rules/WORKFLOW.md` knapp in der Antwort geplant werden.
- **Aufgaben:** Halte Aufgaben mit Ergebnissen, Kriterien, Nachweisen und nötigen Abhängigkeiten im Plan oder im vorhandenen Aufgabensystem fest. Ein separates Aufgabenartefakt ist nur nötig, wenn es bereits verwendet wird oder der Umfang es sinnvoll macht.
- **Bestehende Arbeit schützen:** Unvollständige Pläne und offene Aufgaben anderer Vorhaben nicht überschreiben, löschen, umbenennen oder schließen. Für ein neues Vorhaben darf ein eigener Plan am bestehenden Planungsort entstehen; bei Unklarheit über einen blockierenden Konflikt frage nach. Bereits autorisierte Änderungen am selben Plan können vorgenommen werden, ohne fremde Inhalte zu verwerfen.

### Task List Target

Aufgaben und Status stehen grundsätzlich im maßgeblichen Plan oder in einem bereits verwendeten Aufgabensystem. Wenn ein Tracker maßgeblich ist, verlinke seine Aufgaben und Abhängigkeiten aus dem Plan, ohne einen zweiten Aufgabenstatus zu pflegen. Änderungen in einem externen System erfolgen nur im Rahmen der dafür vorliegenden Autorisierung. Ein bestimmter Slash-Befehl oder Tracker wird nicht vorausgesetzt.

## Planvorlage

Nutze die bestehende Planstruktur des Projekts oder `.codex/rules/templates/PLAN.md`. Ergänze Aufgaben, Kriterien, Nachweise, Abhängigkeiten und Risiken entsprechend dem Umfang. Wenn ein vorhandener Tracker maßgeblich ist, verlinke seine Aufgaben statt eine zweite Statusliste zu führen.

## Parallelization Opportunities

When multiple agents or sessions are available:

- **Safe to parallelize:** Independent feature slices, tests for already-implemented features, documentation
- **Must be sequential:** Database migrations, shared state changes, dependency chains
- **Needs coordination:** Features that share an API contract (define the contract first, then parallelize)

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll figure it out as I go" | That's how you end up with a tangled mess and rework. 10 minutes of planning saves hours. |
| "The tasks are obvious" | Write them down anyway. Explicit tasks surface hidden dependencies and forgotten edge cases. |
| "Planning is overhead" | Planning is the task. Implementation without a plan is just typing. |
| "I can hold it all in my head" | Context windows are finite. Written plans survive session boundaries and compaction. |
| "The old plan is stale, I'll just replace it" | Offene Aufgaben können zu anderer Arbeit gehören. Erhalte sie und lege bei Bedarf einen eigenen Plan am bestehenden Planungsort an. |

## Red Flags

- Starting substantial implementation without a suitable plan
- Overwriting another work item's incomplete plan or open tasks
- Maintaining duplicate task status in both a plan and a tracker
- Tasks that say "implement the feature" without acceptance criteria
- No verification steps in the plan
- All tasks are XL-sized
- Missing verification checkpoints where risk or dependencies warrant them
- Dependency order isn't considered

## Verification

Before starting implementation, confirm:

- [ ] Every task has acceptance criteria
- [ ] Every task has a verification step
- [ ] Task dependencies are identified and ordered correctly
- [ ] Aufgaben sind im maßgeblichen Plan oder im verlinkten bestehenden Aufgabensystem erfasst, ohne doppelten Status
- [ ] Fremde unvollständige Pläne und offene Aufgaben wurden erhalten
- [ ] Aufgabengröße und Prüfpunkte passen zu Umfang, Risiko und Abhängigkeiten
- [ ] Notwendige Entscheidungen und ausdrücklich vereinbarte Freigaben liegen vor; bereits erteilte Zustimmung wird berücksichtigt

## See Also

Acceptance criteria are per-task and answer "did we build the right thing?". They sit on top of the project-wide Definition of Done, the standing bar every task clears before it counts as done. See `.codex/ai-engineering/references/definition-of-done.md` relative to the project root.
