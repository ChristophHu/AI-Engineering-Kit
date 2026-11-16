---
name: planning-and-task-breakdown
description: Zerlegt Arbeit in geordnete, umsetzbare Aufgaben. Nutze den Skill bei einer Spec oder klaren Anforderungen, für umfangreiche Aufgaben, zur Umfangsschätzung oder zur Planung paralleler Arbeit.
---

# Planung und Aufgabenzerlegung

Bei der Planung einer abgestimmten Spec ist `$feature-planning` der Einstieg. Nutze diesen Skill bei Bedarf für die detaillierte Aufgabenzerlegung desselben maßgeblichen Plans, gemäß `.codex/rules/WORKFLOW.md`. Bewahre vorhandene Projektkonventionen und erstelle keine parallelen Planungs- oder Statuslisten.

## Überblick

Zerlege Arbeit in kleine, überprüfbare Aufgaben mit ausdrücklichen Abnahmekriterien. Eine gute Zerlegung unterstützt eine zuverlässige Umsetzung. Jede Aufgabe soll klein genug sein, um sie in einer konzentrierten Sitzung zu implementieren, zu testen und zu prüfen.

## Wann der Skill verwendet wird

- Eine Spec muss in umsetzbare Einheiten zerlegt werden.
- Eine Aufgabe erscheint für den Einstieg zu groß oder zu vage.
- Arbeit soll auf mehrere Agenten oder Sitzungen verteilt werden.
- Der Umfang muss einem Menschen vermittelt werden.
- Die Reihenfolge der Umsetzung ist nicht offensichtlich.

**Nicht verwenden:** Bei Änderungen an einer einzelnen Datei mit offensichtlichem Umfang oder wenn die Spec bereits klar definierte Aufgaben enthält.

## Planungsablauf

### Schritt 1: Planung beginnen

Arbeite vor dem Schreiben von Code lesend:

- Lies die Spec und relevante Bereiche der Codebasis.
- Ermittle bestehende Muster und Konventionen.
- Erfasse Abhängigkeiten zwischen Komponenten.
- Halte Risiken und Unbekanntes fest.

**Schreibe während der Planung keinen Code.** Aktualisiere den maßgeblichen Plan am etablierten Planungsort des Projekts oder nutze `.codex/rules/templates/PLAN.md`, wenn keine Projektstruktur besteht. Halte Aufgaben in diesem Plan fest oder verweise wie unten beschrieben auf das bestehende Aufgabensystem; pflege keine doppelten Statuslisten.

### Schritt 2: Abhängigkeiten erfassen

Erfasse, welche Bestandteile voneinander abhängen:

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

Die Umsetzungsreihenfolge folgt den Abhängigkeiten: Erstelle zuerst die Grundlagen.

### Schritt 3: Vertikal aufteilen

Setze jeweils einen vollständigen Funktionspfad um, statt zuerst die gesamte Datenbank, dann die gesamte API und anschließend die gesamte UI zu erstellen:

**Ungünstig (horizontale Aufteilung):**
```
Task 1: Build entire database schema
Task 2: Build all API endpoints
Task 3: Build all UI components
Task 4: Connect everything
```

**Geeignet (vertikale Aufteilung):**
```
Task 1: User can create an account (schema + API + UI for registration)
Task 2: User can log in (auth schema + API + UI for login)
Task 3: User can create a task (task schema + API + UI for creation)
Task 4: User can view task list (query + API + UI for list view)
```

Jedes vertikale Teilstück liefert funktionsfähiges, testbares Verhalten.

### Schritt 4: Aufgaben formulieren

Jede Aufgabe folgt dieser Struktur, unabhängig davon, ob sie in einer Markdown-Aufgabenliste oder einem externen Tracker steht (siehe Ausgabedateien):

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

### Schritt 5: Reihenfolge und Prüfpunkte festlegen

Ordne Aufgaben so an, dass:

1. Abhängigkeiten erfüllt sind und Grundlagen zuerst entstehen.
2. Jede Aufgabe das System in einem funktionsfähigen Zustand hinterlässt.
3. Prüfpunkte zu Risiken, Abhängigkeiten und Nutzerauftrag passen.
4. Risikoreiche Aufgaben früh bearbeitet werden, damit Probleme früh erkennbar sind.

Ergänze Prüfpunkte, wo die Arbeit sie rechtfertigt. Nutze die anwendbaren Projektprüfungen und fordere eine menschliche Prüfung nur, wenn erforderlich oder vereinbart:

```markdown
## Checkpoint: After Tasks 1-3
- [ ] All tests pass
- [ ] Application builds without errors
- [ ] Core user flow works end-to-end
- [ ] Review with human when required or agreed
```

## Richtwerte für die Aufgabengröße

| Größe | Dateien | Umfang | Beispiel |
|------|-------|-------|---------|
| **XS** | 1 | Eine Funktion oder Konfigurationsänderung | Eine Validierungsregel ergänzen |
| **S** | 1-2 | Eine Komponente oder ein Endpunkt | Einen neuen API-Endpunkt ergänzen |
| **M** | 3-5 | Ein Funktionsteilstück | Nutzerregistrierung |
| **L** | 5-8 | Funktion über mehrere Komponenten | Suche mit Filterung und Paginierung |
| **XL** | 8+ | **Zu groß – weiter zerlegen** | — |

Aufgaben der Größe L oder größer sollen weiter zerlegt werden. Ein Agent arbeitet am besten mit Aufgaben der Größen S und M.

**Wann eine Aufgabe weiter zerlegt werden sollte:**
- Sie benötigt mehr als eine konzentrierte Sitzung, ungefähr zwei oder mehr Stunden Agentenarbeit.
- Die Abnahmekriterien lassen sich nicht in höchstens drei Aufzählungspunkten beschreiben.
- Sie betrifft zwei oder mehr unabhängige Subsysteme, etwa Authentifizierung und Abrechnung.
- Im Aufgabentitel steht „und“, was auf zwei Aufgaben hindeuten kann.

## Ausgabedateien

- **Maßgeblicher Plan:** Nutze den bestehenden Planungsort und die vorhandene Planstruktur. Falls keine vorhanden sind, nutze `.codex/rules/templates/PLAN.md` als Vorlage für einen Plan an einem zum Projekt passenden Ort. Kleine, eindeutige Aufgaben können nach `.codex/rules/WORKFLOW.md` knapp in der Antwort geplant werden.
- **Aufgaben:** Halte Aufgaben mit Ergebnissen, Kriterien, Nachweisen und nötigen Abhängigkeiten im Plan oder im vorhandenen Aufgabensystem fest. Ein separates Aufgabenartefakt ist nur nötig, wenn es bereits verwendet wird oder der Umfang es sinnvoll macht.
- **Bestehende Arbeit schützen:** Unvollständige Pläne und offene Aufgaben anderer Vorhaben nicht überschreiben, löschen, umbenennen oder schließen. Für ein neues Vorhaben darf ein eigener Plan am bestehenden Planungsort entstehen; bei Unklarheit über einen blockierenden Konflikt frage nach. Bereits autorisierte Änderungen am selben Plan können vorgenommen werden, ohne fremde Inhalte zu verwerfen.

### Ziel der Aufgabenliste

Aufgaben und Status stehen grundsätzlich im maßgeblichen Plan oder in einem bereits verwendeten Aufgabensystem. Wenn ein Tracker maßgeblich ist, verlinke seine Aufgaben und Abhängigkeiten aus dem Plan, ohne einen zweiten Aufgabenstatus zu pflegen. Änderungen in einem externen System erfolgen nur im Rahmen der dafür vorliegenden Autorisierung. Ein bestimmter Slash-Befehl oder Tracker wird nicht vorausgesetzt.

## Planvorlage

Nutze die bestehende Planstruktur des Projekts oder `.codex/rules/templates/PLAN.md`. Ergänze Aufgaben, Kriterien, Nachweise, Abhängigkeiten und Risiken entsprechend dem Umfang. Wenn ein vorhandener Tracker maßgeblich ist, verlinke seine Aufgaben statt eine zweite Statusliste zu führen.

## Möglichkeiten zur Parallelisierung

Wenn mehrere Agenten oder Sitzungen verfügbar sind:

- **Parallelisierbar:** Unabhängige Funktionsteilstücke, Tests bereits implementierter Funktionen und Dokumentation
- **Sequentiell:** Datenbankmigrationen, Änderungen an gemeinsamem Zustand und Abhängigkeitsketten
- **Koordination erforderlich:** Funktionen mit gemeinsamem API-Vertrag; definiere zuerst den Vertrag und parallelisiere anschließend

## Häufige Ausreden

| Ausrede | Einordnung |
|---|---|
| „Ich finde es währenddessen heraus“ | Fehlende Planung kann zu Verwicklungen und Nacharbeit führen. Frühzeitige Planung spart Aufwand. |
| „Die Aufgaben sind offensichtlich“ | Halte sie dennoch fest. Ausdrückliche Aufgaben machen verborgene Abhängigkeiten und vergessene Randfälle sichtbar. |
| „Planung ist zusätzlicher Aufwand“ | Planung gehört zur Aufgabe; sie schafft eine Grundlage für die Umsetzung. |
| „Ich kann mir alles merken“ | Kontextfenster sind begrenzt. Schriftliche Pläne überdauern Sitzungsgrenzen und Kontextverdichtung. |
| „Der alte Plan ist veraltet, ich ersetze ihn einfach“ | Offene Aufgaben können zu anderer Arbeit gehören. Erhalte sie und lege bei Bedarf einen eigenen Plan am bestehenden Planungsort an. |

## Warnzeichen

- Umfangreiche Umsetzung ohne geeigneten Plan beginnen
- Einen unvollständigen Plan oder offene Aufgaben eines anderen Vorhabens überschreiben
- Aufgabenstatus doppelt in Plan und Tracker pflegen
- Aufgaben wie „Funktion implementieren“ ohne Abnahmekriterien formulieren
- Keine Prüfschritte im Plan vorsehen
- Ausschließlich Aufgaben der Größe XL anlegen
- Prüfpunkte auslassen, obwohl Risiken oder Abhängigkeiten sie erfordern
- Reihenfolge der Abhängigkeiten nicht berücksichtigen

## Verifikation

Bestätige vor Beginn der Umsetzung:

- [ ] Jede Aufgabe hat Abnahmekriterien
- [ ] Jede Aufgabe hat einen Prüfschritt
- [ ] Aufgabenabhängigkeiten sind erkannt und korrekt geordnet
- [ ] Aufgaben sind im maßgeblichen Plan oder im verlinkten bestehenden Aufgabensystem erfasst, ohne doppelten Status
- [ ] Fremde unvollständige Pläne und offene Aufgaben wurden erhalten
- [ ] Aufgabengröße und Prüfpunkte passen zu Umfang, Risiko und Abhängigkeiten
- [ ] Notwendige Entscheidungen und ausdrücklich vereinbarte Freigaben liegen vor; bereits erteilte Zustimmung wird berücksichtigt

## Siehe auch

Abnahmekriterien gelten je Aufgabe und beantworten, ob das Richtige umgesetzt wurde. Sie ergänzen die projektweite Definition of Done als dauerhaften Qualitätsmaßstab. Siehe `.codex/ai-engineering/references/definition-of-done.md` relativ zum Projektstamm.
