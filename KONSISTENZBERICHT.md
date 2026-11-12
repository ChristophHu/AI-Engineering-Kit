# Konsistenzbericht: AI Engineering Kit

Stand: 12. November 2026. Untersucht wurden Installer, README, alle acht Agentenprofile, alle Regeln und Templates sowie die 17 lokalen Skills. Die Bewertung beruht auf dem Repository-Inhalt; die tatsächliche Registrierung der Agenten und die Ausführung in einem installierten Zielprojekt wurden nicht geprüft.

## Fehler und Unstimmigkeiten

1. **Hoch – Agentenregistrierung ist nicht belegt.** `.codex/agents/README.md` behauptet, Codex lade die Profile aus `.codex/agents/`; `install.sh` kopiert die TOML-Dateien, legt aber keine `.codex/config.toml` oder andere sichtbare Zuordnung der Rollen an. Es ist im Repository nicht dokumentiert, wie diese Profile tatsächlich als auswählbare Subagenten registriert werden. Die Dateien sind syntaktisch gültiges TOML; daraus folgt noch keine Laufzeitregistrierung. Registrierung mit der für das Zielsystem geltenden Codex-Dokumentation und einer tatsächlichen Installation prüfen.
2. **Hoch – Swagger ist teilweise optional formuliert.** `.codex/skills/backend-dev-nestjs-postgres/SKILL.md` und `.codex/skills/init/SKILL.md` verlangen Swagger nur, wenn API-Dokumentation im Scope ist; `.codex/skills/backend-dev-csharp-sqlserver/SKILL.md` formuliert sie abhängig von Projektanforderungen. Der Auftrag sieht Swagger für beide Backend-Alternativen vor. Die Schutzregeln für UI und Dokument sind dagegen konsistent. Die Anforderungen für neue und bestehende Projekte sollten eindeutig abgestimmt werden.
3. **Mittel – Installer ist nicht idempotent wie beschrieben.** `README.md` bezeichnet `install.sh` als idempotent; bei erneutem Aufruf brechen die Marker- und Verzeichnisprüfungen in `install.sh` ab. Das verhindert Überschreiben, ist aber kein erfolgreich wiederholbarer Installationslauf. Dokumentation oder gewünschtes Verhalten angleichen.
4. **Mittel – Backup kann überschrieben werden.** `install.sh` kopiert eine vorhandene `AGENTS.md` fest nach `AGENTS.md.bak`, ohne eine bereits vorhandene Sicherung zu prüfen. Ein neuer Installationslauf in einem Projekt mit vorhandener Sicherung kann diese ersetzen.
5. **Mittel – SQLite-Sidecars sind unvollständig ignoriert.** `.gitignore` enthält `*.sqlite-wal` und `*.sqlite-shm`, aber nicht die entsprechenden Endungen für die ebenfalls ignorierten `*.db` und `*.sqlite3` oder Rollback-Journale. Solche Dateien können beim Staging auftauchen. Die Repository-`.gitignore` wird außerdem vom Installer nicht in Zielprojekte kopiert; der Git-Skill ergänzt Muster nur bei Bedarf.
6. **Mittel – Backend-Auswahl wird unterschiedlich beschrieben.** `.codex/rules/ARCHITECTURE.md` nennt bei fehlender Backend-Angabe nur die drei Server-Stacks und verlangt eine Backend-Wahl. `init/SKILL.md` erlaubt ausdrücklich lokale Anwendungen ohne Backend; serverseitiges SQLite wird an anderer Stelle als Option beschrieben. Die Abfrage und Planvorgaben sollten lokale-only, bestehende Backends und SQLite hinter einer API ausdrücklich berücksichtigen.
7. **Mittel – Zwei Skill-Kopien ohne Synchronisationsregel.** Der Installer kopiert Skills sowohl nach `.codex/skills/` als auch nach `.agents/skills/` (`install.sh`, Kopierschleifen). Spätere Änderungen oder Umbenennungen an einer Kopie werden nicht übertragen; Wiederinstallation bricht ab. Dadurch können installierte Projekte veraltete und neue Skill-Namen parallel behalten. Ein Upgrade- und Abgleichverfahren fehlt.
8. **Niedrig – Verifikationsvorgaben unterscheiden sich.** `.codex/rules/WORKFLOW.md` sieht notwendige Prüfungen zur belastbaren Verifikation vor; `implementation-worker.toml` erlaubt nur vom Nutzer oder Plan explizit verlangte Verifikation, und `code-reviewer.toml` schließt Tests ohne ausdrückliche Anfrage aus. Diese Rollen können sinnvoll eingeschränkt sein, die Koordination muss dann zusätzliche notwendige Prüfungen ausdrücklich übernehmen oder beauftragen.
9. **Niedrig – Installationsfehler können Teilzustand hinterlassen.** `install.sh` legt `.agents/skills` vor Abschluss aller Konfliktprüfungen an und kopiert danach mehrere Verzeichnisse und Dateien ohne Rollback. Bei einem Fehler während des Kopierens kann eine unvollständige Installation bleiben, die ein erneuter Lauf wegen der Konfliktprüfungen zurückweist.

## Konsistente und geprüfte Aspekte

- Alle acht Agentenprofile sind syntaktisch gültiges TOML. Ihre referenzierten lokalen Skills existieren.
- Alle 17 Skill-Frontmatter-Namen stimmen mit ihren Ordnernamen überein; die im Repository gefundenen `$skill`-Verweise zeigen auf vorhandene lokale Skills.
- Die Profile und Delegationsregeln benennen alle vier Daten- und Backend-Spezialisten. Die Trennung von SQLite auf Gerät, im Browser und auf dem Server sowie die Notwendigkeit einer eigenen Synchronisierung sind dokumentiert.
- Geschützte Swagger-UI und geschütztes OpenAPI-Dokument werden in beiden Backend-Skills und Spezialistenprofilen verlangt, sofern die Dokumentation bereitgestellt wird.

## Grenzen

Es wurden keine Anwendungen gebaut, keine Agenten gestartet und keine tatsächliche Installation oder externen Dienste geprüft. Aussagen über die Wirksamkeit der Registrierung und das Laufzeitverhalten bleiben daher zu verifizieren.
