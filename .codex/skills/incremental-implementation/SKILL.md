---
name: incremental-implementation
description: Setzt Änderungen schrittweise in kleinen, überprüfbaren Einheiten um. Nutze den Skill für dateiübergreifende Änderungen, geplante Aufgaben, Feature Flags oder Arbeiten, die für einen einzelnen Schritt zu umfangreich erscheinen.
---

# Inkrementelle Umsetzung

## Überblick

Setze kleine vertikale Teilstücke um: Implementiere einen Teil, teste und prüfe ihn und erweitere ihn anschließend. Vermeide, eine gesamte Funktion in einem Durchgang umzusetzen. Jeder Schritt soll das System in einem funktionsfähigen, testbaren Zustand hinterlassen. So bleiben große Funktionen beherrschbar.

## Wann der Skill verwendet wird

- Bei Änderungen über mehrere Dateien hinweg
- Bei der Umsetzung einer neuen Funktion anhand einer Aufgabenzerlegung
- Beim Refactoring vorhandenen Codes
- Wenn mehr als ungefähr 100 Zeilen vor dem Testen geschrieben werden sollen

**Nicht verwenden:** Bei Änderungen an einer einzelnen Datei oder Funktion, deren Umfang bereits minimal ist.

## Zyklus eines Umsetzungsschritts

```
┌──────────────────────────────────────┐
│                                      │
│   Implement ──→ Test ──→ Verify ──┐  │
│       ▲                           │  │
│       └─ Optionaler Commit ◄──────┘  │
│              │                       │
│              ▼                       │
│          Next slice                  │
│                                      │
└──────────────────────────────────────┘
```

Für jedes Teilstück:

1. **Implementieren:** Setze das kleinste vollständige Funktionsteilstück um.
2. **Testen:** Wähle aussagekräftige Tests passend zum betroffenen Verhalten und Projekt.
3. **Prüfen:** Nutze geeignete verfügbare Prüfungen und berichte Fehler oder nicht ausgeführte Prüfungen.
4. **Bei Bedarf committen:** Fasse zusammenhängende geprüfte Arbeit gemäß `$git-workflow-and-versioning` zusammen und bewahre nicht zugehörige Änderungen.
5. **Zum nächsten Teilstück übergehen:** Baue auf dem Erreichten auf, statt neu zu beginnen.

## Strategien zur Aufteilung

### Vertikale Teilstücke (bevorzugt)

Setze jeweils einen vollständigen Pfad durch den Stack um:

```
Slice 1: Create a task (DB + API + basic UI)
    → Tests pass, user can create a task via the UI

Slice 2: List tasks (query + API + UI)
    → Tests pass, user can see their tasks

Slice 3: Edit a task (update + API + UI)
    → Tests pass, user can modify tasks

Slice 4: Delete a task (delete + API + UI + confirmation)
    → Tests pass, full CRUD complete
```

Jedes Teilstück liefert eine durchgehend funktionsfähige Funktion.

### Aufteilung anhand des Vertrags

Wenn Backend und Frontend parallel entwickelt werden müssen:

```
Slice 0: Define the API contract (types, interfaces, OpenAPI spec)
Slice 1a: Implement backend against the contract + API tests
Slice 1b: Implement frontend against mock data matching the contract
Slice 2: Integrate and test end-to-end
```

### Aufteilung nach Risiko

Bearbeite den riskantesten oder unsichersten Teil zuerst:

```
Slice 1: Prove the WebSocket connection works (highest risk)
Slice 2: Build real-time task updates on the proven connection
Slice 3: Add offline support and reconnection
```

Schlägt Schritt 1 fehl, wird dies vor Investitionen in Schritt 2 und 3 erkannt.

## Umsetzungsregeln

### Regel 0: Einfachheit zuerst

Frage vor dem Schreiben von Code: „Was ist die einfachste Lösung, die funktionieren könnte?“

Prüfe den Code anschließend anhand dieser Fragen:
- Lässt sich dies mit weniger Zeilen umsetzen?
- Rechtfertigen die Abstraktionen ihre Komplexität?
- Würde ein erfahrener Entwickler fragen, warum es nicht einfacher gelöst wurde?
- Entsteht die Lösung für hypothetische künftige Anforderungen oder für die aktuelle Aufgabe?

```
SIMPLICITY CHECK:
✗ Generic EventBus with middleware pipeline for one notification
✓ Simple function call

✗ Abstract factory pattern for two similar components
✓ Two straightforward components with shared utilities

✗ Config-driven form builder for three forms
✓ Three form components
```

Drei ähnliche Codezeilen sind besser als eine verfrühte Abstraktion. Implementiere zuerst die einfache, offensichtlich korrekte Version. Optimiere erst, nachdem ihre Korrektheit durch Tests belegt ist.

### Regel 0.5: Umfang einhalten

Ändere nur, was die Aufgabe erfordert.

Unterlasse Folgendes:
- Benachbarten Code beiläufig „aufräumen“
- Imports in nicht bearbeiteten Dateien umgestalten
- Kommentare entfernen, die du nicht vollständig verstehst
- Nicht spezifizierte Funktionen ergänzen, weil sie „nützlich erscheinen“
- Syntax in Dateien modernisieren, die du nur liest

Wenn dir außerhalb des Aufgabenumfangs eine mögliche Verbesserung auffällt, notiere sie, statt sie beiläufig umzusetzen:

```
NOTICED BUT NOT TOUCHING:
- src/utils/format.ts has an unused import (unrelated to this task)
- The auth middleware could use better error messages (separate task)
→ Want me to create tasks for these?
```

### Regel 1: Ein Thema nach dem anderen

Jeder Schritt ändert eine zusammenhängende Sache. Vermische keine unterschiedlichen Anliegen:

**Ungünstig:** Ein Commit ergänzt eine neue Komponente, überarbeitet eine bestehende und ändert die Build-Konfiguration.

**Geeignet:** Drei getrennte Commits, jeweils einer pro Änderung.

### Regel 2: Kompilierbarkeit erhalten

Halte jeden Schritt in sich schlüssig und überprüfbar. Führe von der Änderung betroffene Prüfungen zu einem geeigneten Zeitpunkt aus; wiederhole eine unveränderte Prüfung nicht ohne Anlass. Berichte bereits bestehende Fehler und nicht ausführbare Prüfungen, statt Erfolg zu behaupten.

### Regel 3: Feature Flags für unvollständige Funktionen

Wenn eine Funktion noch nicht für Nutzer bereit ist, einzelne Schritte aber zusammengeführt werden müssen:

```typescript
// Feature flag for work-in-progress
const ENABLE_TASK_SHARING = process.env.FEATURE_TASK_SHARING === 'true';

if (ENABLE_TASK_SHARING) {
  // New sharing UI
}
```

So lassen sich kleine Schritte in den Hauptbranch integrieren, ohne unvollständige Arbeit sichtbar zu machen.

### Regel 4: Sichere Standardwerte

Neuer Code soll standardmäßig ein sicheres, zurückhaltendes Verhalten aufweisen:

```typescript
// Safe: disabled by default, opt-in
export function createTask(data: TaskInput, options?: { notify?: boolean }) {
  const shouldNotify = options?.notify ?? false;
  // ...
}
```

### Regel 5: Rücknahme ermöglichen

Jeder Schritt soll sich unabhängig zurücknehmen lassen:

- Ergänzende Änderungen wie neue Dateien oder Funktionen lassen sich leicht zurücknehmen.
- Änderungen an bestehendem Code sollen klein und zielgerichtet sein.
- Plane für Datenbankmigrationen eine geeignete Rücknahme oder Vorwärtskorrektur entsprechend Projekt- und Datenbedingungen.
- Trenne Löschung und Ersatz nur, wenn jeder Zwischen-Commit in sich schlüssig und überprüfbar bleibt; halte sie andernfalls zusammen.

## Arbeit mit Agenten

Bei der Beauftragung eines Agenten für eine inkrementelle Umsetzung:

```
"Let's implement Task 3 from the plan.

Start with just the database schema change and the API endpoint.
Don't touch the UI yet — we'll do that in the next increment.

After implementing, run the repository's test and build commands to
verify nothing is broken."
```

Halte für jeden Schritt ausdrücklich fest, was zum Umfang gehört und was nicht.

## Checkliste je Schritt

Prüfe nach jedem Schritt mit den repositoryeigenen Befehlen; beachte den Abschnitt zur Ermittlung des Stacks im Skill `test-driven-development`:

- [ ] Die Änderung erledigt eine Aufgabe vollständig
- [ ] Relevante Tests, Build, Typprüfung und Linting wurden anhand der Änderung und verfügbaren Projektbefehle ausgewählt; Ergebnisse und nicht verfügbare Prüfungen sind berichtet
- [ ] Die neue Funktion arbeitet wie erwartet
- [ ] Jeder Commit folgt dem autorisierten Git-Workflow und hat eine aussagekräftige Nachricht

**Hinweis:** Führe einen Prüfbefehl nach Änderungen aus, die sein Ergebnis beeinflussen können. Wiederhole ihn nach einem erfolgreichen Lauf nicht ohne zwischenzeitliche Codeänderung; bei unverändertem Code liefert dies keine neue Information.

## Häufige Ausreden

| Ausrede | Einordnung |
|---|---|
| „Ich teste alles am Ende“ | Fehler können sich fortpflanzen. Ein Fehler in Schritt 1 kann Schritt 2 bis 5 beeinträchtigen. Prüfe jeden Schritt. |
| „Alles auf einmal ist schneller“ | Es fühlt sich schneller an, bis etwas fehlschlägt und die Ursache unter 500 geänderten Zeilen gesucht werden muss. |
| „Diese Änderungen sind für separate Commits zu klein“ | Kleine Commits sind kostengünstig. Große Commits können Fehler verbergen und Rücknahmen erschweren. |
| „Das Feature Flag ergänze ich später“ | Ist die Funktion unvollständig, soll sie Nutzern nicht sichtbar sein. Ergänze das Flag jetzt. |
| „Dieses Refactoring ist klein genug, um es mit aufzunehmen“ | Mit Funktionen vermischte Refactorings erschweren Prüfung und Fehlersuche. Trenne sie. |
| „Ich führe den Build zur Sicherheit noch einmal aus“ | Nach einem erfolgreichen Lauf liefert derselbe Befehl ohne Codeänderung keine neue Information. Führe ihn nach späteren Änderungen aus, nicht zur bloßen Beruhigung. |

## Warnzeichen

- Mehr als 100 Zeilen Code ohne Testausführung geschrieben
- Mehrere zusammenhanglose Änderungen in einem Schritt
- Umfangsausweitung durch „Das ergänze ich schnell noch“
- Test- oder Prüfschritte zugunsten von Geschwindigkeit überspringen
- Fehlgeschlagener Build oder fehlgeschlagene Tests zwischen Schritten
- Ansammlung großer uncommitteter Änderungen
- Abstraktionen erstellen, bevor ein dritter Anwendungsfall sie erfordert
- Dateien außerhalb des Aufgabenumfangs beiläufig ändern
- Neue Hilfsdateien für einmalige Operationen erstellen
- Denselben Build- oder Testbefehl ohne zwischenzeitliche Codeänderung zweimal hintereinander ausführen

## Verifikation

Nach Abschluss aller Schritte einer Aufgabe:

- [ ] Jeder Schritt wurde geeignet geprüft; zusammenhängende Arbeit wurde bei Bedarf committet
- [ ] Erforderliche und anwendbare Tests, Build und End-to-End-Prüfungen haben Ergebnisse oder sind ausdrücklich als offen berichtet
- [ ] Verbleibende aufgabenbezogene und bereits bestehende uncommittete Änderungen sind erkannt und bleiben erhalten

## Siehe auch

Die Prüfung je Schritt ist die lokale Kontrolle. Wende vor Abschluss einer Aufgabe die projektweite Definition of Done als abschließenden Qualitätsmaßstab an. Siehe `.codex/ai-engineering/references/definition-of-done.md` relativ zum Projektstamm.
