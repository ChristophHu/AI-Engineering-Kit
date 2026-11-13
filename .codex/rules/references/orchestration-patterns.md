# Orchestrierungsmuster für Codex

Diese Referenz ergänzt [DELEGATION.md](../DELEGATION.md) für die Aufteilung und Zusammenführung von Projektarbeit. Projekt- und Sitzungsanweisungen, Nutzeraufträge sowie die tatsächlich verfügbaren Werkzeuge und Berechtigungen haben Vorrang. Die Hauptinstanz bleibt für Entscheidungen, Integration und Abschluss verantwortlich.

Codex-Oberflächen und Konfigurationen können sich unterscheiden. Prüfe verfügbare Agentenrollen und Werkzeuge in der jeweiligen Sitzung; die Profile unter `.codex/agents/` beschreiben Aufgaben und Anweisungen, garantieren aber nicht für sich allein eine Registrierung oder eine technische Schreibsperre. Angaben zur Einrichtung sind mit der [offiziellen Codex-Dokumentation zu Subagenten](https://developers.openai.com/codex/multi-agent) und der tatsächlichen Umgebung abzugleichen.

## 1. Direkte Bearbeitung

Bearbeite kurze, eindeutige oder stark voneinander abhängige Aufgaben in der Hauptinstanz. Nutze passende Skills und vorhandene Projektanweisungen. Eine zusätzliche Agentenrolle ist sinnvoll, wenn sie einen erkennbaren Beitrag leistet oder ausdrücklich angefordert wurde.

Beispiel: Eine einzelne Dokumentationskorrektur wird direkt ausgeführt und geprüft.

## 2. Abgegrenzter Einzelauftrag

Wenn ein klar umrissener Teil eine eigene Untersuchung oder Perspektive benötigt und Delegation verfügbar und zulässig ist, beauftrage einen passenden Subagenten. Geeignete Profile sind beispielsweise `codebase-explorer.toml` für eine belegte Bestandsaufnahme oder `code-reviewer.toml` für eine unabhängige Prüfung.

Der Auftrag enthält Ziel, Kontext, Umfang, Arbeitsweise, erwartete Belege und Grenzen. Die Hauptinstanz bewertet das Ergebnis und integriert es in den Gesamtauftrag.

## 3. Parallele unabhängige Aufgaben

Teile unabhängige Aufgaben auf, wenn der Nutzen den Koordinationsaufwand rechtfertigt und die Sitzung Delegation erlaubt. Gib jedem Auftrag ein eigenes Ergebnisziel; bei Änderungen weise eindeutige Dateien oder Module zu. Weise schreibende Agenten darauf hin, dass weitere Änderungen im gemeinsamen Arbeitsbereich stattfinden können und fremde Änderungen erhalten bleiben müssen.

Die Hauptinstanz verfolgt die Aufträge, wartet auf benötigte Ergebnisse, prüft Belege und Konflikte und führt die Ergebnisse zusammen. Abhängige Änderungen an denselben Dateien werden koordiniert statt unkontrolliert parallel ausgeführt.

## 4. Abhängige Arbeitsschritte

Spec, Planung, Umsetzung und Verifikation folgen den Abhängigkeiten in `WORKFLOW.md`. Die Hauptinstanz kann diese Schritte im Rahmen des Nutzerauftrags koordinieren und geeignete Teilaufgaben delegieren. Sie übernimmt vorhandene Entscheidungen und Artefakte, hält vereinbarte Rückfragen oder Freigaben ein und informiert den Nutzer über relevante Ergebnisse und offene Punkte.

Es ist nicht erforderlich, für jede Phase einen separaten Agenten oder einen bestimmten Slash-Befehl zu verwenden. Ein Zwischenschritt ist nur dann sinnvoll, wenn er für die Aufgabe oder eine geltende Anweisung benötigt wird.

## 5. Unabhängige Prüfung

Ein Review-Agent kann einen abgegrenzten Stand anhand konkreter Anforderungen und relevanter Kontextdateien prüfen. Trenne nach Möglichkeit Autor und Prüfer; beauftrage eine lesende Untersuchung und verlange nachvollziehbare Befunde mit Auswirkung und Belegen. Die Hauptinstanz überprüft die Ergebnisse und unterscheidet berechtigte Befunde, bewusste Abwägungen und Fehlalarme.

Wenn unabhängige Agenten, getrennte Kontexte oder passende Werkzeuge nicht verfügbar oder nicht erlaubt sind, benenne diese Einschränkung. Eine Selbstprüfung darf nicht als unabhängige Prüfung ausgegeben werden.

## 6. Untersuchung konkurrierender Ursachen

Bei mehreren plausiblen Ursachen kann die Hauptinstanz unabhängige Untersuchungen mit konkreten Hypothesen und unterscheidbaren Belegen vergeben, sofern Delegation zulässig ist. Die Ergebnisse werden anhand von Code, Logs und zulässigen Prüfungen verglichen; eine Übereinstimmung mehrerer Agenten allein beweist keine Ursache. Vor Änderungen oder ausführenden Prüfungen gelten die Autorisierungs- und Umgebungsgrenzen des Projekts.

## Zu vermeidende Muster

- **Unnötige Weiterleitung:** Keine zusätzliche Agentenebene nur zur Weitergabe eines Auftrags ohne fachlichen Nutzen.
- **Unklare Verantwortung:** Keine Schreibaufträge ohne klaren Dateibereich oder ohne Abstimmung über gemeinsam genutzte Dateien.
- **Ungeprüfte Zusammenfassung:** Keine Agentenergebnisse als Tatsache übernehmen, ohne ihre Belege und den Geltungsbereich zu bewerten.
- **Verlorener Kontext:** Bei Übergaben Anforderungen, relevante Gegenbelege, Abhängigkeiten und offene Entscheidungen erhalten.
- **Unkontrollierte Verschachtelung:** Zusätzliche Agentenebenen nur verwenden, wenn Sitzung und Auftrag dies erlauben und sie einen konkreten Nutzen haben. Die Hauptinstanz behält den Überblick; keine technische Sperre für verschachtelte Delegation voraussetzen.
- **Scheinsicherheit:** Ein Rollenprofil oder ein Leseauftrag ist keine zusätzliche Sandbox. Vertrauliche Daten und externe Aktionen unterliegen weiterhin den tatsächlichen Berechtigungen.

## Auswahl und Grenzen

Prüfe vor einer Delegation:

1. Ist die Aufgabe klar abgegrenzt und bringt eine zusätzliche Perspektive oder parallele Bearbeitung einen konkreten Vorteil?
2. Sind passende Werkzeuge und gegebenenfalls das gewünschte Agentenprofil in dieser Sitzung verfügbar und darf delegiert werden?
3. Sind Ziel, Kontext, Dateiverantwortung, Berechtigungen, erwartete Belege und Abhängigkeiten klar?
4. Kann die Hauptinstanz das Ergebnis prüfen und integrieren?

Wenn diese Bedingungen nicht erfüllt sind, bearbeite die Aufgabe selbst oder melde die konkrete Einschränkung. Eine Delegation erweitert keine Nutzerautorisierung.
