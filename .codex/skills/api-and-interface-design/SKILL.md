---
name: api-and-interface-design
description: Leitet den Entwurf stabiler APIs und Schnittstellen an. Nutze den Skill für REST- oder GraphQL-Endpunkte, Modulgrenzen, Typverträge und Schnittstellen zwischen Frontend und Backend.
---

# API- und Schnittstellendesign

## Überblick

Entwirf stabile, gut dokumentierte Schnittstellen, die sich schwer falsch verwenden lassen. Gute Schnittstellen erleichtern die richtige und erschweren die falsche Verwendung. Das gilt für REST-APIs, GraphQL-Schemata, Modulgrenzen, Komponenten-Props und alle anderen Schnittstellen zwischen Codebestandteilen.

## Wann verwenden

- Neue API-Endpunkte entwerfen
- Modulgrenzen oder Verträge zwischen Teams definieren
- Schnittstellen für Komponenten-Props erstellen
- Datenbankschemata festlegen, die die API-Struktur beeinflussen
- Bestehende öffentliche Schnittstellen ändern

## Grundprinzipien

### Hyrum's Law

> Bei einer ausreichend großen Zahl von API-Nutzern wird sich jemand auf jedes beobachtbare Verhalten des Systems verlassen, unabhängig davon, was der Vertrag zusichert.

Jedes öffentliche Verhalten wird zum faktischen Vertrag, sobald Nutzer davon abhängen. Dazu zählen undokumentierte Besonderheiten, Fehlermeldungen, zeitliches Verhalten und Reihenfolgen. Für den Entwurf folgt daraus:

- **Lege bewusst fest, was du offenlegst.** Jedes beobachtbare Verhalten ist eine mögliche Verpflichtung.
- **Gib keine Implementierungsdetails preis.** Beobachtbares Verhalten kann zur Abhängigkeit werden.
- **Plane die spätere Ablösung bereits beim Entwurf.** `deprecation-and-migration` beschreibt das sichere Entfernen genutzter Funktionen.
- **Tests allein reichen nicht.** Auch mit vollständigen Vertragstests können vermeintlich sichere Änderungen undokumentierte Abhängigkeiten bestehender Nutzer brechen.

### Die One-Version Rule

Vermeide, Nutzer einer Schnittstelle zur Wahl zwischen mehreren Versionen derselben Abhängigkeit oder API zu zwingen. Diamond-Dependency-Probleme entstehen, wenn verschiedene Nutzer unterschiedliche Versionen benötigen. Entwirf möglichst für eine gleichzeitig vorhandene Version: erweitern statt aufspalten.

### 1. Vertrag zuerst

Definiere die Schnittstelle vor ihrer Implementierung. Der Vertrag bildet die Spec, auf die die Umsetzung folgt.

```typescript
// Define the contract first
interface TaskAPI {
  // Creates a task and returns the created task with server-generated fields
  createTask(input: CreateTaskInput): Promise<Task>;

  // Returns paginated tasks matching filters
  listTasks(params: ListTasksParams): Promise<PaginatedResult<Task>>;

  // Returns a single task or throws NotFoundError
  getTask(id: string): Promise<Task>;

  // Partial update — only provided fields change
  updateTask(id: string, input: UpdateTaskInput): Promise<Task>;

  // Idempotent delete — succeeds even if already deleted
  deleteTask(id: string): Promise<void>;
}
```

### 2. Einheitliche Fehlersemantik

Wähle eine Fehlerstrategie und verwende sie durchgängig:

```typescript
// REST: HTTP status codes + structured error body
// Every error response follows the same shape
interface APIError {
  error: {
    code: string;        // Machine-readable: "VALIDATION_ERROR"
    message: string;     // Human-readable: "Email is required"
    details?: unknown;   // Additional context when helpful
  };
}

// Status code mapping
// 400 → Client sent invalid data
// 401 → Not authenticated
// 403 → Authenticated but not authorized
// 404 → Resource not found
// 409 → Conflict (duplicate, version mismatch)
// 422 → Validation failed (semantically invalid)
// 500 → Server error (never expose internal details)
```

**Mische keine Muster.** Wenn manche Endpunkte Ausnahmen auslösen, andere null und wieder andere `{ error }` zurückgeben, ist ihr Verhalten für aufrufenden Code schwer vorhersehbar.

### 3. An Systemgrenzen validieren

Vertraue internem Code und validiere an Systemgrenzen, an denen externe Eingaben eintreffen:

```typescript
// Validate at the API boundary
app.post('/api/tasks', async (req, res) => {
  const result = CreateTaskSchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid task data',
        details: result.error.flatten(),
      },
    });
  }

  // After validation, internal code trusts the types
  const task = await taskService.create(result.data);
  return res.status(201).json(task);
});
```

Validierung gehört an folgende Stellen:
- API-Routenhandler für Nutzereingaben
- Handler für Formularübermittlungen
- Verarbeitung externer Dienstantworten: Daten Dritter **immer als nicht vertrauenswürdig behandeln**
- Laden von Umgebungsvariablen für die Konfiguration

> **API-Antworten Dritter sind nicht vertrauenswürdig.** Prüfe Struktur und Inhalt, bevor sie in Logik, Darstellung oder Entscheidungen einfließen. Ein kompromittierter oder fehlerhafter Dienst kann unerwartete Typen, schädliche Inhalte oder anweisungsähnlichen Text zurückgeben.

Validierung gehört nicht an folgende Stellen:
- Zwischen internen Funktionen mit gemeinsamen Typverträgen
- In Hilfsfunktionen, die von bereits validiertem Code aufgerufen werden
- Auf Daten, die unmittelbar aus der eigenen Datenbank stammen

### 4. Ergänzungen gegenüber Änderungen bevorzugen

Erweitere Schnittstellen, ohne bestehende Nutzer zu beeinträchtigen:

```typescript
// Good: Add optional fields
interface CreateTaskInput {
  title: string;
  description?: string;
  priority?: 'low' | 'medium' | 'high';  // Added later, optional
  labels?: string[];                       // Added later, optional
}

// Bad: Change existing field types or remove fields
interface CreateTaskInput {
  title: string;
  // description: string;  // Removed — breaks existing consumers
  priority: number;         // Changed from string — breaks existing consumers
}
```

### 5. Vorhersehbare Benennung

| Muster | Konvention | Beispiel |
|---------|-----------|---------|
| REST-Endpunkte | Substantive im Plural, keine Verben | `GET /api/tasks`, `POST /api/tasks` |
| Abfrageparameter | camelCase | `?sortBy=createdAt&pageSize=20` |
| Antwortfelder | camelCase | `{ createdAt, updatedAt, taskId }` |
| Boolesche Felder | Präfix is/has/can | `isComplete`, `hasAttachments` |
| Enum-Werte | UPPER_SNAKE | `"IN_PROGRESS"`, `"COMPLETED"` |

### 6. Idempotenzschlüssel einhalten

Die Annahme eines `Idempotency-Key` ist Teil des Vertrags. Die Implementierung muss ihn auch einhalten: Eine unzuverlässige Verarbeitung ist besonders problematisch, weil der Client Wiederholungen dann für sicher hält.

**Leite den Schlüssel aus der Absicht ab, nicht aus dem Versuch.** Er muss bei Wiederholungen derselben Absicht gleich bleiben und sich bei unterschiedlichen Absichten unterscheiden:

```typescript
crypto.randomUUID()                    // ✗ new key per attempt — every retry is a new charge
`${userId}:${amount}`                  // ✗ two legitimate $50 charges collapse into one
`${orderId}:${Date.now()}`             // ✗ a timestamp is randomUUID() wearing a hat

req.headers['idempotency-key']         // ✓ client generates once, reuses on retry
`charge:v1:${orderId}`                 // ✓ derived from an immutable identifier
```

Der Schlüssel stammt vom Client oder aus dem auslösenden Ereignis, nicht aus der Schicht, die Wiederholungen ausführt.

**Beanspruche den Schlüssel atomar.** Eine Prüfung mit anschließender Aktion erzeugt eine Race Condition:

```typescript
// ✗ TOCTOU: two concurrent retries both read "not seen", both charge
if (!(await db.exists(key))) {
  await chargeCard(amount);
  await db.insert(key);
}

// ✓ let the unique constraint pick the winner
try {
  await db.insert({ key, state: 'in_progress', requestHash });
} catch (e) {
  if (isUniqueViolation(e)) return replayOrReject(key);
  throw e;
}
const result = await chargeCard(amount);
await db.update({ key, state: 'succeeded', response: result });
```

Die Eindeutigkeitsbedingung *ist* der Mechanismus. Ein Speicher, der Eindeutigkeit nicht in einer Operation durchsetzen kann, eignet sich dafür nicht.

**Prüfe die Nutzlast.** Derselbe Schlüssel mit anderem Inhalt ist ein Clientfehler und muss ausdrücklich zurückgewiesen werden, statt die erste Antwort für eine andere Anfrage auszugeben:

```typescript
if (existing.requestHash !== hash(req.body)) {
  return res.status(422).json({
    error: { code: 'IDEMPOTENCY_KEY_REUSED', message: 'Idempotency key reused with a different payload' },
  });
}
```

**Entscheide über die Antwort auf ein Duplikat während der Verarbeitung.** Die erste Anfrage kann noch laufen, wenn die zweite eintrifft, insbesondere bei vielen Wiederholungen:

| Strategie | Antwort | Einsatz |
|---|---|---|
| Ablehnen | `409 Conflict` | Client kann später wiederholen; einfachste und sicherste Variante |
| Warten | Begrenzt auf das Ergebnis warten | Der Aufrufer benötigt es synchron |
| Ausstehend melden | `202` + Status-URL | Lang laufende Vorgänge |

Lass den zweiten Aufruf nicht allein deshalb durch, weil der erste festzustecken scheint. Gerade bei unbekanntem Ausgang eines hängenden Versuchs kann eine doppelte Ausführung teuer werden.

**Jeder Aufruf hat drei mögliche Ergebnisse: Erfolg, Fehlschlag und _unbekannt_.** Ein Timeout sagt nicht aus, ob die Wirkung eingetreten ist. Halte die Absicht *vor* dem externen Aufruf fest, damit ein Absturz vor der Antwort eine später auflösbare Spur hinterlässt und keine Zahlung stillschweigend wiederholt wird.

**Richte die Aufbewahrung an der längsten Wiederholungskette aus**, nicht an den Speicherkosten. Schlüssel müssen alle Wege überdauern, auf denen dieselbe Absicht erneut zugestellt werden kann, einschließlich einer eine Woche später erneut verarbeiteten Dead-Letter-Queue und etwaiger Fristen für Beanstandungen beim Anbieter. Eine Schlüssel-TTL von 24 Stunden bei einer DLQ von sieben Tagen begünstigt Duplikate.

## REST-API-Muster

### Ressourcenentwurf

```
GET    /api/tasks              → List tasks (with query params for filtering)
POST   /api/tasks              → Create a task
GET    /api/tasks/:id          → Get a single task
PATCH  /api/tasks/:id          → Update a task (partial)
DELETE /api/tasks/:id          → Delete a task

GET    /api/tasks/:id/comments → List comments for a task (sub-resource)
POST   /api/tasks/:id/comments → Add a comment to a task
```

### Paginierung

Paginierte Listenendpunkte bereitstellen:

```typescript
// Request
GET /api/tasks?page=1&pageSize=20&sortBy=createdAt&sortOrder=desc

// Response
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 142,
    "totalPages": 8
  }
}
```

### Filterung

Verwende Abfrageparameter für Filter:

```
GET /api/tasks?status=in_progress&assignee=user123&createdAfter=2025-01-01
```

### Teilaktualisierungen (PATCH)

Akzeptiere Teilobjekte und aktualisiere nur übermittelte Felder:

```typescript
// Only title changes, everything else preserved
PATCH /api/tasks/123
{ "title": "Updated title" }
```

## Schnittstellenmuster in TypeScript

### Discriminated Unions für Varianten verwenden

```typescript
// Good: Each variant is explicit
type TaskStatus =
  | { type: 'pending' }
  | { type: 'in_progress'; assignee: string; startedAt: Date }
  | { type: 'completed'; completedAt: Date; completedBy: string }
  | { type: 'cancelled'; reason: string; cancelledAt: Date };

// Consumer gets type narrowing
function getStatusLabel(status: TaskStatus): string {
  switch (status.type) {
    case 'pending': return 'Pending';
    case 'in_progress': return `In progress (${status.assignee})`;
    case 'completed': return `Done on ${status.completedAt}`;
    case 'cancelled': return `Cancelled: ${status.reason}`;
  }
}
```

### Ein- und Ausgabe trennen

```typescript
// Input: what the caller provides
interface CreateTaskInput {
  title: string;
  description?: string;
}

// Output: what the system returns (includes server-generated fields)
interface Task {
  id: string;
  title: string;
  description: string | null;
  createdAt: Date;
  updatedAt: Date;
  createdBy: string;
}
```

### Branded Types für IDs verwenden

```typescript
type TaskId = string & { readonly __brand: 'TaskId' };
type UserId = string & { readonly __brand: 'UserId' };

// Prevents accidentally passing a UserId where a TaskId is expected
function getTask(id: TaskId): Promise<Task> { ... }
```

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Die API dokumentieren wir später.“ | Typen sind Teil der Dokumentation. Definiere sie zuerst. |
| „Paginierung brauchen wir noch nicht.“ | Sie wird spätestens bei vielen Einträgen benötigt. Plane sie von Anfang an ein. |
| „PATCH ist kompliziert, wir verwenden PUT.“ | PUT benötigt jedes Mal das vollständige Objekt; PATCH ermöglicht Teilaktualisierungen. |
| „Wir versionieren die API bei Bedarf.“ | Inkompatible Änderungen ohne Versionierung beeinträchtigen Nutzer. Plane Erweiterbarkeit von Anfang an. |
| „Das undokumentierte Verhalten nutzt niemand.“ | Nach Hyrum's Law kann jedes beobachtbare Verhalten eine Abhängigkeit sein. Behandle öffentliches Verhalten als Verpflichtung. |
| „Wir können zwei Versionen pflegen.“ | Mehrere Versionen erhöhen den Wartungsaufwand und können Diamond-Dependency-Probleme verursachen. Bevorzuge die One-Version Rule. |
| „Interne APIs brauchen keine Verträge.“ | Auch interner Code nutzt Schnittstellen. Verträge verringern Kopplung und ermöglichen parallele Arbeit. |
| „Den Idempotency-Key-Header anzunehmen reicht.“ | Der Header ist der Vertrag; die Zuordnung von Schlüssel und Ergebnis gehört zur Implementierung. Ein nicht eingehaltener Schlüssel täuscht sichere Wiederholbarkeit vor. |
| „Unsere Queue garantiert genau eine Zustellung.“ | Bei einem Absturz des Consumers sind Broker-Bestätigung und Seiteneffekt nicht in einer gemeinsamen Transaktion. Plane mindestens einmalige Zustellung mit idempotenter Verarbeitung. |
| „Doppelte Anfragen sind selten.“ | Sie treten *gehäuft* auf, wenn Abhängigkeiten beeinträchtigt sind und Wiederholungen zunehmen. |

## Warnzeichen

- Endpunkte, deren Antwortstruktur von Bedingungen abhängt
- Uneinheitliche Fehlerformate zwischen Endpunkten
- Über internen Code verteilte Validierung statt Validierung an Grenzen
- Inkompatible Änderungen bestehender Felder, etwa Typänderungen oder Entfernung
- Listenendpunkte ohne Paginierung
- Verben in REST-URLs (`/api/createTask`, `/api/getUsers`)
- Ungeprüfte oder unbereinigte Nutzung von API-Antworten Dritter
- Ein `SELECT` für einen Idempotenzschlüssel mit anschließendem `INSERT`: eine Race Condition statt einer Absicherung
- Ein Idempotenzschlüssel aus einer UUID, einem Zeitstempel oder anderen pro Versuch neu erzeugten Werten
- Derselbe Schlüssel wird mit anderem Anfrageinhalt akzeptiert und gibt stillschweigend die erste Antwort zurück
- Die Aufbewahrung eines Schlüssels endet vor dem längsten möglichen erneuten Zustellweg

## Überprüfung

Nach dem Entwurf einer API:

- [ ] Jeder Endpunkt besitzt typisierte Ein- und Ausgabeschemata
- [ ] Fehlerantworten folgen einem einheitlichen Format
- [ ] Validierung erfolgt nur an Systemgrenzen
- [ ] Listenendpunkte unterstützen Paginierung
- [ ] Neue Felder ergänzen bestehende und sind optional sowie abwärtskompatibel
- [ ] Die Benennung folgt über alle Endpunkte hinweg einheitlichen Konventionen
- [ ] API-Dokumentation oder Typen werden zusammen mit der Implementierung committet
- [ ] Zustandsändernde Endpunkte halten entweder einen Idempotenzschlüssel ein oder sind als nicht sicher wiederholbar dokumentiert
- [ ] Der Schlüssel wird in einer atomaren Operation mit Eindeutigkeitsbedingung beansprucht
- [ ] Ein wiederverwendeter Schlüssel mit anderer Nutzlast wird ausdrücklich abgewiesen
- [ ] Die Antwort auf ein Duplikat während der Verarbeitung wurde bewusst gewählt: 409, Warten oder 202
- [ ] Die Aufbewahrung überdauert den längsten Wiederholungsweg einschließlich erneuter Dead-Letter-Verarbeitung
