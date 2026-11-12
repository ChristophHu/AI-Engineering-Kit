# Delegationsregeln

Diese Regeln gelten, wenn Codex Projektarbeit an Subagenten delegiert. Delegation dient der gezielten Aufteilung unabhängiger Arbeit; sie ersetzt weder Produktentscheidungen noch die Verantwortung der Hauptinstanz.

## Wann delegiert wird

- Delegiere, wenn mehrere klar trennbare Teilaufgaben parallel untersucht, umgesetzt oder geprüft werden können und das Ergebnis den zusätzlichen Koordinationsaufwand wert ist.
- Bevorzuge für die ersten Delegationen lesende Aufgaben wie Codebase-Erkundung, Recherche, Triage und Review.
- Bearbeite kurze, stark voneinander abhängige oder triviale Aufgaben selbst.
- Delegiere keine wesentliche Produkt- oder Architekturentscheidung, die dem Nutzer vorbehalten ist. Sammle bei Bedarf Entscheidungsgrundlagen und frage den Nutzer.
- Erzeuge keine Agenten nur zur Auslastung. Begrenze die Anzahl auf die unabhängigen Teilaufgaben.

## Delegationsauftrag

Jeder Auftrag an einen Agenten enthält:

1. das konkrete Ziel und den relevanten Kontext beziehungsweise die Abnahmekriterien;
2. einen klaren Verantwortungsbereich, möglichst mit benannten Dateien oder Modulen;
3. erwartete Arbeitsweise: lesen, analysieren, planen, implementieren oder prüfen;
4. Abhängigkeiten, bekannte Änderungen anderer Agenten und Vorgaben zur Zusammenarbeit;
5. das gewünschte Ergebnisformat und die erforderlichen Belege.

Bei Schreibaufträgen gilt: Agenten teilen denselben Arbeitsbereich. Weise daher eindeutige Dateiverantwortung zu, fordere Agenten auf, bestehende Änderungen anderer nicht zurückzusetzen, und koordiniere Änderungen an gemeinsam betroffenen Dateien seriell. Teile konkurrierende Änderungen nicht unkoordiniert auf.

## Berechtigungen und Grenzen

- Subagenten übernehmen Sandbox-, Freigabe- und Tool-Berechtigungen der Hauptinstanz. Ein Agentenprofil erzeugt keine zusätzlichen Dateisystem- oder Sicherheitsgrenzen.
- Anweisungen wie „read-only“ beschreiben das Arbeitsziel, ersetzen aber keine technische Schreibsperre. Nutze für tatsächlich lesende Aufgaben die passende Ausführungsumgebung und kontrolliere den Arbeitsbaum.
- Externe Kommunikation, Veröffentlichung, destruktive Aktionen, Produktionsänderungen und Änderungen außerhalb des autorisierten Bereichs bleiben den bestehenden Projekt- und Sitzungsvorgaben unterstellt. Delegation erweitert keine Autorisierung.
- Teile keine Geheimnisse, Zugangsdaten oder unnötigen personenbezogenen Daten mit Agenten.

## Koordination und Abschluss

- Die Hauptinstanz behält Spec, Nutzerentscheidungen und Gesamtumfang im Blick, verfolgt laufende Aufträge und wartet auf erforderliche Ergebnisse.
- Prüfe Agentenergebnisse auf Belege, Scope, Konflikte und offene Annahmen. Übernimm Vorschläge nicht ungeprüft.
- Führe Ergebnisse zusammen, löse Überschneidungen und prüfe den integrierten Stand gegen die Abnahmekriterien. Bei Codeänderungen prüfe auch den resultierenden Diff und führe nur autorisierte, passende Verifikation aus.
- Berichte im Abschluss knapp, welche Arbeit delegiert wurde, welche Ergebnisse übernommen wurden und welche Checks oder offenen Punkte verbleiben.

## Agentenprofile

Nutze die Profile unter `.codex/agents/` nach Aufgabenart:

- `codebase-explorer.toml` für belegte, lesende Bestandsaufnahme.
- `spec-plan-reviewer.toml` für Abdeckung, Prüfbarkeit, Abhängigkeiten und Planlücken.
- `implementation-worker.toml` für eng begrenzte, ausdrücklich zugewiesene Änderungen.
- `code-reviewer.toml` für unabhängige, lesende Fehler- und Sicherheitsprüfung.
- `supabase-specialist.toml` oder `nestjs-postgres-specialist.toml` für Backend-Arbeit im jeweils ausgewählten Stack.

Profile legen Rolle und Arbeitsanweisungen fest. Sie können die Sitzungsberechtigungen der Hauptinstanz nicht verändern. Verwende Backend-Profile zusammen mit dem passenden Backend-Skill und der abgestimmten Spec/Planung.
