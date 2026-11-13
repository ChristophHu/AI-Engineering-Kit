# Definition of Done

Die Definition of Done ergänzt die aufgabenspezifischen Abnahmekriterien um einen wiederverwendbaren Qualitätsmaßstab. Sie gilt für Aufgaben, Features und Releases; die jeweils anwendbaren Prüfungen richten sich nach Änderung, Projekt, Risiko und vorhandener Umgebung. `$planning-and-task-breakdown`, `$incremental-implementation` und `$shipping-and-launch` berücksichtigen diese Referenz.

## Für jede Aufgabe

- [ ] Umfang und Abnahmekriterien sind nachvollziehbar; jedes Kriterium ist mit Nachweis als erfüllt, nicht erfüllt oder offen ausgewiesen.
- [ ] Die Änderung ist auf den Auftrag begrenzt und relevante Risiken, Annahmen sowie offene Punkte sind benannt.
- [ ] Geeignete verfügbare Prüfungen wurden ausgewählt und ihre tatsächlichen Ergebnisse berichtet. Nicht ausgeführte erforderliche Prüfungen und ihre Auswirkungen sind offengelegt; sie dürfen nicht als bestanden dargestellt werden.
- [ ] Relevante Fehlerfälle, Sicherheit, Integration und Dokumentation sind berücksichtigt. Nicht zutreffende Punkte sind als solche erkennbar.

## Bei Bedarf nach Art der Änderung

- [ ] Bei Verhaltensänderungen sind passende Tests und, soweit für belastbare Verifikation erforderlich und verfügbar, Laufzeit- oder manuelle Prüfungen durchgeführt. Eine reine Dokumentationsänderung benötigt nicht automatisch einen Laufzeittest.
- [ ] Betroffene bestehende Tests, Build, Typprüfung, Formatierung und Linting sind passend zum Projekt und zur Änderung geprüft. Nicht verfügbare oder fehlgeschlagene erforderliche Prüfungen bleiben offen.
- [ ] Bei Schnittstellenänderungen sind Kompatibilität und relevante Dokumentation geprüft; bei Migrationen, Konfiguration oder Feature-Flags sind Auswirkungen berücksichtigt.
- [ ] Bei Daten, Authentifizierung oder externen Eingaben sind die einschlägigen Sicherheits- und Datenschutzanforderungen geprüft; bei neuen kritischen Pfaden ist angemessene Beobachtbarkeit berücksichtigt.
- [ ] Architekturentscheidungen und Nutzerverhalten sind dokumentiert, wenn ihre Änderung dies erfordert. Bei Bedarf `$documentation-and-adrs`, `$security-and-hardening` und `$observability-and-instrumentation` nutzen.

## Für Features und Releases

- [ ] Das Feature erfüllt die vereinbarten Integrations- und Abnahmekriterien; offene oder nicht überprüfte Kriterien sind kenntlich gemacht.
- [ ] Vor einem Release sind die anwendbaren Release-, Betriebs-, Sicherheits- und Rückfallkriterien sowie erforderliche Freigaben geklärt. `$shipping-and-launch` ergänzt diese Prüfungen.
- [ ] Ein menschliches Review oder eine Freigabe erfolgt, wenn Projektvorgaben, Auftrag oder Zielumgebung sie verlangen. Fehlende erforderliche Freigaben sind als offen zu melden.

Projektweit vereinbarte Qualitätsziele und verbindliche Prüfungen bleiben bestehen. Ausnahmen oder nicht verfügbare Prüfungen werden begründet und nicht stillschweigend als bestanden markiert.
