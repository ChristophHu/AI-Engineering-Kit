# Spec-Driven-Development Workflow

## Zweck

Anforderungen werden zuerst als überprüfbares gewünschtes Verhalten beschrieben. Planung, Implementierung und Verifikation bleiben nachvollziehbar mit dieser Absicht verbunden.

## Phasen

### 1. Specify

Erfasse Problem, betroffene Nutzer, gewünschten Nutzen, Kontext, In-Scope/Out-of-Scope, Einschränkungen, offene Fragen und testbare Abnahmekriterien. Trenne belegte Fakten von Annahmen. Kläre nur Fragen, deren Antwort die Lösung wesentlich verändern würde; arbeite bei geringfügigen Lücken mit ausdrücklich benannten Annahmen weiter.

**Ausgabe:** `SPEC.md` oder eine kompakte Spec im Aufgaben-/Planungsartefakt. Eine Spec beschreibt das Was und Warum, nicht vorschnell eine konkrete Implementierung.

### 2. Plan

Untersuche die vorhandene Architektur und Konventionen. Leite aus jedem Abnahmekriterium relevante Änderungen und Verifikationsschritte ab. Teile die Arbeit in kleine, logisch geordnete Schritte; notiere Abhängigkeiten, Risiken und betroffene Dateien, soweit bekannt. Plane keine unnötige Infrastruktur.

**Ausgabe:** `PLAN.md` mit Schritten, Verifikation und Rückverfolgbarkeit zu den Kriterien.

### 3. Implement

Setze den Plan inkrementell um. Nutze bestehende Muster und halte Änderungen im vereinbarten Umfang. Wenn Erkenntnisse Anforderungen oder Architektur verändern, aktualisiere Spec und Plan vor oder zusammen mit der Änderung. Berichte wesentliche Abweichungen und ihren Grund.

### 4. Verify

Prüfe jedes Abnahmekriterium anhand des Ergebnisses. Führe passende Tests, Builds, statische Prüfungen oder manuelle Checks aus, wenn sie zum Auftrag gehören oder für belastbare Verifikation nötig sind. Behaupte keine Prüfung, die nicht ausgeführt wurde. Melde offene Kriterien, Einschränkungen und relevante Risiken.

**Ausgabe:** `VERIFICATION.md` oder eine knappe Prüfübersicht mit Kriterium, Nachweis und Status.

## Übergabekriterien

- **Specify → Plan:** Ziel und Erfolg sind verständlich; wesentliche Unklarheiten sind aufgelöst oder als Annahmen markiert.
- **Plan → Implement:** Schritte sind ausführbar und decken die Abnahmekriterien ab.
- **Implement → Verify:** Änderungen sind fertiggestellt; Abweichungen sind dokumentiert.
- **Verify → Abschluss:** Jedes Kriterium ist erfüllt, nicht erfüllt oder ausdrücklich als offen ausgewiesen.

## Umfang passend wählen

- Triviale, lokale Änderung: Spec, Plan und Verifikation können als kurze Abschnitte in der Antwort geführt werden.
- Mehrteilige Funktion: eigene Spec und Plan im vom Projekt genutzten Planungsordner.
- Riskante oder architekturprägende Änderung: Unsicherheiten, Migration, Kompatibilität und Rückweg ausdrücklich festhalten.

Nutze vorhandene Projektordner und Vorlagen, falls vorhanden. Lege keine parallele Dokumentationsstruktur an, wenn das Repository bereits eine passende hat.
