---
name: spec-driven-development
description: Klärt und dokumentiert Anforderungen als überprüfbare Spec, bevor mehrteilige oder unklare Änderungen geplant und umgesetzt werden.
---

# Spec-Driven Development

Nutze diesen Skill, wenn eine Aufgabe mehrere Komponenten betrifft, Anforderungen unklar sind oder eine nachvollziehbare Spec gebraucht wird. Bei einer kleinen eindeutigen Änderung genügt eine kompakte Spec in der Antwort.

1. Lies `.codex/rules/WORKFLOW.md`, `.codex/rules/RULES.md` und passende Projektanweisungen. Bei nativen Apple-Apps oder Web-Apps berücksichtige zusätzlich `.codex/rules/ARCHITECTURE.md`.
2. Untersuche relevante vorhandene Dateien und Konventionen, bevor du Anforderungen festschreibst.
3. Bei App-Arbeiten erfasse in der Spec: Problem und Nutzen (für wen, wozu), Ziel und Plattform (Geräte und Versionen), Nutzerablauf und Verhalten ab Startzustand, Umfang (In/Out), beobachtbare Abnahmekriterien sowie relevante Rahmenbedingungen zu Accessibility, Datenschutz, Berechtigungen, Daten und Integrationen. Markiere offene Fragen und Annahmen samt Auswirkungen; kennzeichne nicht relevante Punkte ausdrücklich.
4. Nutze `.codex/rules/templates/SPEC.md` als Vorlage, sofern das Projekt keine eigene Spec-Vorlage nutzt.
5. Löse wesentliche Mehrdeutigkeiten mit gezielten Fragen. Für unwesentliche Lücken triff eine begründete, sichtbare Annahme und arbeite weiter.
6. Bei nativen Apple-Apps und Web-Apps erfasse die relevanten Spec-Vorgaben aus `.codex/rules/ARCHITECTURE.md`: Plattform und Nutzer, Abläufe und Zustände, Berechtigungen, Datenverarbeitung, Integrationen, Accessibility und Qualitätsziele.
7. Prüfe, dass Kriterien beobachtbar und überprüfbar sind und die Spec das gewünschte Verhalten beschreibt. Halte technische Lösungsvorschläge getrennt, sofern sie nicht durch Constraints vorgegeben sind.
8. Bestimme nach Plattform und Stack, welche Entwicklungs-Skills für Planung und Umsetzung passen: `$swiftui-app-development`, `$nextjs-app-development` oder `$angular-app-development`. Bei UI-Arbeit kann `$frontend-design-accessibility` ergänzen; für UI- und Plattformverifikation nutze `$ui-verification`.
9. Wenn die Aufgabe personenbezogene Daten verarbeitet, nutze `$dsgvo-datenschutz`, um Datenflüsse, offene Datenschutzentscheidungen, technische Maßnahmen und passende Verifikation in Spec und Plan einzubeziehen.

Ergebnis: eine überprüfbare Spec und klar markierte offene Punkte. Beginne Implementierung erst, wenn sie zum Auftrag passt und notwendige Entscheidungen geklärt sind.
