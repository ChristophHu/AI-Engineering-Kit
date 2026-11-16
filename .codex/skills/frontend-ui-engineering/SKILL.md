---
name: frontend-ui-engineering
description: Erstellt oder überarbeitet barrierefreie, responsive Web-Oberflächen und Web-Komponenten. Für native Apple-Oberflächen nutze app-dev-swiftui und die passenden Apple-Design- und Prüfabschnitte.
---

# Entwicklung von Web-Oberflächen

## Überblick

Erstelle produktionsreife Oberflächen, die barrierefrei, performant und visuell ausgearbeitet sind. Beachte das Designsystem des Projekts, gestalte Interaktionen bewusst und vermeide austauschbare Gestaltungsmuster.

Dieser Skill gilt für Web-Oberflächen; HTML-, ARIA-, Browser- und Breakpoint-Vorgaben gelten nicht für native Apple-UIs. Für SwiftUI nutze `$app-dev-swiftui`, `$frontend-design-accessibility`, `$native-ios-design` passend zur Plattform und `$verify-ui`. React/TSX-Beispiele sind Beispiele und ersetzen keine Angular- oder Projektkonventionen.

## Wann verwenden

- Neue UI-Komponenten oder Seiten erstellen
- Bestehende Nutzeroberflächen ändern
- Responsive Layouts implementieren
- Interaktionen oder Zustandsverwaltung ergänzen
- Visuelle Probleme oder UX-Probleme beheben

## Komponentenarchitektur

### Dateistruktur

Lege zusammengehörige Bestandteile einer Komponente nahe beieinander ab:

```
src/components/
  TaskList/
    TaskList.tsx          # Component implementation
    TaskList.test.tsx     # Tests
    TaskList.stories.tsx  # Storybook stories (if using)
    use-task-list.ts      # Custom hook (if complex state)
    types.ts              # Component-specific types (if needed)
```

### Komponentenmuster

**Bevorzuge Komposition gegenüber Konfiguration:**

```tsx
// Good: Composable
<Card>
  <CardHeader>
    <CardTitle>Tasks</CardTitle>
  </CardHeader>
  <CardBody>
    <TaskList tasks={tasks} />
  </CardBody>
</Card>

// Avoid: Over-configured
<Card
  title="Tasks"
  headerVariant="large"
  bodyPadding="md"
  content={<TaskList tasks={tasks} />}
/>
```

**Halte Komponenten auf eine Aufgabe fokussiert:**

```tsx
// Good: Does one thing
export function TaskItem({ task, onToggle, onDelete }: TaskItemProps) {
  return (
    <li className="flex items-center gap-3 p-3">
      <Checkbox checked={task.done} onChange={() => onToggle(task.id)} />
      <span className={task.done ? 'line-through text-muted' : ''}>{task.title}</span>
      <Button variant="ghost" size="sm" onClick={() => onDelete(task.id)}>
        <TrashIcon />
      </Button>
    </li>
  );
}
```

**Trenne Datenabruf und Darstellung:**

```tsx
// Container: handles data
export function TaskListContainer() {
  const { tasks, isLoading, error, refetch, toggleTask, deleteTask } = useTasks();

  if (isLoading) return <TaskListSkeleton />;
  if (error) return <ErrorState message="Failed to load tasks" retry={refetch} />;
  if (tasks.length === 0) return <EmptyState message="No tasks yet" />;

  return <TaskList tasks={tasks} onToggle={toggleTask} onDelete={deleteTask} />;
}

// Presentation: handles rendering
export function TaskList({ tasks, onToggle, onDelete }: { tasks: Task[] } & Pick<TaskItemProps, 'onToggle' | 'onDelete'>) {
  return (
    <ul role="list" className="divide-y">
      {tasks.map(task => <TaskItem key={task.id} task={task} onToggle={onToggle} onDelete={onDelete} />)}
    </ul>
  );
}
```

## Zustandsverwaltung

**Wähle den einfachsten geeigneten Ansatz:**

```
Lokaler Zustand (useState)        → Komponentenspezifischer UI-Zustand
Hochgezogener Zustand             → Gemeinsamer Zustand von 2–3 Geschwisterkomponenten
Context                           → Theme, Authentifizierung, Spracheinstellung (häufig gelesen, selten geändert)
URL-Zustand (searchParams)       → Filter, Paginierung, teilbarer UI-Zustand
Serverzustand (React Query, SWR)  → Entfernte Daten mit Caching
Global Store (Zustand, Redux)     → Komplexer, anwendungsweit geteilter Clientzustand
```

**Vermeide Prop Drilling über mehr als drei Ebenen.** Werden Props durch Komponenten gereicht, die sie nicht verwenden, nutze Context oder strukturiere den Komponentenbaum um.

## Designsystem einhalten

### UI-Qualität anhand von Referenzen

Wenn das Produkt eine eigenständige visuelle Richtung benötigt, sammle vor der Layoutentscheidung Belege:

1. Durchsuche einen vertrauenswürdigen Referenzkatalog oder nutze vom Produktteam bereitgestellte Referenzen.
2. Untersuche zwei oder drei relevante Ansichten. Halte Entscheidungen zu Hierarchie, Dichte, Navigation, Bedienelementen, responsivem Verhalten und Interaktionszuständen fest.
3. Formuliere vor der Umsetzung einen kurzen Gestaltungsvertrag mit Aufgabe der Ansicht, primärer Aktion, erforderlichen Zuständen, responsiven Regeln und abzulehnenden Mustern.
4. Übertrage die hilfreiche Struktur in eigene Komponenten, Tokens, Inhalte und die visuelle Sprache des Produkts. Kopiere niemals Markenauftritt, geschützte Texte, Bilder oder das exakte Layout eines anderen Produkts.

Nutze Referenzen als Belege, nicht als Vorlagen. Sind keine verfügbar, dokumentiere Annahmen und prüfe das Ergebnis anhand des bestehenden Designsystems des Produkts.

### Austauschbare KI-Gestaltung vermeiden

KI-generierte Oberflächen weisen häufig wiederkehrende Muster auf. Vermeide die folgenden Varianten:

| Häufiges KI-Muster | Problem | Produktionsreife Alternative |
|---|---|---|
| Überall Violett oder Indigo | Austauschbare Farbpaletten lassen Anwendungen ähnlich aussehen | Tatsächliche Farbpalette des Projekts verwenden |
| Übermäßige Farbverläufe | Sie erzeugen visuelle Unruhe und können dem Designsystem widersprechen | Flache Gestaltung oder dezente, zum Designsystem passende Verläufe |
| Überall starke Rundungen (rounded-2xl) | Einheitlich maximale Rundung ignoriert die Hierarchie der Eckradien | Einheitliche border-radius-Werte aus dem Designsystem |
| Generische Hero-Bereiche | Vorlagenlayouts berücksichtigen Inhalte und Nutzerbedürfnisse nicht | Inhaltlich begründete Layouts |
| Lorem-ipsum-Texte | Platzhalter verdecken Probleme mit Textlänge, Umbruch und Überlauf | Realistische Platzhalterinhalte |
| Überall übergroße Innenabstände | Einheitlich große Abstände schwächen die Hierarchie und verschwenden Platz | Einheitliche Abstandsskala |
| Austauschbare Kartenraster | Gleichförmige Raster berücksichtigen Informationspriorität und Lesemuster nicht | Zweckorientierte Layouts |
| Viele Schatten | Schatten konkurrieren mit Inhalten und können das Rendering auf leistungsschwachen Geräten verlangsamen | Dezente oder keine Schatten, sofern das Designsystem nichts anderes vorgibt |

### Abstände und Layout

Verwende eine einheitliche Abstandsskala und erfinde keine Einzelwerte:

```css
/* Use the scale: 0.25rem increments (or whatever the project uses) */
/* Good */  padding: 1rem;      /* 16px */
/* Good */  gap: 0.75rem;       /* 12px */
/* Bad */   padding: 13px;      /* Not on any scale */
/* Bad */   margin-top: 2.3rem; /* Not on any scale */
```

### Typografie

Beachte die typografische Hierarchie:

```
h1 → Seitentitel (einer pro Seite)
h2 → Abschnittstitel
h3 → Titel eines Unterabschnitts
body → Standardtext
small → Sekundär- oder Hilfstext
```

Überspringe keine Überschriftenebenen. Verwende Überschriftenstile nicht für Inhalte ohne Überschriftenfunktion.

### Farbe

- Verwende semantische Farbtokens wie `text-primary`, `bg-surface` und `border-default` statt roher Hexwerte
- Stelle ausreichenden Kontrast sicher: 4.5:1 für normalen und 3:1 für großen Text
- Vermittle Informationen nicht ausschließlich über Farbe; nutze zusätzlich Symbole, Text oder Muster

## Barrierefreiheit (WCAG 2.1 AA)

Jede Komponente muss diese Anforderungen erfüllen:

### Tastaturnavigation

```tsx
// Every interactive element must be keyboard accessible
<button onClick={handleClick}>Click me</button>        // ✓ Focusable by default
<div onClick={handleClick}>Click me</div>               // ✗ Not focusable
<div role="button" tabIndex={0} onClick={handleClick}    // ✓ But prefer <button>
     onKeyDown={e => {
       if (e.key === 'Enter') handleClick();
       if (e.key === ' ') e.preventDefault();
     }}
     onKeyUp={e => {
       if (e.key === ' ') handleClick();
     }}>
  Click me
</div>
```

### ARIA-Beschriftungen

```tsx
// Label interactive elements that lack visible text
<button aria-label="Close dialog"><XIcon /></button>

// Label form inputs
<label htmlFor="email">Email</label>
<input id="email" type="email" />

// Or use aria-label when no visible label exists
<input aria-label="Search tasks" type="search" />
```

### Fokusverwaltung

```tsx
// Move focus when content changes
function Dialog({ isOpen, onClose }: DialogProps) {
  const closeRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    if (isOpen) closeRef.current?.focus();
  }, [isOpen]);

  // Trap focus inside dialog when open
  return (
    <dialog open={isOpen}>
      <button ref={closeRef} onClick={onClose}>Close</button>
      {/* dialog content */}
    </dialog>
  );
}
```

### Aussagekräftige Leer- und Fehlerzustände

```tsx
// Don't show blank screens
function TaskList({ tasks, onCreateTask }: { tasks: Task[]; onCreateTask: () => void }) {
  if (tasks.length === 0) {
    return (
      <div role="status" className="text-center py-12">
        <TasksEmptyIcon className="mx-auto h-12 w-12 text-muted" />
        <h3 className="mt-2 text-sm font-medium">No tasks</h3>
        <p className="mt-1 text-sm text-muted">Get started by creating a new task.</p>
        <Button className="mt-4" onClick={onCreateTask}>Create Task</Button>
      </div>
    );
  }

  return <ul role="list">...</ul>;
}
```

## Responsives Design

Gestalte zunächst für mobile Geräte und erweitere anschließend:

```tsx
// Tailwind: mobile-first responsive
<div className="
  grid grid-cols-1      /* Mobile: single column */
  sm:grid-cols-2        /* Small: 2 columns */
  lg:grid-cols-3        /* Large: 3 columns */
  gap-4
">
```

Teste repräsentative Viewports und die vom Projekt unterstützten Browser. 320px, 768px, 1024px und 1440px sind Beispiele und keine allgemein verpflichtenden Breakpoints.

## Ladezustände und Übergänge

```tsx
// Skeleton loading (not spinners for content)
function TaskListSkeleton() {
  return (
    <div className="space-y-3" role="status" aria-busy="true" aria-label="Loading tasks">
      {Array.from({ length: 3 }).map((_, i) => (
        <div key={i} className="h-12 bg-muted animate-pulse rounded" />
      ))}
    </div>
  );
}

// Optimistic updates for perceived speed
function useToggleTask() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: toggleTask,
    onMutate: async (taskId) => {
      await queryClient.cancelQueries({ queryKey: ['tasks'] });
      const previous = queryClient.getQueryData(['tasks']);

      queryClient.setQueryData(['tasks'], (old: Task[]) =>
        old.map(t => t.id === taskId ? { ...t, done: !t.done } : t)
      );

      return { previous };
    },
    onError: (_err, _taskId, context) => {
      queryClient.setQueryData(['tasks'], context?.previous);
    },
  });
}
```

## Siehe auch

Ausführliche Anforderungen zur Barrierefreiheit und Prüfwerkzeuge stehen in `.codex/ai-engineering/references/accessibility-checklist.md` relativ zum Projektverzeichnis.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Barrierefreiheit ist optional.“ | Sie ist in vielen Rechtsräumen vorgeschrieben und ein technischer Qualitätsstandard. |
| „Responsive Gestaltung ergänzen wir später.“ | Nachträgliche Anpassung ist deutlich aufwendiger als frühzeitige Berücksichtigung. |
| „Das Design ist noch nicht fertig, ich lasse die Gestaltung weg.“ | Nutze die Standardwerte des Designsystems; ungestaltete Oberflächen erschweren die Beurteilung. |
| „Das ist nur ein Prototyp.“ | Prototypen können zu Produktionscode werden. Schaffe eine geeignete Grundlage. |
| „Die austauschbare KI-Gestaltung reicht zunächst.“ | Nutze von Anfang an das tatsächliche Designsystem des Projekts. |

## Warnzeichen

- Komponenten mit mehr als 200 Zeilen, die aufgeteilt werden sollten
- Inline-Stile oder willkürliche Pixelwerte
- Fehlende Fehler-, Lade- oder Leerzustände
- Keine Prüfung der Tastaturnavigation
- Farbe als einziges Zustandsmerkmal, etwa Rot und Grün ohne Text oder Symbole
- Austauschbare KI-Gestaltung mit violetten Verläufen, übergroßen Karten oder Standardlayouts

## Überprüfung

Nach der Erstellung einer Oberfläche:

- [ ] Die Komponente wird ohne Konsolenfehler dargestellt
- [ ] Alle interaktiven Elemente sind per Tastatur erreichbar; die Seite wurde mit Tab geprüft
- [ ] Ein Screenreader kann Inhalt und Struktur der Seite vermitteln
- [ ] Responsives Verhalten wurde bei repräsentativen unterstützten Viewports geprüft
- [ ] Lade-, Leer-, Fehler-, Erfolgs- und Berechtigungszustände sind, soweit relevant, behandelt
- [ ] Die Oberfläche folgt dem Designsystem des Projekts für Abstände, Farben und Typografie
- [ ] Das dargestellte Ergebnis besteht eine abschließende oberflächenspezifische Qualitätsprüfung
- [ ] DevTools oder axe-core melden keine Warnungen zur Barrierefreiheit
