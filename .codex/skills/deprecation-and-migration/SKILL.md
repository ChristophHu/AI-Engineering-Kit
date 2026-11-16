---
name: deprecation-and-migration
description: Plant und begleitet Abkündigungen und Migrationen von Systemen, APIs, Features und Datenbankschemata. Nutze den Skill für sichere Übergänge, den Umgang mit bestehenden Nutzern und Entscheidungen über Weiterbetrieb oder Ablösung.
---

# Abkündigung und Migration

## Überblick

Jede Codezeile verursacht laufenden Wartungsaufwand: Fehler müssen behoben, Abhängigkeiten aktualisiert, Sicherheitskorrekturen eingespielt und neue Teammitglieder eingearbeitet werden. Abkündigung bereitet die Entfernung nicht mehr benötigten Codes vor; Migration begleitet Nutzer sicher von der alten zur neuen Lösung.

Dieser Skill unterstützt dabei, bestehende Systeme ebenso bewusst abzulösen, wie neue erstellt werden.

## Wann verwenden

- Ein altes System, eine API oder Bibliothek ersetzen
- Ein nicht mehr benötigtes Feature einstellen
- Doppelte Implementierungen zusammenführen
- Nicht mehr gepflegten Code entfernen, von dem weiterhin andere abhängen
- Den Lebenszyklus eines neuen Systems einschließlich späterer Abkündigung planen
- Zwischen Weiterbetrieb eines Altsystems und Migration entscheiden

## Grundprinzipien

### Code verursacht laufenden Aufwand

Code benötigt Tests, Dokumentation, Sicherheitskorrekturen und aktuelle Abhängigkeiten und erhöht den Verständigungsaufwand. Sein Wert liegt in seiner Funktionalität. Kann dieselbe Funktion mit weniger Code, geringerer Komplexität oder geeigneteren Abstraktionen bereitgestellt werden, sollte der alte Code entfernt werden.

### Hyrum's Law erschwert die Entfernung

Bei ausreichend vielen Nutzern kann jedes beobachtbare Verhalten zu einer Abhängigkeit werden, auch Fehler, zeitliche Besonderheiten und undokumentierte Seiteneffekte. Eine Abkündigung erfordert deshalb aktive Migration und nicht nur eine Ankündigung. Nutzer können nicht ohne Weiteres wechseln, wenn die neue Lösung benötigtes Verhalten nicht bereitstellt.

### Abkündigungsplanung beginnt beim Entwurf

Frage beim Erstellen neuer Systeme: „Wie würden wir dies in drei Jahren entfernen?“ Systeme mit klaren Schnittstellen, Feature Flags und kleiner öffentlicher Oberfläche lassen sich leichter ablösen als solche, die Implementierungsdetails verbreiten.

## Entscheidung über die Abkündigung

Beantworte vor einer Abkündigung folgende Fragen:

```
1. Bietet das System weiterhin einen besonderen Nutzen?
   → Wenn ja, weiter betreiben. Wenn nein, fortfahren.

2. Wie viele Nutzer oder andere Systeme hängen davon ab?
   → Den Migrationsumfang beziffern.

3. Gibt es einen Ersatz?
   → Wenn nein, zuerst einen Ersatz erstellen. Keine Abkündigung ohne Alternative.

4. Wie hoch ist der Migrationsaufwand je Nutzer?
   → Bei einfacher Automatisierung umsetzen; bei hohem manuellem Aufwand gegen die Wartungskosten abwägen.

5. Welche laufenden Kosten entstehen ohne Abkündigung?
   → Sicherheitsrisiken, Entwicklungszeit und Opportunitätskosten durch Komplexität betrachten.
```

## Verbindliche und empfohlene Abkündigung

| Art | Einsatz | Vorgehen |
|------|-------------|-----------|
| **Empfohlen** | Migration ist optional und das alte System stabil | Warnungen, Dokumentation und Hinweise; Nutzer migrieren nach eigenem Zeitplan. |
| **Verbindlich** | Altes System hat Sicherheitsprobleme, behindert Fortschritt oder verursacht untragbare Wartungskosten | Feste Frist für die Entfernung; Migrationswerkzeuge bereitstellen. |

**Standardmäßig empfehlen.** Eine verbindliche Migration nur verlangen, wenn Wartungskosten oder Risiken sie rechtfertigen. Dafür sind Migrationswerkzeuge, Dokumentation und Unterstützung erforderlich; eine Frist allein genügt nicht.

## Migrationsablauf

### Schritt 1: Ersatz erstellen

Kündige nichts ohne funktionsfähige Alternative ab. Der Ersatz muss:

- Alle kritischen Anwendungsfälle des alten Systems abdecken
- Dokumentation und Migrationsanleitungen besitzen
- Sich in Produktion bewährt haben und nicht nur theoretisch besser sein

### Schritt 2: Ankündigen und dokumentieren

```markdown
## Deprecation Notice: OldService

**Status:** Deprecated as of 2025-03-01
**Replacement:** NewService (see migration guide below)
**Removal date:** Advisory — no hard deadline yet
**Reason:** OldService requires manual scaling and lacks observability.
            NewService handles both automatically.

### Migration Guide
1. Replace `import { client } from 'old-service'` with `import { client } from 'new-service'`
2. Update configuration (see examples below)
3. Run the migration verification script: `npx migrate-check`
```

### Schritt 3: Inkrementell migrieren

Migriere Nutzer oder abhängige Systeme einzeln. Für jeden Verbraucher:

```
1. Alle Berührungspunkte mit dem abgekündigten System ermitteln
2. Auf den Ersatz umstellen
3. Übereinstimmendes Verhalten mit Tests und Integrationsprüfungen überprüfen
4. Verweise auf das alte System entfernen
5. Das Ausbleiben von Regressionen bestätigen
```

**The Churn Rule:** Wer die abzukündigende Infrastruktur verantwortet, ist für die Migration der Nutzer oder für abwärtskompatible Aktualisierungen ohne Migrationsaufwand verantwortlich. Überlasse Nutzer nach einer Ankündigung nicht sich selbst.

### Schritt 4: Altes System entfernen

Erst nachdem alle Verbraucher migriert sind:

```
1. Keine aktive Nutzung anhand von Metriken, Logs und Abhängigkeitsanalyse nachweisen
2. Den Code entfernen
3. Zugehörige Tests, Dokumentation und Konfiguration entfernen
4. Abkündigungshinweise entfernen
5. Die abgeschlossene Entfernung würdigen
```

## Migrationsmuster

### Strangler Pattern

Betreibe altes und neues System parallel und leite Datenverkehr schrittweise um. Entferne das alte System, sobald es 0 % des Datenverkehrs verarbeitet.

```
Phase 1: Neues System verarbeitet 0 %, altes 100 %
Phase 2: Neues System verarbeitet 10 % (Canary)
Phase 3: Neues System verarbeitet 50 %
Phase 4: Neues System verarbeitet 100 %, altes System ist ungenutzt
Phase 5: Altes System entfernen
```

### Adapter Pattern

Erstelle einen Adapter, der Aufrufe der alten Schnittstelle an die neue Implementierung übersetzt. Verbraucher nutzen während der Backend-Migration weiterhin die alte Schnittstelle.

```typescript
// Adapter: old interface, new implementation
class LegacyTaskService implements OldTaskAPI {
  constructor(private newService: NewTaskService) {}

  // Old method signature, delegates to new implementation
  getTask(id: number): OldTask {
    const task = this.newService.findById(String(id));
    return this.toOldFormat(task);
  }

  // Translate the new shape back into what old consumers expect
  private toOldFormat(task: Task): OldTask {
    return { id: Number(task.id), title: task.title, done: task.status === 'done' };
  }
}
```

### Migration mit Feature Flag

Stelle Verbraucher mithilfe von Feature Flags einzeln vom alten auf das neue System um:

```typescript
function getTaskService(userId: string): TaskService {
  if (featureFlags.isEnabled('new-task-service', { userId })) {
    return new NewTaskService();
  }
  return new OldTaskService();
}
```

### Datenbankschemamigrationen (Expand/Contract)

Schemamigrationen sind besonders riskant, weil Daten nicht allein durch das Zurücknehmen eines Deployments wiederhergestellt werden. Werden Schema- und Codeänderung gekoppelt, etwa durch Umbenennen einer Spalte im selben Release, kann während des Rollouts alter und neuer Code gleichzeitig laufen und eine nicht vorhandene Spalte abfragen. **Ändere eine Spalte nicht direkt an Ort und Stelle.** Migriere in additiven Phasen, sodass alter und neuer Code bei jedem Schritt gültig bleiben.

```
EXPAND ──────────────→ MIGRATE ──────────────→ CONTRACT
Neue nullable-Spalte   Bestehende Zeilen        Sobald kein Code die alte
neben der alten        auffüllen, beide         Spalte liest, diese später
hinzufügen             Spalten beschreiben      separat entfernen
```

**Beispiel — Umbenennung von `name` in `full_name`:**

1. **Expand.** `full_name` als nullable ergänzen und deployen. Alter Code ignoriert die neue Spalte.
2. **Dual-write.** Die App schreibt bei jedem Einfügen und Aktualisieren `name` und `full_name`. Deployen.
3. **Backfill.** Für bestehende Zeilen `name → full_name` in Batches kopieren, um die Tabelle nicht zu sperren.
4. **Lesezugriffe umstellen.** Die App liest `full_name` und schreibt weiterhin beide Spalten. Deployen und beobachten.
5. **Contract.** `name` nicht mehr beschreiben und die Spalte in einem *späteren, separaten* Deployment entfernen.

Die Phasen sind getrennt deploybar. Funktioniert Schritt 4 nicht, kann im Beispiel der Code zurückgenommen werden, während `full_name` weiterhin befüllt wird. Nach dem Entfernen einer Spalte ist dagegen gegebenenfalls eine Wiederherstellung oder Vorwärtskorrektur erforderlich; ein Schema-Rollback stellt gelöschte Daten nicht selbst wieder her. Behandle jede Phase als kleines vertikales Teilstück; siehe `incremental-implementation`.

**Regeln:**
- **Zuerst ergänzen, destruktive Schritte zuletzt und separat.** Ergänzungen wie nullable-Spalten, Tabellen und Indizes können in Deployments erfolgen; Entfernen und Umbenennen erhalten ein eigenes Deployment, *nachdem* kein Code mehr die alte Struktur referenziert.
- **Plane und überprüfe für jede Migration eine geeignete Wiederherstellungs- oder Vorwärtsstrategie.** Berücksichtige Schema, Datenintegrität, Datenverlust und Kompatibilität mit laufenden Versionen. Verwende und teste `down`, wenn es technisch unterstützt und für Schema und Daten sicher ist; andernfalls prüfe eine geeignete Wiederherstellung aus Sicherungen oder eine Vorwärtskorrektur. Dokumentiere Grenzen und offene Prüfungen. Führe destruktive Prüfungen nur in geeigneten Testumgebungen und Produktionsänderungen nur mit entsprechender Autorisierung aus.
- **Backfill in gedrosselten Batches außerhalb häufig genutzter Pfade.** Ein einzelnes `UPDATE` über Millionen Zeilen kann die Tabelle sperren.
- **Große Indizes ohne Blockierung von Schreibzugriffen erstellen**, etwa in Postgres mit `CREATE INDEX CONCURRENTLY`.
- **Bei riskanter Umschaltung per Feature Flag entkoppeln**, entsprechend dem obigen Migrationsmuster.

## Zombie Code

Zombie Code wird nicht aktiv gepflegt, hat keinen klaren Verantwortlichen und entwickelt Sicherheits- oder Kompatibilitätsprobleme, obwohl andere davon abhängen. Anzeichen:

- Seit mindestens sechs Monaten keine Commits, obwohl aktive Verbraucher existieren
- Kein zugewiesener Maintainer oder zuständiges Team
- Fehlgeschlagene Tests, die niemand behebt
- Abhängigkeiten mit bekannten Sicherheitslücken, die niemand aktualisiert
- Dokumentation verweist auf nicht mehr vorhandene Systeme

**Vorgehen:** Weise eine verantwortliche Person zu und pflege den Code oder kündige ihn mit einem konkreten Migrationsplan ab. Der Zustand benötigt entweder Wartung oder eine geplante Entfernung.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Es funktioniert noch, warum entfernen?“ | Ungepflegter Code kann Sicherheitsrisiken und wachsenden Wartungsaufwand verursachen. |
| „Vielleicht braucht es später jemand.“ | Ungenutzten Code vorsorglich beizubehalten verursacht Kosten; bei Bedarf kann er erneut erstellt werden. |
| „Die Migration ist zu teuer.“ | Vergleiche den Aufwand mit den laufenden Wartungskosten über zwei bis drei Jahre. |
| „Wir kündigen es nach Fertigstellung des neuen Systems ab.“ | Plane die Abkündigung bereits beim Entwurf, bevor andere Prioritäten entstehen. |
| „Nutzer migrieren von allein.“ | Stelle Werkzeuge, Dokumentation und Anreize bereit oder übernimm die Migration gemäß The Churn Rule. |
| „Wir können beide Systeme dauerhaft pflegen.“ | Doppelte Systeme verursachen zusätzlichen Aufwand für Wartung, Tests, Dokumentation und Einarbeitung. |
| „Die Spalte lässt sich mit einer Zeile umbenennen.“ | Beim Rollout können alter und neuer Code gleichzeitig laufen. Nutze Expand/Contract statt direkter Umbenennung. |
| „Ich ergänze die neue und entferne die alte Spalte in derselben Migration.“ | Das koppelt die Ergänzung an eine destruktive Änderung. Entferne die alte Struktur erst in einem separaten Deployment ohne verbliebene Referenzen. |
| „Die Wiederherstellung planen wir bei Bedarf.“ | Lege vor der Migration eine geeignete Strategie fest und überprüfe sie: je nach Daten und Werkzeug etwa ein sicheres `down`, eine Wiederherstellung oder eine Vorwärtskorrektur. |

## Warnzeichen

- Abgekündigte Systeme ohne verfügbaren Ersatz
- Abkündigungsankündigungen ohne Migrationswerkzeuge oder Dokumentation
- Jahrelange empfohlene Abkündigung ohne Fortschritt
- Zombie Code ohne Verantwortliche, aber mit aktiven Verbrauchern
- Neue Features im abgekündigten System statt Investitionen in den Ersatz
- Abkündigung ohne Messung der aktuellen Nutzung
- Code wird entfernt, ohne das Fehlen aktiver Verbraucher zu prüfen
- Eine Schemaänderung und davon abhängiger Code werden ohne nachgewiesene Reihenfolge oder Kompatibilität für gleichzeitig laufende Anwendungsversionen ausgeliefert; kompatible, kontrolliert angeordnete Expand/Contract-Phasen sind möglich
- Eine Spalte wird direkt umbenannt oder entfernt statt über Expand/Contract
- Eine Migration wird ohne geeignete, überprüfte Wiederherstellungs- oder Vorwärtsstrategie gemergt oder ein Backfill sperrt die Tabelle

## Überprüfung

Nach Abschluss einer Abkündigung:

- [ ] Der Ersatz ist produktiv erprobt und deckt alle kritischen Anwendungsfälle ab
- [ ] Eine Migrationsanleitung mit konkreten Schritten und Beispielen existiert
- [ ] Alle aktiven Verbraucher sind migriert; Metriken und Logs belegen dies
- [ ] Alter Code sowie zugehörige Tests, Dokumentation und Konfiguration sind vollständig entfernt
- [ ] In der Codebasis bestehen keine Verweise auf das abgekündigte System
- [ ] Abkündigungshinweise sind nach erfülltem Zweck entfernt

Nach einer Datenbankschemamigration:

- [ ] Die Änderung wird in additiven Phasen ausgeliefert (expand → backfill → contract), nicht als direkte Einzeländerung
- [ ] Alter und neuer Code sind bei jedem Deployment-Schritt mit dem Schema kompatibel
- [ ] Für jede Migration ist eine geeignete Wiederherstellungs- oder Vorwärtsstrategie dokumentiert und überprüft; Grenzen und offene Prüfungen sind benannt
- [ ] Backfills laufen in gedrosselten Batches
- [ ] Destruktive Schritte (drop/rename) erfolgen in einem eigenen Deployment, nachdem kein Code mehr die alte Struktur referenziert
