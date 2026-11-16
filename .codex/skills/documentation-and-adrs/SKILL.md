---
name: documentation-and-adrs
description: Dokumentiert Architekturentscheidungen, ihre Begründungen und relevanten Projektkontext. Nutze den Skill für ADRs, Änderungen öffentlicher APIs, nutzerseitige Features und Dokumentation für spätere Projektarbeit.
---

# Dokumentation und ADRs

## Überblick

Dokumentiere Entscheidungen und nicht nur Code. Besonders wertvoll ist das *Warum*: Kontext, Einschränkungen und Abwägungen, die zu einer Entscheidung geführt haben. Code zeigt, *was* erstellt wurde; Dokumentation erklärt, *warum es so umgesetzt wurde* und *welche Alternativen betrachtet wurden*. Dieser Kontext hilft Menschen und Agenten bei späterer Arbeit an der Codebasis.

## Wann verwenden

- Eine wesentliche Architekturentscheidung treffen
- Zwischen konkurrierenden Ansätzen wählen
- Eine öffentliche API ergänzen oder ändern
- Ein Feature mit Auswirkungen auf das Nutzerverhalten veröffentlichen
- Neue Teammitglieder oder Agenten in das Projekt einarbeiten
- Dieselben Zusammenhänge wiederholt erklären

**Nicht verwenden:** Offensichtlichen Code nicht zusätzlich dokumentieren, Code nicht bloß in Kommentaren wiederholen und keine Dokumentation für Wegwerfprototypen schreiben.

## Architecture Decision Records (ADRs)

ADRs halten die Begründung wesentlicher technischer Entscheidungen fest und liefern damit besonders wertvollen Kontext.

### Wann ein ADR erstellen

- Ein Framework, eine Bibliothek oder eine wesentliche Abhängigkeit auswählen
- Ein Datenmodell oder Datenbankschema entwerfen
- Eine Authentifizierungsstrategie wählen
- Über eine API-Architektur entscheiden, etwa REST, GraphQL oder tRPC
- Zwischen Build-Werkzeugen, Hostingplattformen oder Infrastruktur wählen
- Eine Entscheidung treffen, die sich nur mit hohem Aufwand rückgängig machen ließe

### Zuerst bestehende Konventionen beachten

Untersuche vor dem Erstellen eines ADR den verfügbaren Repository-Kontext auf bestehende Konventionen: vorhandene ADRs, Projektanweisungen sowie zugehörige Konfiguration oder Werkzeuge, etwa eine `.adr-dir`-Datei. Bestehende Konventionen haben Vorrang vor den folgenden Standardvorgaben. Übernimm:

- **Ort und Format** — etwa `docs/adr/*.md`, `Documentation/Decisions/*.rst`, ein MADR-Layout oder eine `adr-tools`-Einrichtung. Übernimm Verzeichnis, Dateiendung und Auszeichnungssprache wie Markdown oder reStructuredText.
- **Nummerierung und Benennung** — setze die bestehende Folge und das Dateinamenmuster (`ADR-004-Title.rst`, `0004-title.md`, …) fort; beginne nicht erneut bei 001 und führe kein zweites Schema ein.
- **Abschnittsüberschriften** — verwende die des Projekts statt der Überschriften dieser Vorlage.

Widersprechen sich die verfügbaren Hinweise, mache den Konflikt sichtbar, statt stillschweigend ein weiteres Schema einzuführen. Verwende die folgenden Standardvorgaben nur, wenn keine Konvention ermittelt werden kann.

### ADR-Vorlage

Speichere ADRs fortlaufend nummeriert unter `docs/decisions/`, sofern das Projekt keinen anderen Ort verwendet:

```markdown
# ADR-001: Use PostgreSQL for primary database

## Status
Proposed | Accepted | Superseded by ADR-XXX | Deprecated

## Date
2025-01-15

## Context
We need a primary database for the task management application. Key requirements:
- Relational data model (users, tasks, teams with relationships)
- ACID transactions for task state changes
- Support for full-text search on task content
- Managed hosting available (for small team, limited ops capacity)

## Decision
Use PostgreSQL with Prisma ORM.

## Alternatives Considered

### MongoDB
- Pros: Flexible schema, easy to start with
- Cons: Our data is inherently relational; would need to manage relationships manually
- Rejected: Relational data in a document store leads to complex joins or data duplication

### SQLite
- Pros: Zero configuration, embedded, fast for reads
- Cons: Limited concurrent write support, no managed hosting for production
- Rejected: Not suitable for multi-user web application in production

### MySQL
- Pros: Mature, widely supported
- Cons: PostgreSQL has better JSON support, full-text search, and ecosystem tooling
- Rejected: PostgreSQL is the better fit for our feature requirements

## Consequences
- Prisma provides type-safe database access and migration management
- We can use PostgreSQL's full-text search instead of adding Elasticsearch
- Team needs PostgreSQL knowledge (standard skill, low risk)
- Hosting on managed service (Supabase, Neon, or RDS)
```

### ADR-Lebenszyklus

```
PROPOSED → ACCEPTED → (SUPERSEDED or DEPRECATED)
```

- **Lösche alte ADRs nicht.** Sie erhalten den historischen Kontext.
- Ändert sich eine Entscheidung, erstelle ein neues ADR, das auf das alte verweist und es ersetzt.

## Dokumentation im Code

### Wann kommentieren

Kommentiere das *Warum*, nicht das *Was*:

```typescript
// BAD: Restates the code
// Increment counter by 1
counter += 1;

// GOOD: Explains non-obvious intent
// Rate limit uses a fixed window that opens on the first request after the
// previous one expires, not on a clock schedule. Known gap: a client can spend
// the full limit just before a reset and again just after (2x in a moment)
if (now - windowStart > WINDOW_SIZE_MS) {
  counter = 0;
  windowStart = now;
}
```

### Wann nicht kommentieren

```typescript
// Don't comment self-explanatory code
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// Don't leave TODO comments for things you should just do now
// TODO: add error handling  ← Just add it

// Don't leave commented-out code
// const oldImplementation = () => { ... }  ← Delete it, git has history
```

### Bekannte Stolperstellen dokumentieren

```typescript
/**
 * IMPORTANT: This function must be called before the first render.
 * If called after hydration, it causes a flash of unstyled content
 * because the theme context isn't available during SSR.
 *
 * See ADR-003 for the full design rationale.
 */
export function initializeTheme(theme: Theme): void {
  // ...
}
```

## API-Dokumentation

Für öffentliche APIs, etwa REST, GraphQL oder Bibliotheksschnittstellen:

### Direkt bei den Typen (für TypeScript bevorzugt)

```typescript
/**
 * Creates a new task.
 *
 * @param input - Task creation data (title required, description optional)
 * @returns The created task with server-generated ID and timestamps
 * @throws {ValidationError} If title is empty or exceeds 200 characters
 * @throws {AuthenticationError} If the user is not authenticated
 *
 * @example
 * const task = await createTask({ title: 'Buy groceries' });
 * console.log(task.id); // "task_abc123"
 */
export async function createTask(input: CreateTaskInput): Promise<Task> {
  // ...
}
```

### OpenAPI / Swagger für REST-APIs

```yaml
paths:
  /api/tasks:
    post:
      summary: Create a task
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateTaskInput'
      responses:
        '201':
          description: Task created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Task'
        '422':
          description: Validation error
```

## README-Struktur

Jedes Projekt sollte eine README mit folgenden Inhalten haben:

```markdown
# Project Name

One-paragraph description of what this project does.

## Quick Start
1. Clone the repo
2. Install dependencies: `npm install`
3. Set up environment: `cp .env.example .env`
4. Run the dev server: `npm run dev`

## Commands
| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm test` | Run tests |
| `npm run build` | Production build |
| `npm run lint` | Run linter |

## Architecture
Brief overview of the project structure and key design decisions.
Link to ADRs for details.

## Contributing
How to contribute, coding standards, PR process.
```

## Changelog pflegen

Für veröffentlichte Features:

```markdown
# Changelog

## [1.2.0] - 2025-01-20
### Added
- Task sharing: users can share tasks with team members (#123)
- Email notifications for task assignments (#124)

### Fixed
- Duplicate tasks appearing when rapidly clicking create button (#125)

### Changed
- Task list now loads 50 items per page (was 20) for better UX (#126)
```

## Dokumentation für Agenten

Berücksichtige für den Kontext von KI-Agenten insbesondere:

- **CLAUDE.md / Regeldateien** — Projektkonventionen dokumentieren, damit Agenten sie befolgen
- **Spec-Dateien** — Specs aktuell halten, damit Agenten das Vereinbarte umsetzen
- **ADRs** — Frühere Entscheidungen und ihre Gründe erklären, um erneute Entscheidungen zu vermeiden
- **Stolperstellen im Code** — Agenten vor bekannten Problemen schützen

## Sprachliche Prüfung

Prüfe nach dem fachlichen Inhalt die Verständlichkeit für die künftigen Lesenden. Klarere Formulierungen dürfen die Entscheidung und ihre Grenzen nicht verändern.

1. Markiere zu erhaltende Einzelheiten: Namen, Zahlen und Einheiten, Befehle, Pfade, Links, Bedingungen, Abwägungen und Unsicherheit. Gleiche sie mit verfügbarem Code und Entscheidungskontext ab und kennzeichne nicht belegbare Punkte.
2. Ersetze allgemeine Einleitungen, werbende Adjektive und wiederholte Zusammenfassungen durch benötigte konkrete Informationen. Ersetze unbelegte Aussagen nicht durch erfundene Beispiele oder stärkere Zusicherungen. Behalte notwendige technische Wiederholungen und etablierte Projektbegriffe bei.
3. Vergleiche das überarbeitete Dokument mit Original und Quellen. Stelle verlorene Einschränkungen wieder her, prüfe die dokumentierte Funktionsweise von Befehls- und Codebeispielen und benenne ungeklärte Sachfragen ausdrücklich.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Der Code dokumentiert sich selbst.“ | Code zeigt das Was, aber nicht unbedingt Gründe, verworfene Alternativen oder geltende Einschränkungen. |
| „Wir dokumentieren, wenn die API stabil ist.“ | Dokumentation prüft den Entwurf frühzeitig und kann seine Stabilisierung unterstützen. |
| „Niemand liest Dokumentation.“ | Agenten, spätere Teammitglieder und man selbst zu einem späteren Zeitpunkt benötigen sie. |
| „ADRs sind zusätzlicher Aufwand.“ | Eine kurze Dokumentation kann spätere Diskussionen über dieselbe Entscheidung vermeiden. |
| „Kommentare veralten.“ | Kommentare zum *Warum* bleiben oft länger relevant als solche zum offensichtlichen *Was*. |

## Warnzeichen

- Architekturentscheidungen ohne schriftliche Begründung
- Öffentliche APIs ohne Dokumentation oder Typen
- README ohne Erklärung zum Starten des Projekts
- Auskommentierter statt entfernter Code
- Seit Wochen bestehende TODO-Kommentare
- Keine ADRs trotz wesentlicher Architekturentscheidungen
- Dokumentation wiederholt Code, statt die Absicht zu erklären

## Überprüfung

Nach der Dokumentation:

- [ ] Für alle wesentlichen Architekturentscheidungen existieren ADRs
- [ ] Die README enthält Schnellstart, Befehle und Architekturüberblick
- [ ] API-Funktionen dokumentieren Parameter und Rückgabetypen
- [ ] Bekannte Stolperstellen sind an relevanten Stellen im Code dokumentiert
- [ ] Kein auskommentierter Code ist zurückgeblieben
- [ ] Regeldateien wie CLAUDE.md sind aktuell und korrekt
- [ ] Sprachliche Änderungen erhalten Quelldetails, Entscheidungsabwägungen und Einschränkungen, ohne unbelegte Zusicherungen einzuführen
