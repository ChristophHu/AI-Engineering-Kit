---
name: init
description: Entwickelt eine ursprüngliche App-Idee vor der Implementierung durch ein angepasstes Interview mit jeweils einer Frage zu einem abgestimmten Produktbrief, einer Designsystemrichtung und einer priorisierten Feature-Map.
---

# Init

## Ziel

Hilf dem Nutzer, eine ursprüngliche Idee vor dem Schreiben von Implementierungscode in eine klare Produktvision und eine priorisierte Feature-Map zu überführen. Decke in einem gezielten Interview Entscheidungen auf, deren Fehlen andernfalls zum falschen Produkt oder zu unpassenden Funktionen führen könnte.

Dieser Skill ist für neue Projekte, frühe Produktkonzepte oder bestehende Projekte mit noch unklarem Zweck und Umfang bestimmt. Nutze für eine klar definierte Funktion in einem etablierten Projekt stattdessen `$spec-driven-development`.

## Einstieg und Reihenfolge

`$init` ist der Einstieg für die Projektinitialisierung und koordiniert die folgenden Schritte. Beachte zunächst `AGENTS.md` und verbindliche Projektanweisungen sowie den Git-Workflow nach der Installation. `$idea-refine` ist für die Ideenschärfung zuständig; `$init` wiederholt sie danach nicht. Wenn bereits eine `.codex/PROJECT.md` existiert, darf sie gelesen werden, um eine bereits abgeschlossene Ideenschärfung und bestätigte Entscheidungen festzustellen. Ihre bloße Existenz belegt die Ideenschärfung nicht; lies sie vor Änderungen und bewahre vorhandene Inhalte.

Für die Auswahl passender Skills während und nach der Initialisierung beachte `.codex/rules/references/skill-auswahl.md`. Die Übersicht beschreibt auch den direkten Einstieg für spätere Aufgaben in bestehenden Projekten; sie begründet keine erneute Initialisierung und keine Pflicht, alle genannten Skills auszuführen.

1. Lies `.codex/IDEA.md` als ursprüngliche Projektbeschreibung und berücksichtige zusätzliche Angaben aus dem Gespräch. Fehlt sie oder enthält sie nur die leere Installationsvorlage, bitte den Nutzer um die Idee und halte sie in `.codex/IDEA.md` fest. Bewahre eine bereits ausgefüllte ursprüngliche Idee unverändert; frage nur fehlende wesentliche Angaben nach. Stelle genau eine Frage pro Gesprächsrunde und warte auf die Antwort.
2. Prüfe eine vorhandene `.codex/PROJECT.md` und die Angaben im Gespräch auf bereits abgeschlossene Ideenschärfung und bestätigte Entscheidungen. Ziehe `$interview-me` nur heran, wenn Ziel, Zielgruppe, Erfolg oder wesentliche Grenzen weiterhin unklar sind. Übernimm bekannte Antworten und Entscheidungen; wiederhole keine geklärten Fragen. Das Interview klärt die Absicht, `$init` bleibt für den Gesamtprozess zuständig.
3. Wenn die Ideenschärfung noch nicht abgeschlossen ist, nutze `$idea-refine` für `.codex/IDEA.md`: Problem, Zielgruppe, Lösungsrichtung, Annahmen und erster Umfang werden abgestimmt. `$idea-refine` erstellt danach die Ausarbeitung in `.codex/PROJECT.md` mit Verweis auf `.codex/IDEA.md`. Ist eine abgeschlossene Ideenschärfung bereits im Gespräch oder in Projektunterlagen nachvollziehbar, übernimm ihr Ergebnis und starte `$idea-refine` nicht erneut.
4. Lies nach der Ideenschärfung die `.codex/PROJECT.md`, vorhandene Projektdokumentation und relevante Repository-Struktur. Übernimm bereits geklärtes Problem, Zielgruppe und Lösungsrichtung; frage nur nach fehlenden Angaben für Produktvision, Designsystem, Backend und Feature-Map. Kläre konkrete Widersprüche, ohne eine erneute Ideenschärfung zu beginnen oder vorhandene Inhalte stillschweigend zu überschreiben.
5. Untersuche gegebenenfalls `docs/PRD.md`, `features/INDEX.md`, `docs/data-model.md`, `docs/app-shell.md` und `docs/design-system.md`. Wenn der kanonische Produktbrief bereits substanziell vollständig ist, initialisiere ihn nicht erneut und überschreibe ihn nicht. Liegt ein eindeutiger Folgeauftrag vor, informiere den Nutzer und fahre im autorisierten Umfang mit `$spec-driven-development` für die Funktion oder gezielte Aktualisierung fort. Ist die gewünschte Richtung tatsächlich unklar, frage nach und warte.
6. Ermittle die Projektsprache aus den Anweisungen und Unterlagen und verwende sie für Gespräch und Artefakte. Übersetze bei Bedarf Überschriften und Anleitungstexte eines englischen Scaffolds, ohne Dateinamen oder HTML-Kommentare zu ändern. Erstelle oder bearbeite kein `CLAUDE.md`. Ist die Sprache unklar, stelle eine Frage mit Empfehlung.

Die vom Installer in `.codex/IDEA.md` angelegte erste Beschreibung ist noch keine abgeschlossene Produktinitialisierung. Die durch `$idea-refine` erstellte `.codex/PROJECT.md` dokumentiert die konkretisierte Richtung und wird im weiteren Verlauf behutsam ergänzt.

## Das Erkundungsinterview

Führe das Interview, bis ein vollständiges gemeinsames Verständnis der Produktrichtung besteht. Beachte diese Regeln:

### Beende jede Interview- und Prüfrunde mit genau einer Frage – entscheidend

Dies ist die wichtigste Interaktionsregel dieses Skills. Während des Interviews und an jedem Prüfpunkt:

- Die letzte Zeile der Nachricht enthält genau eine klare Frage. Stelle Kontext, Empfehlungen und Zusammenfassungen davor. Ende nicht mit einer Aussage oder Statusmeldung.
- Stelle nur eine Frage. Bündele keine Teilfragen in der letzten Zeile.
- Stoppe nach der Frage und warte auf die Antwort des Nutzers. Arbeite nicht weiter, leite keine Antwort ab, aktualisiere keine Artefakte und beginne keine weitere Phase, bevor der Nutzer antwortet.
- Ist ein Arbeitsschritt abgeschlossen und die nächste Aktion unklar, stelle die eine Frage, die das weitere Vorgehen am besten bestimmt.

- Stelle genau eine Frage pro Gesprächsrunde. Bündele keine Fragen und lege keinen Fragebogen vor.
- Ergänze jede Frage um eine empfohlene Antwort, die der Nutzer bestätigen oder korrigieren kann. Kennzeichne sie als Empfehlung, nicht als vorausgesetzte Entscheidung.
- Folge dem Gespräch. Wähle die nächste Frage anhand der Antwort und relevanter offener Themen; arbeite kein festes Skript mechanisch ab.
- Untersuche nach Möglichkeit zuerst den Kontext. Nutze eine vorhandene `.codex/PROJECT.md`, um abgeschlossene Schärfung und bestehende Entscheidungen zu erkennen, und lies Projektdateien und Code, bevor du erneut fragst.
- Gib keine feste Fragenzahl vor. Fahre fort, solange eine offene Entscheidung Produktvision, Umfang oder Feature-Prioritäten wesentlich verändern könnte.
- Halte Fragen gezielt und wiederhole keine geklärten Informationen. Kennzeichne Fakten, Nutzerentscheidungen und Annahmen getrennt.
- Kennt der Nutzer eine Antwort nicht, biete eine konkrete empfohlene Vorgabe an, erläutere kurz ihre praktische Auswirkung und halte sie bis zur Bestätigung als Annahme fest.
- Übernimm Entscheidungen aus einem vollständigen Briefing oder einer bereits geschärften Projektbeschreibung und wiederhole weder abgeschlossene Schärfung noch geklärte Fragen. Frage nur wesentliche Lücken ab, einschließlich offener Backend-, Umgebungs-, Datenschutz- und Designsystementscheidungen. Sind keine wesentlichen Lücken offen, bereite die Artefakte vor und gehe ohne Füllfragen zum Prüfpunkt über.

Untersuche die für dieses Projekt relevanten Bereiche und passe Reihenfolge und Tiefe an die Antworten an:

- Problem, Zweck, Zielnutzer und Nutzen
- Zielplattform und Geräte; bei Apple-Apps unterstützte Plattformen und Mindestversionen, bei Web-Apps Browser und Ansichtsgrößen
- Hauptnutzerablauf, erste Nutzungserfahrung, wichtige Zustände und Nutzeraktionen
- Produktgrenzen, ausdrückliche Ausschlüsse und voraussichtlicher MVP-Umfang
- Bestehende Alternativen oder Wettbewerber und die beabsichtigte Abgrenzung des Produkts
- Mögliche Funktionen, relative Priorität, Abhängigkeiten und Reihenfolge
- Relevantes Geschäftsmodell, Integrationen, Daten, Datenschutz, Barrierefreiheit, Berechtigungen und Qualitätsziele
- Erfolgsmaße und relevante Grenzen wie Zeitplan, Budget und Teamkapazität
- Wichtige offene Fragen

Frage technische Implementierungsdetails erst ab, wenn Produktverhalten und Rahmenbedingungen ausreichend klar sind. Beeinflusst eine technische Bedingung Machbarkeit oder Produktrichtung wesentlich, stelle eine gezielte Frage und dokumentiere Antwort oder Annahme, ohne das Interview in einen Architekturplan umzuwandeln.

## Erforderliche Entscheidungen vor der Feature-Map

Kläre die folgenden Bereiche vor der Priorisierung von Funktionen. Untersuche zuerst das Projekt und übernimm bereits Getroffenes; frage nur offene Entscheidungen ab. Stelle eine Frage pro Runde mit empfohlener Antwort und warte vor dem Fortfahren auf die Antwort.

### Backend und Datenumgebung

Frage bei einer neuen App oder offener Backend-Wahl, ob ein gehostetes oder gemeinsames Backend, ein bestehendes Backend oder ausschließlich geräte- beziehungsweise browserlokaler Betrieb benötigt wird. Empfiehl passend zum Produkt: rein lokale Speicherung für ein tatsächliches Einzelnutzer-Offline-Werkzeug; das bestehende Projekt-Backend, sofern vorhanden; Supabase, NestJS mit PostgreSQL oder C# mit Microsoft SQL Server, wenn Nutzerkonten, gemeinsame Daten oder Projektarchitektur ein Server-Backend erfordern. Maßgeblich für das Backend ist die Projektbeschreibung. Nennt sie keines und ergibt es sich nicht aus der Codebasis, bitte den Nutzer vor Abschluss von Architektur oder Implementierungsplan ausdrücklich um die Auswahl. Leite kein Backend aus Referenzdiagrammen ab.

Kläre vor Erstellung eines Backends dessen Art und Hostingbedingungen. Frage den Entwickler vor einer Stack-Empfehlung nach fehlendem Serverbetriebssystem, Hosting, Datenbank oder anderen wesentlichen Bedingungen. NestJS kann auf unterstützten Plattformen mit Node.js laufen. Bevorzuge für C# Windows Server, vorzugsweise IIS; ASP.NET Core unterstützt auch Linux, bitte den Entwickler aber vor der Erstellung ausdrücklich um Bestätigung einer beabsichtigten C#/Linux-Kombination oder kläre andere widersprüchliche Vorgaben. Bewahre eine bereits ausdrückliche, konsistente Entscheidung. Empfiehl für eine NestJS- oder C#-API Swagger/OpenAPI mit visueller Swagger UI als Standard und frage nach einer ausdrücklichen Entscheidung, sofern noch nicht vereinbart. Dokumentiere Entscheidung, gegebenenfalls Verzichtsgrund und Alternative. Supabase oder SQLite allein benötigt weder eine Swagger-Entscheidung noch eine Implementierung; eine NestJS- oder C#-API mit SQLite benötigt weiterhin die API-Entscheidung. Schütze bereitgestellte UI und OpenAPI-Dokumente vor öffentlichem und unberechtigtem Zugriff.

Nutze `.codex/rules/templates/BACKEND-ENTSCHEIDUNG.md` oder eine vorhandene gleichwertige Entscheidungsdokumentation, um die ermittelten Entscheidungen festzuhalten und offene technische Details an die Planung zu übergeben. Stelle weiterhin jeweils nur eine Frage und erfinde keine technischen Entscheidungen oder implementiere Infrastruktur.

Wenn Supabase gewählt wird:

- Führe „Einrichtung der Supabase-Infrastruktur“ nicht als Produktfunktion auf. Projektinitialisierung, lokale Dienste, Client-Anbindung und Umgebungskonfiguration sind Einrichtungsarbeit, kein sichtbares Nutzerverhalten. Halte sie als Setup-Abhängigkeiten für `$verify-setup` fest und nicht in der nutzerseitigen Feature-Map.
- Sind Konten erforderlich, nimm eine tatsächliche Funktion **User Accounts & Authentication** mit nutzersichtbarer Registrierung und Anmeldung sowie der erforderlichen Grundlage für Nutzerdaten auf. Halte Profildaten und das Muster zur Trennung je Nutzer in `docs/data-model.md`, sofern vorhanden, oder in der technischen Übergabe fest; plane die Profilbereitstellung nach etabliertem Projektmuster. Funktionen mit nutzerbezogenen Daten hängen davon ab. Mache Authentifizierung nicht zur Voraussetzung, wenn das Produkt keine Konten benötigt.
- Übergib Planung von Supabase-Schema, Auth, RLS, Storage und Edge Function an `$backend-dev-supabase`; die Initialisierung erfasst Produktverhalten und Feature-Abhängigkeiten, entwirft aber kein detailliertes SQL und implementiert kein Backend-Setup.
- Stelle vor Abschluss der Feature-Map eine Frage zur Umgebungsstrategie: lokale Entwicklung mit Supabase CLI und unterstützter Laufzeit; getrennte gehostete Entwicklungs- und Produktionsprojekte; ein einzelnes gehostetes Projekt; oder Supabase Branching-/Preview-Umgebungen, sofern aktuell verfügbar und geeignet. Empfiehl lokale Entwicklung, wenn Rechner und Arbeitsweise sie unterstützen, andernfalls getrennte Entwicklungs- und Produktionsprojekte. Erkläre, dass bei einem einzelnen gehosteten Projekt Test- und Livedaten dasselbe Projekt nutzen. Nenne keine Tarifanforderungen oder Preise ohne Prüfung aktueller offizieller Dokumentation.
- Dokumentiere die Strategie eindeutig in den Projektbrief-/PRD-Rahmenbedingungen, etwa `Environment strategy: local`, `two-projects`, `single` oder `branching`, einschließlich der Folgen für Test- und Produktionsdaten.
- Ist ein gehostetes Projekt geplant, kläre dessen Datenregion vor Freigabe der Feature-Map. Frage einmal nach, wenn sie noch nicht festgelegt ist. Empfiehl eine genaue Region anhand der Nutzer und vertraglicher Anforderungen an den Datenstandort; Frankfurt (`eu-central-1`) ist bei gewünschtem deutschem oder EU-Datenstandort geeignet. Behaupte nicht, die DSGVO verlange diese Region oder ihre Wahl belege Konformität. Dokumentiere die tatsächliche Nutzerentscheidung. Behandle einen Regionswechsel als folgenreiche Migrationsentscheidung und prüfe vor der Einrichtung aktuelle Anbieterhinweise.

Ziehe für diese Entscheidungen die aktuellen Hinweise zu [lokaler Entwicklung mit Supabase](https://supabase.com/docs/guides/local-development), [Deployment und Branching](https://supabase.com/docs/guides/deployment) und [verfügbaren Regionen](https://supabase.com/docs/guides/platform/regions) hinzu. Supabase dokumentiert, dass ein Regionswechsel ein neues Projekt und eine Migration erfordert; prüfe bei der Erläuterung dieser Entscheidung das aktuelle [Verfahren zum Regionswechsel](https://supabase.com/kb/troubleshooting/change-project-region-eWJo5Z). Die Regionswahl bestimmt den Datenstandort und belegt für sich genommen keine DSGVO-Konformität.

Wenn NestJS mit PostgreSQL gewählt wird:

- Führe „Einrichtung der NestJS/PostgreSQL-Infrastruktur“ nicht als nutzerseitige Produktfunktion auf. Halte API- und Datenbankbereitstellung, lokale Dienste, Konfiguration und Migrationen als Setup-Abhängigkeiten für `$verify-setup` und `$backend-dev-nestjs-postgres` fest.
- Übergib API-Module, DTO-Validierung, Authentifizierung und Autorisierung, Datenbankschema und Migrationen sowie Backend-Verifikation an `$backend-dev-nestjs-postgres`.
- Wende die vereinbarte Swagger/OpenAPI-Entscheidung an. Werden Swagger UI und OpenAPI-Dokumentendpunkt bereitgestellt, müssen sie geschützt und nicht öffentlich erreichbar sein; halte autorisierten Zugangsweg und Produktionsverhalten in der technischen Übergabe fest.
- Dokumentiere die gewählte Datenbankstrategie für lokale, Entwicklungs-, Staging- und Produktionsumgebungen im Projektbrief oder der technischen Übergabe. Setze kein Produktionsziel voraus und lege keine Datenbankzugangsdaten offen.

Wenn C# mit Microsoft SQL Server gewählt wird:

- Führe „Einrichtung von C#-Backend/SQL Server“ nicht als nutzerseitige Produktfunktion auf. Halte .NET API, SQL Server, lokale Konfiguration und Migrations-Workflow als Setup-Abhängigkeiten für `$verify-setup` und `$backend-dev-csharp-sqlserver` fest.
- Übergib API-Struktur, SQL-Server-Schema und Datenzugriff, Migrationen, Authentifizierung und Autorisierung, die vereinbarte Swagger/OpenAPI-Wahl und Backend-Verifikation an `$backend-dev-csharp-sqlserver`.
- Dokumentiere Zielversion von .NET, SQL-Server-Umgebung und Hostingmodell, etwa Windows Server/IIS, in der technischen Übergabe. Setze keine Windows-Authentifizierung, kein Azure-Hosting und keine Produktionszugangsdaten voraus.

### Lokale und offline verfügbare Daten

Sind Offline-Nutzung, lokale Kopien oder Local-First-Verhalten eine Produktanforderung, kläre Speicherort und Datenhoheit, statt automatische Synchronisierung lokaler Speicherung anzunehmen:

- Berücksichtige für native Apple-Apps einen app-internen SQLite-Speicher, wenn dauerhafte gerätelokale Daten oder Weiterarbeit ohne Verbindung benötigt werden.
- Unterscheide bei Web-Apps SQLite auf dem Server hinter einer API von SQLite/WASM im Browser. Serverspeicher kann gemeinsame Datensätze über die API bereitstellen; Browserspeicher ist lokal zur Browser-Origin beziehungsweise zum Profil.
- Frage, ob lokale Daten Cache, Offline-Arbeitskopie oder führender Bestand sind, ob Änderungen zu einem Server oder anderen Geräten synchronisiert werden und was Nutzer bei Konflikten, Abmeldung, Speicherverlust oder Kontingentfehlern erleben sollen.
- Übergib SQLite-Schemata, Migrationen, Persistenz und Synchronisierungsdesign an `$backend-dev-sqlite-data`. Ergänze bidirektionale Synchronisierung nur, wenn das Produkt sie benötigt und Datenhoheit und Konfliktverhalten vereinbart sind.

Ist die App tatsächlich rein frontend- beziehungsweise lokalseitig, halte `No backend — local-only storage` in den Projektrahmenbedingungen fest, ergänze keine Infrastrukturfunktion und überspringe Fragen zur Backend-Umgebungsstrategie.

### Datenschutzansatz

Verarbeitet das Produkt personenbezogene Daten, frage vor Erstellung der Feature-Map nach dem bevorzugten Schwerpunkt der Umsetzung:

- **Lean:** ein kleines MVP mit wenigen personenbezogenen Daten und geringem Risiko.
- **Standard (empfohlen):** ein öffentlich zugängliches Produkt mit Konten und gewöhnlichen personenbezogenen Daten.
- **Strict:** sensible Daten oder Daten von Kindern, Beschäftigtendaten, regulierte oder Unternehmenskontexte oder ein Wunsch nach erhöhten Schutzmaßnahmen.

Erkläre, dass diese Wahl Aufmerksamkeit und Dokumentation im Projekt eingrenzt, jedoch niemals rechtliche Pflichten reduziert. Halte `Data protection stance: lean | standard | strict` fest und kennzeichne früh besondere Kategorien oder Daten von Kindern, gegebenenfalls einschließlich Gesundheits-, biometrischer, ethnischer, religiöser oder die sexuelle Orientierung betreffender Daten. Nutze `$dsgvo` für relevante Anforderungen. Triff keine rechtlichen Feststellungen und leite keine Rechtsgrundlage ab.

Sind keine personenbezogenen Daten betroffen, halte diese Einschätzung kurz fest und überspringe die Frage zum Datenschutzansatz.

### Designsystem

Prüfe zuerst bestehende Design-Tokens, Markenvorgaben, Komponentenbibliotheken, Screenshots und UI-Referenzen. Ist ein nutzbares Designsystem vorhanden, folge ihm und bitte den Nutzer nicht, es erneut zu beschreiben. Frage andernfalls, ob ein Designsystem, Markenleitfaden oder eine UI-Referenz vorliegt; der Nutzer kann eine Datei oder einen Link teilen, die Referenz beschreiben oder angeben, dass keine vorhanden ist. Empfiehl, vorhandene Referenzen auch unvollständig zu teilen. Existiert keine, stelle eine gezielte Anschlussfrage zum visuellen Charakter mit einer Empfehlung anhand von Produkt und Nutzern.

Kläre die Designsystemrichtung und prüfe das vorgeschlagene Artefakt vor Erstellung der Feature-Map. Wird ein bestehendes System wiederverwendet, dokumentiere dessen Quelle und relevante Konventionen; wird eines vorgeschlagen, stelle es an einem Prüfpunkt vor, ende mit genau einer Frage und warte vor dem Fortfahren auf Zustimmung.

Erstelle oder aktualisiere in beiden Fällen `docs/design-system.md`. Verwende konkrete, implementierbare Tokens statt bloßer Adjektive:

- Primär-, Sekundär-, Akzent-, destruktive, Hintergrund- und Vordergrundfarben für helle und dunkle Themes
- Zurückhaltende Markenfarbvarianten für dezente Hintergründe sowie Hover- und aktive Zustände statt einer einzigen flachen Farbe auf großen Flächen
- Schriftfamilie, Typografieskala und Schriftgewichte für Überschriften und Fließtext
- Konventionen für Radius, Abstandsrhythmus und Erhebung beziehungsweise Rahmen
- Komponentenregeln wie Schaltflächenvarianten und -größen, Formularfeldgrößen sowie Lade- und Leerzustände
- Zutreffende Hover-, Fokus-, gedrückte und deaktivierte Zustände

Verwende, sofern bekannt, konkrete Werte im Token-Format des Ziel-Stacks. Sofern bestehendes System oder ausdrückliche Produktanforderung nichts anderes vorgeben, definiere helle und dunkle Tokens, vermeide reines Schwarz oder Weiß auf großen Flächen, verwende ein konsistentes Radius- und Abstandssystem und stelle sichtbare Fokuszustände für Tastatureingaben bereit. Prüfe Textkontrast anhand des zutreffenden Barrierefreiheitsstandards; wende nicht denselben Kontrastschwellenwert auf jede Textgröße oder UI-Komponente an.

## Abschlusskriterien

Die Erkundung ist abgeschlossen, wenn Nutzer und Agent ein übereinstimmendes Verständnis folgender Punkte haben:

- Wem das Produkt dient, welches Problem es löst und welchen Nutzen es bieten soll
- Zielplattformen und wichtige Rahmenbedingungen
- Hauptnutzerablauf und erwartete Ergebnisse
- Umfang des ersten nutzbaren Releases und ausdrücklich verschobene oder ausgeschlossene Punkte
- Priorisierte Feature-Map mit ausreichendem Kontext für Reihenfolge und Abhängigkeiten
- Backend- und Test-/Live-Umgebungsrichtung, soweit relevant
- Konkreter Designsystemvorschlag oder ein zur Wiederverwendung bestimmtes bestehendes System
- Erfolgssignale sowie offene Fragen oder Annahmen und ihre Auswirkungen

Das PRD ist ein knappes Entscheidungsdokument auf Produktebene, kein Interviewprotokoll und kein technisches Architekturdokument. Es beschreibt, welches Problem das Produkt für wen löst, was das erste Release leisten soll und wie Erfolg erkennbar ist. Vier Elemente stehen im Mittelpunkt:

- **Vision:** Produktzweck, behandeltes Problem und beabsichtigter Nutzen.
- **Zielnutzer:** primäre Zielgruppe und gegebenenfalls unterschiedliche sekundäre Zielgruppen mit ihren relevanten Bedürfnissen.
- **Kernfunktionen:** die wenigen Fähigkeiten, die für die Vision erforderlich sind. Gib Produktanforderungen klare Prioritäten und, soweit hilfreich, beobachtbare Abnahmekriterien. Halte umfassendere Priorisierungsbegründungen, Abhängigkeiten und Roadmap-Gruppierung in der separaten Feature-Map.
- **Kritische Erfolgsfaktoren:** Bedingungen für den Produkterfolg einschließlich beobachtbarer Erfolgsmaße, soweit definierbar. Unterscheide messbare Indikatoren von Annahmen; stelle Vermutungen nicht als validierte Ziele dar.

Ergänze knappe Abschnitte, wenn sie Produktentscheidungen wesentlich klären oder die Beurteilung des ersten Releases unterstützen: Zusammenfassung und Status, Produktverantwortung, Problemdetails, Zielnutzerbedürfnisse, Alternativen und Abgrenzung, Geschäftsmodell oder Monetarisierung, Ein- und Ausschlüsse, wichtige Nutzerabläufe, nutzersichtbare Daten- und Integrationsbedarfe, funktionale Anforderungen mit IDs, Prioritäten und Abnahmekriterien sowie **nichtfunktionale Anforderungen** wie Barrierefreiheit, Nutzbarkeit, Leistung, Zuverlässigkeit, Sicherheit, Datenschutz und unterstützte Geräte oder Browser. Formuliere nichtfunktionale Anforderungen möglichst beobachtbar oder messbar und ergänze bei Bedarf Abnahmekriterien. Nimm relevante Annahmen, offene Fragen, Risiken und Release- oder Freigabekriterien auf. Passe Abschnitte an das Produkt an; fülle Vorlagen nicht mechanisch und erfinde keine Details. Kennzeichne irrelevante Abschnitte ausdrücklich oder lasse sie weg. Halte Plattform und Bedingungen kurz. Bei personenbezogenen Daten erfasse im PRD nur Bedarf und Grenzen auf Produktebene; nutze `$dsgvo` für vertiefte Datenschutzanalyse und Anforderungen und verlinke relevante Ergebnisse, wenn hilfreich. Beschreibe benötigte Produktergebnisse für Daten und Integrationen; technische Architektur, Implementierungsentscheidungen, Datenbankschemata und Entwicklungspläne gehören in technische Spec und Implementierungsplan. Vermeide lange doppelte Anforderungen in PRD und Feature-Map: Das PRD beschreibt nutzersichtbare Anforderungen, die Feature-Map ordnet Priorität, Begründung und Abhängigkeiten.

Bleibt eine Entscheidung offen, verhindert aber keine brauchbare Produktrichtung, dokumentiere sie und ihre Auswirkung, statt das Interview unbegrenzt zu verlängern. Ist eine Entscheidung mit hoher Auswirkung ungeklärt, stelle als Nächstes die einzelne Frage, die diese Unsicherheit am besten reduziert.

## Artefakte

Erstelle oder aktualisiere nach dem Interview diese Markdown-Artefakte in der Arbeitssprache des Projekts. Kläre und prüfe das Designsystem vor dem Entwurf der endgültigen Feature-Map:

1. Produktvision/PRD – nutze eine vorhandene `docs/PRD.md`, wenn sie Teil des Projektgerüsts ist; aktualisiere andernfalls `.codex/PROJECT.md`. Halte das Dokument knapp und konzentriere es auf **Vision**, **Zielnutzer**, **Kernfunktionen** und **kritische Erfolgsfaktoren**. Ergänze zutreffende Abschnitte auf Produktebene zu Problem, Alternativen und Abgrenzung, Geschäftsmodell, Umfang des ersten Releases, Nutzerabläufen, nutzersichtbarem Daten- und Integrationsbedarf, priorisierten funktionalen Anforderungen mit beobachtbaren Abnahmekriterien sowie nichtfunktionalen Anforderungen, etwa Barrierefreiheit, Nutzbarkeit, Leistung, Zuverlässigkeit, Sicherheit, Datenschutz und unterstützten Geräten oder Browsern. Formuliere Qualitätsergebnisse möglichst prüfbar. Nutze bei personenbezogenen Daten `$dsgvo` für vertiefte Datenschutzanalyse und verlinke oder referenziere relevante Ergebnisse; halte das PRD auf Produktbedarf und -bedingungen ausgerichtet. Nimm gegebenenfalls Annahmen, offene Fragen, Risiken und Release-Kriterien auf. Passe die Tiefe dem Projekt an und lasse irrelevante Abschnitte weg, statt Inhalte zu erfinden. Das PRD beschreibt Produktverhalten und Erfolg, nicht technische Architektur; umfassendere Feature-Priorisierung und Abhängigkeiten gehören in die separate Feature-Map, technische Entscheidungen und Schemata in technische Spec und Implementierungsplan.
2. `docs/design-system.md` – erstelle oder aktualisiere eine konkrete Designrichtung anhand des bestehenden Systems des Nutzers oder des während der Erkundung vereinbarten Vorschlags. Stelle einen neuen Vorschlag zur Prüfung vor, bevor du mit der Feature-Map fortfährst.
3. Feature-Map – nutze eine vorhandene `features/INDEX.md`, wenn sie Teil des Projektgerüsts ist; aktualisiere andernfalls `.codex/FEATURE-MAP.md`. Gruppiere Funktionen nach Priorität, üblicherweise **MVP**, **Next** und **Later / Out of scope**. Nenne je Funktion das Nutzerergebnis, die Prioritätsbegründung und wesentliche Abhängigkeiten oder offene Entscheidungen. Nimm Setup-Infrastruktur nicht als nutzersichtbare Funktion auf.

Untersuche zuerst vorhandene Dateien und Konventionen. Bewahre nicht zugehörige Projektinhalte; lies und aktualisiere bereits vorhandene Zielartefakte, ohne bestehende Entscheidungen zu verwerfen. Überschreibe vom Nutzer erstellte Inhalte nicht stillschweigend.

Enthält das Projektgerüst `docs/data-model.md` oder `docs/app-shell.md`, bewahre Dateinamen und HTML-Kommentare. Übersetze beim Ausfüllen eines englischen Gerüsts für ein Projekt mit anderer Arbeitssprache dessen Überschriften und Anleitungstexte. Schreibe nur Datenmodell- oder App-Shell-Details, die durch vereinbarte Anforderungen gedeckt sind; erfinde während der Produkterkundung keine Schema- oder Implementierungsentscheidungen.

Lege die entstandene Produktvision, das freigegebene Designsystem und die Feature-Map dem Nutzer zur Prüfung vor. Diese Artefakte beschreiben Produktabsicht und Prioritäten; sie sind keine Implementierungs-Spec und kein technischer Plan.

Fasse am abschließenden Prüfpunkt Produktvision, Designsystemrichtung und Feature-Priorisierung zusammen und ende mit genau einer Bestätigungsfrage, etwa: „Stimmen Produktvision, Designrichtung und Feature-Priorisierung für dich?“ Stoppe und warte. Wünscht der Nutzer Änderungen, aktualisiere die Artefakte und lege sie erneut zur Prüfung vor; ende jedes Mal mit einer Frage. Übergib erst an die Implementierungsplanung, wenn der Nutzer die Richtung bestätigt.

## Übergabe

Schreibe im Rahmen dieser Initialisierung keinen Anwendungsimplementierungscode, erstelle kein Projektgerüst und führe keine Codegeneratoren aus. Nachdem der Nutzer die Produktrichtung bestätigt hat, übergib für eine konkrete Feature- oder Meilenstein-Spec an `$spec-driven-development` und anschließend zur Implementierungsplanung an `$feature-planning`. Plattform-Skills können ausgewählt werden, sobald Zielplattform und Stack bekannt sind.
