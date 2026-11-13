# AI Engineering Rules

1. **Arbeite vom gewünschten Ergebnis aus.** Formuliere Nutzen und beobachtbares Verhalten vor der technischen Lösung.
2. **Verknüpfe Kriterien und Nachweise.** Jedes Abnahmekriterium braucht einen passenden Implementierungs- oder Verifikationsnachweis.
3. **Trenne Fakten und Annahmen.** Erfinde keine Produktanforderungen. Markiere Annahmen und mache ihre Auswirkung sichtbar.
4. **Halte den Umfang eng.** Ändere nur, was zum Ziel gehört; nutze bestehende Muster und Abhängigkeiten.
5. **Aktualisiere Artefakte bei Richtungswechseln.** Wenn neue Erkenntnisse Scope, Verhalten oder technische Entscheidungen ändern, passe Spec und Plan an.
6. **Verifiziere risikogerecht.** Wähle Checks passend zur Änderung und zum Projekt. Berichte ehrlich, was ausgeführt wurde und was nicht.
7. **Behandle Fehlerfälle und Grenzen.** Berücksichtige relevante Randfälle, Rückwärtskompatibilität, Berechtigungen und Datenfolgen.
8. **Halte den Prozess leichtgewichtig.** Verwende so viel Dokumentation wie zur gemeinsamen Klarheit und späteren Nachvollziehbarkeit nötig ist.
9. **Keine stillen Seiteneffekte.** Externe Kommunikation, Veröffentlichung, destruktive Aktionen oder Änderungen außerhalb des Projekts nur bei entsprechender Autorisierung.
10. **Abschluss ist kriteriumsbezogen.** Fasse Änderungen, Verifikationsnachweise und offene Punkte zusammen.
11. **Delegiere klar abgegrenzte Arbeit.** Wenn Subagenten eingesetzt werden, gelten `.codex/rules/DELEGATION.md` und die passenden Profile unter `.codex/agents/`; die Hauptinstanz bleibt für Entscheidungen, Integration und Abschluss verantwortlich.
12. **Committe abgeschlossene Arbeit nachvollziehbar.** Nutze `.codex/skills/git/SKILL.md` für Git-Initialisierung, Staging und Commit-Zeitpunkt. Der erste Agent nach einer Kit-Installation führt den Git-Bootstrap und bei einem frischen Repository den Initial-Commit durch.
13. **Wähle Skills passend zur Aufgabe.** Nutze bei Bedarf `.codex/rules/references/skill-auswahl.md`; initialisiere ein bereits eingerichtetes Projekt nicht allein für spätere Entwicklungsaufgaben erneut.
