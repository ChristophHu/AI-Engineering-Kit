# EPIC: Qualitätsprüfung für Spec, Plan und Aufgaben

EPIC beschreibt die Kategorien Expressive, Precise, Interpretable und Compartmentalized mit zehn Dimensionen und 40 Praktiken. Quelle: Bruno Claudino et al., [The EPIC Framework for Spec-Driven Development, Version 1](https://arxiv.org/pdf/2610.07534v1). Die folgende Checkliste ist eine auf dieses Kit angepasste Anwendung, keine vorgeschriebene Reihenfolge des Originaldokuments. Die Studie berichtet beobachtete Zusammenhänge; daraus folgt kein Nachweis von Ursache und Wirkung.

## Autorenmodus

Berücksichtige die folgenden Dimensionen entsprechend Umfang und Risiko. Halte belegte Fakten, Annahmen und offene Entscheidungen unterscheidbar fest; kläre wesentliche Unklarheiten und nutze bei unwesentlichen Lücken begründete Annahmen. Bestehende Projektvorlagen und Kennungskonventionen haben Vorrang. Bei umfangreicheren Vorhaben sind stabile Kennungen wie `REQ-01` hilfreich; sie ersetzen keine verständlichen Kriterien.

| Dimension | Prüffragen |
|---|---|
| E1 Eindeutigkeit | Sind Begriffe, Verbindlichkeit, Geltungsbedingungen, Werte und Grenzen klar? Sind offene Entscheidungen sichtbar? |
| E2 Singularität | Sind unterscheidbare Anforderungen, Entscheidungen, Risiken und Sicherheits- oder Datenschutzeigenschaften einzeln erkennbar? Zusammengehörige Details dürfen zusammenbleiben. |
| E3 Überprüfbarkeit | Gibt es beobachtbare Ergebnisse, geeignete Prüfmethoden, relevante Szenarien und nachvollziehbare Abschlussbedingungen? |
| P1 Abhängigkeiten | Sind Voraussetzungen, Einschränkungen und betroffene Anforderungen oder Aufgaben erfasst? Wie werden Voraussetzungen und ihr Ausfall behandelt? |
| P2 Vollständigkeit | Sind für den vereinbarten Umfang Verhalten, Fehlerfälle, Qualitätsziele, relevante Lieferung und noch offene Punkte abgedeckt? |
| I1 Konformität | Sind die verwendete Vorlage, Struktur und gegebenenfalls stabile, eindeutige Kennungen erkennbar? |
| I2 Konsistenz | Stimmen Begriffe, Kennungen, Schnittstellen und Aussagen über Spec, Plan und Aufgaben hinweg überein? |
| I3 Verständlichkeit | Sind Problem, Kontext, Gliederung und Verweise für Lesende verständlich? |
| C1 Umfangsdisziplin | Beschreibt die Spec Produktverhalten und Grenzen getrennt von der Umsetzung? Verbindliche technische oder betriebliche Anforderungen bleiben in der Spec. |
| C2 Umsetzungsplanung | Sind technischer Kontext, Arbeitsergebnisse, Datenmodelle und Schnittstellen bei Bedarf im Plan beschrieben und mit Anforderungen verknüpft? |

## Review-Modus

1. Ermittle den vereinbarten Umfang, die maßgebliche Spec und vorhandene Planungs- und Aufgabenartefakte. Lies nur relevante Dokumente und erfinde keine fehlenden Entscheidungen.
2. Prüfe die anwendbaren Dimensionen anhand konkreter Textstellen. Unterscheide belegte Erfüllung, fehlende Informationen, offene Entscheidungen und nicht anwendbare Praktiken. Nicht anwendbar ist kein Mangel.
3. Prüfe, ob jede wesentliche Anforderung über Abnahmekriterien mit mindestens einem passenden Umsetzungsschritt und einer geplanten Prüfung verbunden ist. Falls Planung oder Umsetzung noch aussteht, kennzeichne den fehlenden Pfad als offene Übergabe, nicht als bereits fehlgeschlagenen Test. Reine Querschnitts- oder Verwaltungsaufgaben benötigen keine künstliche Anforderungszuordnung.
4. Berichte für jeden Befund Fundstelle, Auswirkung und konkrete Verbesserung. Trenne Hinweise auf bereits bestehende Widersprüche von neu eingeführten. Keine Befunde sind ein gültiges Ergebnis.
5. Prüfe bei der abschließenden Umsetzung tatsächliche Nachweise und Status nach `implementation-review`; eine geplante Prüfung oder Fertigmeldung allein ist kein bestandener Nachweis.

Auf ausdrücklichen Wunsch oder bei einem vereinbarten vertieften Review kann jede anwendbare Dimension anhand belegter Evidenz von 0 bis 3 eingeschätzt werden: 0 keine oder kaum, 1 teilweise, 2 überwiegend konsistente, 3 durchgehend konsistente Evidenz. Kennzeichne nicht anwendbare Dimensionen als „nicht anwendbar“ und bestrafe sie nicht. Gib Fundstellen und verbleibende Unsicherheit an; erfinde weder Evidenz noch eine automatische Freigabeschwelle. Ein Gesamtwert ist nicht erforderlich.

## Zuordnung ohne doppelte Statusführung

Eine kompakte Zuordnung kann in bestehenden Artefakten oder Verweisen stehen:

| Anforderung | Abnahmekriterium und Prüfmethode | Plan oder Entscheidung | Aufgabe | Tatsächlicher Status und Nachweis |
|---|---|---|---|
| `REQ-01` | Beobachtbares Ergebnis und vorgesehene Prüfung | Verweis auf maßgeblichen Plan | Vorhandene Aufgabe oder Planschritt | Offen, erfüllt oder nicht erfüllt; Nachweis verlinken |

Die Spec enthält das Was und Warum; `$feature-planning` und bei Bedarf `$planning-and-task-breakdown` führen denselben maßgeblichen Plan und dessen Aufgaben oder verlinken das vorhandene Aufgabensystem. `$implementation-review` dokumentiert tatsächliche Prüfungen und Abweichungen. Diese Tabelle ist optional und keine zweite Quelle für Aufgabenstatus.
