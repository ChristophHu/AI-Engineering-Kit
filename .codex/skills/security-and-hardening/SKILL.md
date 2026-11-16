---
name: security-and-hardening
description: Härtet Code gegen Sicherheitslücken. Nutze den Skill bei Nutzereingaben, Authentifizierung, Datenspeicherung, externen Integrationen, Sitzungen und Prüfungen auf OWASP-Risiken sowie bei Abhängigkeitsprüfungen, Lieferkettenrisiken und Datenschutzanforderungen.
---

# Sicherheit und Härtung

## Überblick

Sicherheitsorientierte Entwicklung für Webanwendungen: Behandle externe Eingaben als potenziell schädlich, schütze Geheimnisse und prüfe Berechtigungen zuverlässig. Sicherheit ist eine Anforderung an jeden Code, der Nutzerdaten, Authentifizierung oder externe Systeme berührt.

## Wann verwenden

- Funktionen mit Nutzereingaben erstellen
- Authentifizierung oder Autorisierung implementieren
- Vertrauliche Daten speichern oder übertragen
- Externe APIs oder Dienste integrieren
- Datei-Uploads, Webhooks oder Callbacks ergänzen
- Zahlungsdaten oder PII verarbeiten

## Vorgehen: Bedrohungsmodell zuerst

Ohne Bedrohungsmodell beruhen Schutzmaßnahmen auf Vermutungen. Betrachte vor der Härtung kurz die Perspektive eines Angreifers:

1. **Erfasse die Vertrauensgrenzen.** Wo gelangen nicht vertrauenswürdige Daten ins System? Berücksichtige HTTP-Anfragen, Formularfelder, Uploads, Webhooks, APIs Dritter, Nachrichtenwarteschlangen und **LLM-Ausgaben** sowie scheinbar interne lokale Werte: Befehlszeile oder Umgebung eines anderen Prozesses, Dateinamen auf einem gemeinsamen Datenträger oder Pfade in einer Job-Nutzlast. Entscheidend ist, wer einen Wert *geschrieben* hat, nicht sein Übertragungskanal. Jede Grenze ist eine Angriffsfläche.
2. **Benenne die Schutzgüter.** Dazu gehören Zugangsdaten, PII, Zahlungsdaten, Verwaltungsaktionen und Geldbewegungen.
3. **Prüfe jede Grenze mit STRIDE** als kurze Orientierung:

| Bedrohung | Frage | Typische Gegenmaßnahme |
|---|---|---|
| **S**poofing | Kann jemand einen Nutzer oder Dienst vortäuschen? | Authentifizierung, Signaturprüfung |
| **T**ampering | Können Daten bei Übertragung oder Speicherung verändert werden? | Integritätsprüfungen, parametrisierte Abfragen, HTTPS |
| **R**epudiation | Kann eine Handlung später bestritten werden? | Audit-Protokollierung sicherheitsrelevanter Ereignisse |
| **I**nformation disclosure | Können Daten offengelegt werden? | Verschlüsselung, Feld-Allowlisten, allgemeine Fehlermeldungen |
| **D**enial of service | Kann das System überlastet werden? | Ratenbegrenzung, Größenlimits, Timeouts |
| **E**levation of privilege | Kann ein Nutzer unzulässige Rechte erlangen? | Autorisierungsprüfungen, minimale Rechte |

4. **Halte Missbrauchsfälle neben Anwendungsfällen fest.** Frage bei jedem Feature, wie es missbraucht werden könnte, und mache daraus den ersten Test.

Sind die Vertrauensgrenzen eines Features unbekannt, fehlt eine Grundlage für seine Absicherung. Dies betrifft OWASP **A04: Insecure Design**: Viele Sicherheitsvorfälle beginnen beim Entwurf.

## Das dreistufige Grenzsystem

### Immer durchführen (ohne Ausnahmen)

- **Alle externen Eingaben** an der Systemgrenze validieren, etwa in API-Routen und Formularhandlern
- **Alle Datenbankabfragen parametrisieren** und Nutzereingaben niemals in SQL verketten
- **Ausgaben kodieren**, um XSS zu verhindern; automatisches Escaping des Frameworks verwenden und nicht umgehen
- **HTTPS** für externe Kommunikation verwenden
- **Passwörter hashen** mit bcrypt/scrypt/argon2, niemals im Klartext speichern
- **Sicherheitsheader setzen** (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- **httpOnly-, secure- und sameSite-Cookies** für Sitzungen verwenden
- **Den nativen Audit des erkannten Paketmanagers** vor jedem Release gegen die committete Lockfile ausführen

### Klärung und Autorisierung

Prüfe bei den folgenden Änderungen zuerst den Auftrag und bereits erteilte, einschlägige Autorisierungen. Ist die konkrete Änderung bereits eindeutig beauftragt und zulässig, arbeite innerhalb dieses Umfangs weiter, ohne erneut um dieselbe Zustimmung zu bitten. Kläre wesentliche offene Entscheidungen und hole tatsächlich erforderliche Freigaben für nicht autorisierte oder zusätzlich freigabepflichtige Aktionen ein; bestehende Projekt- und Sitzungsgrenzen gelten weiterhin.

- Neue Authentifizierungsabläufe oder Änderungen an der Authentifizierungslogik
- Speicherung neuer Kategorien sensibler Daten (PII, Zahlungsinformationen)
- Integration neuer externer Dienste
- Änderungen an der CORS-Konfiguration
- Ergänzung von Datei-Upload-Handlern
- Änderungen an Ratenbegrenzung oder Drosselung
- Vergabe erhöhter Berechtigungen oder Rollen

### Niemals durchführen

- **Niemals Geheimnisse committen** (API-Schlüssel, Passwörter, Tokens)
- **Niemals sensible Daten protokollieren** (Passwörter, Tokens, vollständige Kreditkartennummern)
- **Clientseitige Validierung niemals als Sicherheitsgrenze betrachten**
- **Sicherheitsheader niemals aus Bequemlichkeit deaktivieren**
- **`eval()` oder `innerHTML` niemals mit Nutzerdaten verwenden**
- **Sitzungen niemals in clientseitig zugänglichem Speicher ablegen** (localStorage für Authentifizierungstokens)
- **Nutzern niemals Stacktraces oder interne Fehlerdetails anzeigen**

## Härtungsmaßnahmen

Die folgenden Regeln beschreiben den Ablauf; konkrete Implementierungen stehen in [references/hardening-patterns.md](references/hardening-patterns.md). Öffne den benötigten Abschnitt, sobald du den betreffenden Code bearbeitest.

### Injection, XSS und Zugriffskontrolle

- Parametrisiere jede Abfrage. Erzeuge SQL, NoSQL oder Shellbefehle niemals durch Zusammenfügen von Eingaben.
- Kodiere Ausgaben über das automatische Escaping des Frameworks. Ist rohes HTML unvermeidbar, bereinige es zuvor mit einer Allowlist.
- Prüfe bei jeder Anfrage die **Autorisierung** zusätzlich zur Authentifizierung: Der Nutzer muss die konkrete Ressource besitzen oder dafür berechtigt sein (A01, IDOR).

Muster: [Injection](references/hardening-patterns.md#injection), [XSS](references/hardening-patterns.md#cross-site-scripting-xss), [Zugriffskontrolle](references/hardening-patterns.md#broken-access-control).

### Authentifizierung und Sitzungen

- Hashe Passwörter mit bcrypt (≥12 Runden), scrypt oder argon2. Das Sitzungsgeheimnis stammt aus der Umgebung, niemals aus dem Code.
- Sitzungscookies verwenden `httpOnly`, `secure` und `sameSite: 'lax'` oder `'strict'` als CSRF-Schutz sowie ein begrenztes `maxAge`; `'none'` sendet Cookies auch bei seitenübergreifenden Anfragen.

Muster: [Authentifizierung](references/hardening-patterns.md#broken-authentication).

### Header, CORS und Antworten

- Setze Sicherheitsheader bei jeder Antwort mit helmet oder einem entsprechenden Framework-Werkzeug; CSP beginnt bei `default-src 'self'` und wird weiter eingeschränkt.
- Begrenze CORS auf eine explizite Origin-Liste aus der Konfiguration. Verwende niemals `*` mit Zugangsdaten.
- Entferne sensible Felder (`passwordHash`, Reset-Tokens) vor jeder Antwort. Fehlerantworten bleiben allgemein; interne Details gehören ausschließlich ins Serverprotokoll.

Muster: [Fehlkonfiguration](references/hardening-patterns.md#security-misconfiguration), [Offenlegung sensibler Daten](references/hardening-patterns.md#sensitive-data-exposure).

### Eingabevalidierung und Uploads

- Validiere an der Grenze anhand eines Schemas: erlaubte Struktur, Längen, Enums und Formate. Weise Ungültiges mit 422 und strukturierten Details zurück; nachgelagerter Code verwendet nur den geparsten, typisierten Wert.
- Uploads: Erlaube nur festgelegte MIME-Typen, begrenze die Größe und prüfe bei Bedarf den Inhalt anhand der Magic Bytes. Die Dateiendung allein belegt nichts.

Muster: [Schemavalidierung](references/hardening-patterns.md#schema-validation-at-boundaries), [Datei-Upload](references/hardening-patterns.md#file-upload-safety).

### Serverseitige Abrufe (SSRF)

Jede vom Nutzer beeinflusste URL kann auf interne Dienste zielen, etwa bei Webhooks, URL-Importen, Bild-Proxys und Linkvorschauen. Erlaube nur festgelegte Schemata und Hosts, löse **alle** DNS-Einträge auf und lehne private oder reservierte IPv4- und IPv6-Adressen ab (Loopback, Link-Local `169.254.169.254`, private und Unique-Local-Adressen). Verbiete Weiterleitungen. Wegen einer verbleibenden DNS-Rebinding-TOCTOU-Lücke binde bei hohem Risiko die aufgelöste IP fest oder schalte einen filternden Agenten vor.

Muster: [SSRF](references/hardening-patterns.md#server-side-request-forgery-ssrf).

### Destruktive Operationen auf abgeleiteten Pfaden

Löschen, Verschieben und Überschreiben sind nur so sicher wie der Wert, der das Ziel bestimmt. Entscheidend ist, wer den Wert *geschrieben* hat: Die Befehlszeile eines anderen Prozesses kann ebenso angreifbar sein wie ein Formularfeld. Eine Strukturprüfung belegt keine Berechtigung. Prüfe vor dem Aufruf alle drei Bedingungen: Das Ziel liegt nach Auflösung von Symlinks unter einem **erlaubten Wurzelverzeichnis**, mindestens eine Ebene **unterhalb** davon, und ein **vor der Operation gelesener Eigentumsnachweis** liegt vor. Bei Ablehnung das Ziel protokollieren und abbrechen; niemals auf einen übergeordneten Standardpfad zurückfallen.

Grenzen dieser Prüfung, darunter selbst bestätigte Marker und Race Conditions zwischen Prüfung und Nutzung: [Destruktive Pfade](references/hardening-patterns.md#destructive-operations-on-derived-paths). Ausgearbeiteter Code: `.codex/ai-engineering/references/security-checklist.md` relativ zum Projektverzeichnis.

### Ratenbegrenzung

Begrenze API-Anfragen allgemein und Authentifizierungsendpunkte streng auf etwa zehn Versuche je 15 Minuten. Bei mehreren Prozessen vervielfacht sich ein lokaler Zähler auf `max × instances` oder greift bei Serverless nicht zuverlässig. Verwende einen gemeinsamen Speicher.

Muster: [Ratenbegrenzung](references/hardening-patterns.md#rate-limiting).

### Secrets

Geheimnisse stammen aus der Umgebung. `.env.example` wird mit Platzhaltern committet; echte `.env*`-Dateien und Schlüsselmaterial werden durch Git ignoriert. Durchsuche den vorgemerkten Diff vor dem Commit. **Ein Geheimnis auf einem Remote gilt als kompromittiert: zuerst austauschen, dann aus der Historie entfernen.**

Muster: [Verwaltung von Geheimnissen](references/hardening-patterns.md#secrets-management).

### Abhängigkeiten und Lieferkette

1. **Ermittle Installationsgrenze und Paketmanager.** Verwende das Workspace-Wurzelverzeichnis der Lockfile oder ein eigenständiges verschachteltes Projekt außerhalb dieses Workspace. Gleiche `packageManager`, falls vorhanden, Lockfile und CI ab; stoppe bei Widersprüchen oder konkurrierenden Lockfiles. Fixiere die Version des Paketmanagers.
2. **Blockiere Abhängigkeitsskripte vor ihrer ersten Ausführung.** Initialisiere mit deaktivierten Skripten oder einer dokumentierten standardmäßig sperrenden Richtlinie, prüfe den Skriptquelltext, erlaube nur das Nötigste, committe die Richtlinie und prüfe eine saubere frozen/immutable-Installation. Erteile niemals pauschale Freigaben.
3. **Führe vor jedem Release den nativen Audit gegen die committete Lockfile aus.** Bewerte kritische und hohe Befunde nach **Erreichbarkeit** in Laufzeit-, Build-, Test- und Deployment-Pfaden sowie Verfügbarkeit einer Korrektur. Erzwinge Behebungen (`npm audit fix --force` oder vergleichbar) niemals automatisch, da sie deklarierte Versionsbereiche überschreiten können. Prüfe Vorschau und Changelogs und teste jedes Upgrade. Dokumentiere jede Verschiebung mit Grund und Prüfdatum.
4. **Audits erkennen nur bekannte Meldungen.** Neue schädliche oder namensähnliche Pakete (`cross-env` vs `crossenv`) können unentdeckt bleiben. Prüfe neue Abhängigkeiten, Lockfile-Diffs und Änderungen der Skriptrichtlinie gemeinsam auf Eigentümerschaft, Pflege, Alter des Releases, Herkunft und transitive Abhängigkeiten. Prüfe unterstützte Registry-Signaturen (`npm audit signatures`, `pnpm audit signatures`); fehlende Signaturen sind Anlass zur Untersuchung, kein automatischer Nachweis einer Kompromittierung (A06, LLM03).

Entscheidungsbaum: [Bewertung von Abhängigkeitsprüfungen](references/hardening-patterns.md#dependency-audit-triage). Paketmanager-Matrix und Installationsskript-Prüfschranke: `.codex/ai-engineering/references/security-checklist.md` relativ zum Projektverzeichnis.

### Personenbezogene Daten und Datenschutz

Härtung fragt, ob Angreifer Daten lesen können. Datenschutz fragt zusätzlich, ob und wie lange *wir* sie überhaupt speichern sollten. Minimiere die Erhebung personenbezogener Daten.

- **Klassifiziere Felder bei ihrer Einführung** als nicht personenbezogen, PII oder sensibel und behandle sie entsprechend. Nicht auffindbare Daten lassen sich weder schützen noch zuverlässig löschen.
- **Erhebe Daten nur für einen festgelegten Zweck.** Eine mögliche spätere Nutzung ist kein Zweck. Halte PII aus Telemetriedaten heraus; `observability-and-instrumentation` behandelt dies aus Betriebssicht.
- **Lege die Aufbewahrung vorab fest und lösche tatsächlich.** Jeder Speicher personenbezogener Daten benötigt TTL und funktionierenden Löschweg, einschließlich Backups, Caches, Suchindizes und Analysekopien.
- **Unterstütze die geltenden Betroffenenrechte** (GDPR, CCPA und vergleichbare): Export, Berichtigung und Löschung. Gestalte das Schema so, dass Nutzerdaten auffindbar und löschbar bleiben.
- **Einwilligungen steuern Erhebung und Weitergabe und sind überprüfbar.** Die Übermittlung von PII an Analyse-, Werbe- oder LLM-Anbieter ist eine Weitergabe; der Anbieter benötigt eine Vereinbarung zur Datenverarbeitung. Gestalte regionale Regeln konfigurierbar.

Klassifizierungstabelle: [Datenklassifizierung](references/hardening-patterns.md#data-classification). Ein Datenschutzvorfall kann Meldefristen auslösen; führe die Nachbereitung mit `debugging-and-error-recovery` durch.

### KI- / LLM-Funktionen

Der Einsatz eines LLM für Chatbots, Zusammenfassungen, Agenten oder RAG schafft zusätzliche Angriffsflächen. Ordne sie den [OWASP Top 10 for LLM Applications (2025)](https://genai.owasp.org/llm-top-10/) zu:

- **Modellausgabe ist nicht vertrauenswürdig** (LLM05). Niemals ungeprüft an `eval`, SQL, eine Shell, `innerHTML` oder einen Dateipfad übergeben; defensiv parsen, anhand eines Schemas validieren und anschließend kodieren.
- **Prompts können manipuliert werden** (LLM01). Nicht vertrauenswürdiger Text im Kontext, etwa Nachrichten, Webseiten oder PDFs, kann Anweisungen enthalten. Der System-Prompt ist keine Sicherheitsgrenze; Berechtigungen müssen im Code durchgesetzt werden.
- **Halte Geheimnisse, Daten anderer Mandanten und den vollständigen System-Prompt aus dem Kontextfenster heraus** (LLM02, LLM07). Begrenze Werkzeugberechtigungen, validiere jedes Argument und bestätige destruktive Aktionen (LLM06). Begrenze Tokens, Anfragerate und Rekursionstiefe (LLM10). Trenne RAG-Embeddings nach Mandanten und prüfe Dokumente vor der Indexierung (LLM08).

Muster: [Verarbeitung von LLM-Ausgaben](references/hardening-patterns.md#llm-output-handling).

## Prüfliste

Gehe vor der Freigabe `.codex/ai-engineering/references/security-checklist.md` relativ zum Projektverzeichnis durch. Sie behandelt Authentifizierung, Autorisierung, Eingaben, Datenschutz, Header und CORS, Abhängigkeiten und Lieferkette, KI/LLM und Fehlerbehandlung sowie OWASP-Übersichtstabellen.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Das ist ein internes Werkzeug, Sicherheit ist egal.“ | Auch interne Werkzeuge werden kompromittiert; Angreifer suchen die schwächste Stelle. |
| „Sicherheit ergänzen wir später.“ | Nachträgliche Absicherung ist aufwendiger als frühzeitige Berücksichtigung. |
| „Niemand würde das ausnutzen.“ | Automatische Scanner können es finden; Unbekanntheit bietet keinen Schutz. |
| „Das Framework kümmert sich darum.“ | Frameworks bieten Werkzeuge, aber keine Garantie; sie müssen richtig eingesetzt werden. |
| „Es ist nur ein Prototyp.“ | Prototypen können produktiv werden; berücksichtige Sicherheit von Beginn an. |
| „Ein Bedrohungsmodell ist übertrieben.“ | Eine kurze Angreiferperspektive kann schwer nachträglich behebbare Entwurfsfehler verhindern. |
| „LLM-Ausgabe ist nur Text.“ | Der Text kann SQL, ein Skript oder einen Shellbefehl enthalten und ist nicht vertrauenswürdig. |
| „Der Audit war erfolgreich, also ist die Abhängigkeit sicher.“ | Audits erkennen bekannte Meldungen, aber keine neuen schädlichen Pakete oder ungeprüften Installationsskripte. |
| „Wir erheben es jetzt für später.“ | Nicht erhobene Daten können weder verloren gehen noch fehlerhaft gelöscht werden; eine mögliche Nutzung ist kein Zweck. |
| „Löschanfragen bearbeiten wir manuell.“ | Dabei können Backups, Caches und Analysekopien übersehen werden. Daten müssen auffindbar und löschbar sein. |
| „Compliance ist Aufgabe der Rechtsabteilung.“ | Export, Löschung, Aufbewahrung und Einwilligung betreffen Schema und Code. |

## Warnzeichen

- Nutzereingaben gelangen direkt in Datenbankabfragen, Shellbefehle oder HTML-Ausgaben
- Löschen, Verschieben oder Überschreiben anhand eines Ziels aus Nutzlast, Konfiguration oder der Befehlszeile eines anderen Prozesses, abgesichert nur durch eine Strukturprüfung
- Geheimnisse im Quellcode oder in der Commit-Historie
- API-Endpunkte ohne Authentifizierungs- oder Autorisierungsprüfung
- Fehlende CORS-Konfiguration oder Wildcard-Origins (`*`)
- Fehlende Ratenbegrenzung an Authentifizierungsendpunkten oder lokale Zähler bei mehreren Instanzen
- Stacktraces oder interne Fehler werden Nutzern angezeigt
- Abhängigkeiten mit bekannten kritischen Lücken, konkurrierende Lockfiles an einer Installationsgrenze, nicht reproduzierbare Installationen oder pauschal freigegebene Skripte
- Der Server ruft vom Nutzer vorgegebene URLs ohne Allowlist ab (SSRF)
- LLM-/Modellausgabe gelangt ungeprüft in Abfragen, DOM, Shell oder `eval`
- Geheimnisse, PII oder der vollständige System-Prompt stehen im LLM-Kontextfenster
- Personenbezogene Daten werden ohne festgelegten Zweck, Aufbewahrungsgrenze oder Löschweg erhoben
- PII wird ohne Einwilligung oder Datenverarbeitungsvereinbarung an Analyse-, Werbe- oder LLM-Anbieter gesendet
- „Konto löschen“ setzt nur ein Flag, während personenbezogene Daten in Speichern und Backups bleiben

## Überprüfung

Nach der Implementierung sicherheitsrelevanten Codes:

- [ ] Der native Audit enthält keine unbehandelten erreichbaren kritischen oder hohen Befunde; CI erhält die maßgebliche Lockfile und blockiert ungeprüfte Abhängigkeitsskripte
- [ ] Keine Geheimnisse im Quellcode oder in der Git-Historie
- [ ] Alle Nutzereingaben werden an Systemgrenzen validiert
- [ ] Destruktive Dateisystemoperationen lösen Symlinks auf und prüfen vor der Ausführung erlaubtes Wurzelverzeichnis, Mindesttiefe und Eigentümerschaft
- [ ] Authentifizierung und Autorisierung werden an jedem geschützten Endpunkt geprüft
- [ ] Sicherheitsheader sind in Antworten vorhanden, geprüft mit Browser-DevTools
- [ ] Fehlerantworten legen keine internen Details offen
- [ ] Ratenbegrenzung ist an Authentifizierungsendpunkten aktiv und verwendet bei mehreren Instanzen gemeinsamen Speicher
- [ ] Serverseitige URL-Abrufe werden anhand einer Allowlist geprüft (kein SSRF)
- [ ] LLM-/Modellausgaben werden vor der Nutzung validiert und kodiert, falls KI-Funktionen vorhanden sind
- [ ] Personenbezogene Daten sind klassifiziert, auf einen Zweck minimiert und mit einer Aufbewahrungsgrenze versehen
- [ ] Lösch- und Exportanfragen funktionieren durchgängig einschließlich Backups, Caches und Analysekopien
