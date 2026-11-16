---
name: code-simplification
description: Vereinfacht funktionierenden Code für bessere Verständlichkeit, ohne sein Verhalten zu ändern. Nutze den Skill bei unnötiger Komplexität, schwer lesbaren Funktionen oder Modulen und ausdrücklich gewünschtem Refactoring, auch bei direkt übergebenem Code.
---

# Code vereinfachen

## Überblick

Vereinfache Code durch geringere Komplexität und bewahre dabei sein Verhalten exakt. Ziel ist Code, der leichter zu lesen, zu verstehen, zu ändern und zu untersuchen ist; eine geringere Zeilenzahl allein genügt nicht. Prüfe jede Vereinfachung mit der Frage: „Würde ein neues Teammitglied diese Fassung schneller verstehen als das Original?“

## Wann verwenden

- Ein Feature funktioniert und Tests bestehen, die Implementierung ist jedoch unnötig komplex
- Im Code-Review werden Probleme mit Lesbarkeit oder Komplexität erkannt
- Tief verschachtelte Logik, lange Funktionen oder unklare Namen erschweren das Verständnis
- Unter Zeitdruck entstandener Code wird überarbeitet
- Zusammengehörige, über Dateien verteilte Logik wird zusammengeführt
- Nach einem Merge sind Duplikate oder Inkonsistenzen entstanden

**Nicht verwenden, wenn:**

- Der Code bereits klar und lesbar ist; vereinfache nicht ohne Anlass
- Du das Verhalten noch nicht verstehst; kläre es vor der Vereinfachung
- Der Code performancekritisch und die vermeintlich einfachere Variante messbar langsamer ist
- Das Modul ohnehin vollständig neu geschrieben wird und die Vereinfachung wegfallenden Code beträfe

## Die fünf Prinzipien

### 1. Verhalten exakt bewahren

Ändere nur, wie der Code sein Verhalten ausdrückt. Eingaben, Ausgaben, Seiteneffekte, Fehlerverhalten und Randfälle müssen identisch bleiben. Ist nicht sicher, dass eine Vereinfachung das Verhalten erhält, führe sie nicht aus.

```
VOR JEDER ÄNDERUNG FRAGEN:
→ Entsteht für jede Eingabe dieselbe Ausgabe?
→ Bleibt das Fehlerverhalten gleich?
→ Bleiben Seiteneffekte und ihre Reihenfolge erhalten?
→ Bestehen alle vorhandenen Tests weiterhin unverändert?
```

### 2. Projektkonventionen befolgen

Vereinfachung soll die Konsistenz mit der Codebasis verbessern, nicht externe Vorlieben durchsetzen. Vor der Vereinfachung:

```
1. AGENTS.md / Projektkonventionen lesen
2. Untersuchen, wie benachbarter Code ähnliche Muster behandelt
3. Den Projektstil beachten für:
   - Importreihenfolge und Modulsystem
   - Deklarationsstil von Funktionen
   - Namenskonventionen
   - Muster zur Fehlerbehandlung
   - Umfang von Typannotationen
```

Eine Vereinfachung, die Projektkonventionen verletzt, erzeugt unnötige Änderungen und soll nicht erfolgen.

### 3. Klarheit vor Raffinesse bevorzugen

Ausdrücklicher Code ist besser als kompakter Code, wenn Letzterer erst mühsam gedanklich entschlüsselt werden muss.

```typescript
// UNCLEAR: Dense ternary chain
const label = isNew ? 'New' : isUpdated ? 'Updated' : isArchived ? 'Archived' : 'Active';

// CLEAR: Readable mapping
type StatusLabel = 'New' | 'Updated' | 'Archived' | 'Active';

function getStatusLabel(item: Item): StatusLabel {
  if (item.isNew) return 'New';
  if (item.isUpdated) return 'Updated';
  if (item.isArchived) return 'Archived';

  return 'Active';
}
```

```typescript
// UNCLEAR: Chained reduces with inline logic
const result = items.reduce((acc, item) => ({
  ...acc,
  [item.id]: { ...acc[item.id], count: (acc[item.id]?.count ?? 0) + 1 }
}), {});

// CLEAR: Named intermediate step
const countById = new Map<string, number>();
for (const item of items) {
  countById.set(item.id, (countById.get(item.id) ?? 0) + 1);
}
```

### 4. Das richtige Maß halten

Vereinfachung kann zu weit gehen. Achte auf diese Fallen:

- **Zu aggressives Inlining** — das Entfernen einer Hilfsfunktion, die ein Konzept benennt, kann die Aufrufstelle schwerer lesbar machen
- **Sachfremde Logik zusammenführen** — zwei einfache Funktionen in einer komplexen Funktion sind keine Vereinfachung
- **„Unnötige“ Abstraktionen entfernen** — manche Abstraktionen dienen Erweiterbarkeit oder Testbarkeit
- **Auf Zeilenzahl optimieren** — Ziel ist leichteres Verständnis, nicht möglichst wenig Code

### 5. Auf den Änderungsumfang begrenzen

Vereinfache standardmäßig kürzlich geänderten Code. Vermeide beiläufiges Refactoring unabhängigen Codes, sofern der Auftrag nicht ausdrücklich erweitert wurde. Unbegrenzte Änderungen erschweren das Review und können unbeabsichtigte Regressionen verursachen.

## Vorgehen bei der Vereinfachung

### Schritt 1: Vor Änderungen verstehen (Chesterton's Fence)

Verstehe vor einer Änderung oder Entfernung, warum der betreffende Code existiert. Chesterton's Fence besagt: Reiße einen Zaun nicht ab, solange du seinen Zweck nicht kennst. Verstehe zuerst den Grund und entscheide dann, ob er weiterhin gilt.

```
VOR DER VEREINFACHUNG BEANTWORTEN:
- Welche Verantwortung hat der Code?
- Was ruft ihn auf und was ruft er selbst auf?
- Welche Rand- und Fehlerfälle gibt es?
- Definieren Tests das erwartete Verhalten?
- Warum könnte der Code so geschrieben worden sein? Performance, Plattformbeschränkung oder historischer Grund?
- Prüfe git blame: Was war der ursprüngliche Kontext?
```

Sind diese Fragen nicht beantwortbar, lies zuerst weiteren Kontext, bevor du vereinfachst.

### Schritt 2: Vereinfachungsmöglichkeiten erkennen

Suche nach folgenden konkreten Mustern:

**Strukturelle Komplexität:**

| Muster | Anzeichen | Vereinfachung |
|---------|--------|----------------|
| Tiefe Verschachtelung (ab drei Ebenen) | Schwer nachvollziehbarer Kontrollfluss | Bedingungen als Guard Clauses oder Hilfsfunktionen auslagern |
| Lange Funktionen (ab 50 Zeilen) | Mehrere Verantwortlichkeiten | In fokussierte Funktionen mit aussagekräftigen Namen aufteilen |
| Verschachtelte ternäre Ausdrücke | Gedanklich schwer nachzuvollziehen | Durch if/else-Ketten, switch oder Nachschlageobjekte ersetzen |
| Boolesche Parameterflags | `doThing(true, false, true)` | Durch Optionsobjekte oder getrennte Funktionen ersetzen |
| Wiederholte Bedingungen | Dieselbe `if`-Prüfung an mehreren Stellen | In eine aussagekräftig benannte Prädikatfunktion auslagern |

**Benennung und Lesbarkeit:**

| Muster | Anzeichen | Vereinfachung |
|---------|--------|----------------|
| Allgemeine Namen | `data`, `result`, `temp`, `val`, `item` | Inhalt beschreibend benennen: `userProfile`, `validationErrors` |
| Abgekürzte Namen | `usr`, `cfg`, `btn`, `evt` | Vollständige Wörter verwenden, außer bei allgemein bekannten Abkürzungen (`id`, `url`, `api`) |
| Irreführende Namen | Eine Funktion namens `get` verändert auch Zustand | Nach dem tatsächlichen Verhalten benennen |
| Kommentare zum „Was“ | `// increment counter` über `count++` | Den Kommentar entfernen, wenn der Code für sich klar ist |
| Kommentare zum „Warum“ | `// Retry because the API is flaky under load` | Beibehalten, da sie eine nicht aus dem Code ersichtliche Absicht erklären |

**Redundanz:**

| Muster | Anzeichen | Vereinfachung |
|---------|--------|----------------|
| Doppelte Logik | Dieselben mindestens fünf Zeilen an mehreren Stellen | In eine gemeinsame Funktion auslagern |
| Toter Code | Unerreichbare Zweige, ungenutzte Variablen, auskommentierte Blöcke | Nach Bestätigung, dass er tatsächlich ungenutzt ist, entfernen |
| Unnötige Abstraktionen | Wrapper ohne Mehrwert | Wrapper auflösen und zugrunde liegende Funktion direkt aufrufen |
| Überkonstruierte Muster | Factory-for-a-factory, strategy-with-one-strategy | Durch einen einfachen direkten Ansatz ersetzen |
| Redundante Typassertions | Cast auf einen bereits abgeleiteten Typ | Assertion entfernen |

### Schritt 3: Änderungen inkrementell anwenden

Nimm jeweils eine Vereinfachung vor und führe danach Tests aus. **Reiche Refactoring getrennt von Feature-Änderungen oder Fehlerkorrekturen ein.** Ein PR mit Refactoring und neuem Feature umfasst zwei Änderungen und sollte aufgeteilt werden.

```
FÜR JEDE VEREINFACHUNG:
1. Änderung vornehmen
2. Testsuite ausführen
3. Bestehen die Tests → committen oder mit der nächsten Vereinfachung fortfahren
4. Schlagen die Tests fehl → betroffene Änderungen eingrenzen, vorhandene Arbeit bewahren und die Korrektur überdenken; einen eigenen Schritt nur im Rahmen der bestehenden Autorisierung sicher zurücknehmen
```

Fasse nicht mehrere Vereinfachungen zu einer ungeprüften Änderung zusammen. Bei einem Fehler muss erkennbar bleiben, welche Vereinfachung ihn verursacht hat.

**The Rule of 500:** Würde ein Refactoring mehr als 500 Zeilen betreffen, nutze Automatisierung wie Codemods, sed-Skripte oder AST-Transformationen statt manueller Änderungen. Manuelle Bearbeitung in diesem Umfang ist fehleranfällig und aufwendig zu prüfen.

### Schritt 4: Ergebnis überprüfen

Beurteile nach allen Vereinfachungen das Gesamtergebnis:

```
VORHER UND NACHHER VERGLEICHEN:
- Ist die vereinfachte Fassung tatsächlich leichter zu verstehen?
- Wurden neue, mit der Codebasis unvereinbare Muster eingeführt?
- Ist der Diff übersichtlich und überprüfbar?
- Würde ein Teammitglied die Änderung freigeben?
```

Ist die „vereinfachte“ Fassung schwerer zu verstehen oder zu prüfen, grenze den eigenen Schritt ein und schlage eine sichere Rücknahme vor beziehungsweise nimm ihn im Rahmen der bestehenden Autorisierung zurück. Bewahre bereits vorhandene gestagte und ungestagte Nutzerarbeit; Verwerfen oder Zurücksetzen von Arbeit folgt `$git-workflow-and-versioning` und den geltenden Autorisierungen. Nicht jeder Vereinfachungsversuch gelingt.

## Sprachspezifische Hinweise

### TypeScript / JavaScript

```typescript
// SIMPLIFY: Unnecessary async wrapper
// Before
async function getUser(id: string): Promise<User> {
  return await userService.findById(id);
}
// After
function getUser(id: string): Promise<User> {
  return userService.findById(id);
}

// SIMPLIFY: Verbose conditional assignment
// Before
let displayName: string;
if (user.nickname) {
  displayName = user.nickname;
} else {
  displayName = user.fullName;
}
// After
const displayName = user.nickname || user.fullName;

// SIMPLIFY: Manual array building
// Before
const activeUsers: User[] = [];
for (const user of users) {
  if (user.isActive) {
    activeUsers.push(user);
  }
}
// After
const activeUsers = users.filter((user) => user.isActive);

// SIMPLIFY: Redundant boolean return
// Before
function isValid(input: string): boolean {
  if (input.length > 0 && input.length < 100) {
    return true;
  }
  return false;
}
// After
function isValid(input: string): boolean {
  return input.length > 0 && input.length < 100;
}
```

### Python

```python
# SIMPLIFY: Verbose dictionary building
# Before
result = {}
for item in items:
    result[item.id] = item.name
# After
result = {item.id: item.name for item in items}

# SIMPLIFY: Nested conditionals with early return
# Before
def process(data):
    if data is not None:
        if data.is_valid():
            if data.has_permission():
                return do_work(data)
            else:
                raise PermissionError("No permission")
        else:
            raise ValueError("Invalid data")
    else:
        raise TypeError("Data is None")
# After
def process(data):
    if data is None:
        raise TypeError("Data is None")
    if not data.is_valid():
        raise ValueError("Invalid data")
    if not data.has_permission():
        raise PermissionError("No permission")
    return do_work(data)
```

### React / JSX

```tsx
// SIMPLIFY: Verbose conditional rendering
// Before
function UserBadge({ user }: Props) {
  if (user.isAdmin) {
    return <Badge variant="admin">Admin</Badge>;
  } else {
    return <Badge variant="default">User</Badge>;
  }
}
// After
function UserBadge({ user }: Props) {
  const variant = user.isAdmin ? 'admin' : 'default';
  const label = user.isAdmin ? 'Admin' : 'User';
  return <Badge variant={variant}>{label}</Badge>;
}

// SIMPLIFY: Prop drilling through intermediate components
// Before — consider whether context or composition solves this better.
// This is a judgment call — flag it, don't auto-refactor.
```

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Es funktioniert, ich muss es nicht ändern.“ | Schwer lesbarer Code ist bei Fehlern schwerer zu korrigieren. Eine Vereinfachung kann spätere Änderungen erleichtern. |
| „Weniger Zeilen sind immer einfacher.“ | Ein einzeiliger verschachtelter ternärer Ausdruck kann schwerer zu verstehen sein als fünf Zeilen mit if/else. Verständlichkeit zählt, nicht die Zeilenzahl. |
| „Ich vereinfache schnell auch diesen unabhängigen Code.“ | Änderungen außerhalb des Umfangs erzeugen unübersichtliche Diffs und können unbeabsichtigte Regressionen verursachen. |
| „Die Typen dokumentieren den Code selbst.“ | Typen beschreiben Struktur, nicht unbedingt Absicht. Ein guter Funktionsname kann das *Warum* erläutern. |
| „Diese Abstraktion könnte später nützlich sein.“ | Rein spekulative, derzeit ungenutzte Abstraktionen verursachen Komplexität. Entferne sie und ergänze sie bei Bedarf erneut. |
| „Der ursprüngliche Autor wird einen Grund gehabt haben.“ | Prüfe den Kontext mit git blame und beachte Chesterton's Fence. Komplexität kann aber auch durch frühere Arbeitsschritte entstanden sein. |
| „Ich führe das Refactoring beim Feature gleich mit durch.“ | Trenne Refactoring und Feature-Arbeit; gemischte Änderungen lassen sich schwerer prüfen, zurücknehmen und in der Historie verstehen. |

## Warnzeichen

- Tests müssen für eine Vereinfachung geändert werden, damit sie bestehen; möglicherweise wurde das Verhalten verändert
- „Vereinfachter“ Code ist länger und schwerer nachzuvollziehen als das Original
- Namen werden nach persönlichen Vorlieben statt nach Projektkonventionen geändert
- Fehlerbehandlung wird entfernt, weil der Code dadurch „sauberer“ wirkt
- Code wird vereinfacht, obwohl er nicht vollständig verstanden wurde
- Viele Vereinfachungen werden in einem großen, schwer prüfbaren Commit gebündelt
- Code außerhalb des aktuellen Auftrags wird ohne entsprechende Bitte überarbeitet

## Überprüfung

Nach Abschluss einer Vereinfachung:

- [ ] Alle vorhandenen Tests bestehen unverändert
- [ ] Der Build ist ohne neue Warnungen erfolgreich
- [ ] Linter und Formatter bestehen ohne Stilregressionen
- [ ] Jede Vereinfachung ist eine überprüfbare, inkrementelle Änderung
- [ ] Der Diff ist übersichtlich und enthält keine vermischten unabhängigen Änderungen
- [ ] Der vereinfachte Code folgt den anhand von CLAUDE.md oder einer entsprechenden Datei geprüften Projektkonventionen
- [ ] Fehlerbehandlung wurde weder entfernt noch abgeschwächt
- [ ] Kein toter Code wie ungenutzte Imports oder unerreichbare Zweige blieb zurück
- [ ] Ein Teammitglied oder Review-Agent würde die Änderung als Verbesserung freigeben
