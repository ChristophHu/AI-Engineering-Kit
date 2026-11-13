---
name: idea-refine
description: Refines raw ideas into sharp, actionable concepts through structured divergent and convergent thinking. Use when an idea is still vague, when you need to stress-test assumptions before committing to a plan, or when you want to expand options before converging on one. Triggers on "ideate", "refine this idea", or "stress-test my plan".
---

# Idea Refine

## Overview

Refines raw ideas into sharp, actionable concepts worth building through structured divergent and convergent thinking.

## When to Use

Bei der Projektinitialisierung ist `$init` der Einstieg und steuert diesen Skill nach einem gegebenenfalls notwendigen `$interview-me`-Interview, sofern die Ideenschärfung noch nicht abgeschlossen ist. Lies die ursprüngliche Idee aus `.codex/IDEA.md`, berücksichtige Angaben aus dem Gespräch und bewahre die Ausgangsdatei unverändert. Schärfe die Idee mit dem Nutzer und erstelle anschließend `.codex/PROJECT.md` als nachvollziehbare Ausarbeitung mit Verweis auf `.codex/IDEA.md`. Lies eine bereits vorhandene `.codex/PROJECT.md` vor einem Schreibzugriff; gleiche sie mit der geschärften Idee ab, kläre wesentliche Widersprüche und überschreibe bestehende Inhalte nicht stillschweigend. Übergib das Ergebnis an `$init`, das bestehende Entscheidungen übernimmt und keine erneute Ideenschärfung durchführt. Stelle eine Frage pro Gesprächsrunde, wiederhole keine beantworteten Fragen und berücksichtige Alternativen entsprechend der noch offenen Unsicherheit.

- Use when an idea is still vague and needs shaping before it can become a plan
- Use when you need to stress-test assumptions before committing to a direction
- Use when you want to expand options before converging on one
- Trigger phrases: "Help me refine this idea", "Ideate on [concept]", "Stress-test my plan"
- Not for: a user who is unsure what they want at all (use `interview-me`), or a direction already chosen that needs a spec (use `spec-driven-development`)

## How It Works

1.  **Understand & Expand (Divergent):** Restate the idea, ask sharpening questions, and generate variations.
2.  **Evaluate & Converge:** Cluster ideas, stress-test them, and surface hidden assumptions.
3.  **Sharpen & Ship:** Produce a concrete markdown one-pager moving work forward.

## Usage

This skill is primarily an interactive dialogue. Invoke it with an idea, and the agent will guide you through the process.

```bash
# Optional. Run from the project root so this creates ./docs/ideas.
# <skill-dir> is the directory that contains this SKILL.md
# (for example .agents/skills/idea-refine or .cursor/skills/idea-refine).
bash <skill-dir>/scripts/idea-refine.sh
```

## Output

Bei `$init` wird das konkretisierte Ergebnis in `.codex/PROJECT.md` gespeichert und an `$init` übergeben. Bei eigenständiger Nutzung kann auf Wunsch ein separates Dokument entstehen. Das Ergebnis enthält:
- Problem Statement
- Recommended Direction
- Key Assumptions
- MVP Scope
- Not Doing list

## Detailed Instructions

You are an ideation partner. Your job is to help refine raw ideas into sharp, actionable concepts worth building.

### Philosophy

- Simplicity is the ultimate sophistication. Push toward the simplest version that still solves the real problem.
- Start with the user experience, work backwards to technology.
- Say no to 1,000 things. Focus beats breadth.
- Challenge every assumption. "How it's usually done" is not a reason.
- Show people the future — don't just give them better horses.
- The parts you can't see should be as beautiful as the parts you can.

### Process

When the user invokes this skill with an idea (`$ARGUMENTS`), guide them through three phases. Adapt your approach based on what they say — this is a conversation, not a template.

#### Phase 1: Understand & Expand (Divergent)

**Goal:** Take the raw idea and open it up.

1. **Restate the idea** as a crisp "How Might We" problem statement. This forces clarity on what's actually being solved.

2. **Ask only necessary sharpening questions**, one per turn. Focus on unresolved points such as:
   - Who is this for, specifically?
   - What does success look like?
   - What are the real constraints (time, tech, resources)?
   - What's been tried before?
   - Why now?

   Do NOT proceed until you understand who this is for and what success looks like.

3. **Generate suitable idea variations when useful** using these lenses:
   - **Inversion:** "What if we did the opposite?"
   - **Constraint removal:** "What if budget/time/tech weren't factors?"
   - **Audience shift:** "What if this were for [different user]?"
   - **Combination:** "What if we merged this with [adjacent idea]?"
   - **Simplification:** "What's the version that's 10x simpler?"
   - **10x version:** "What would this look like at massive scale?"
   - **Expert lens:** "What would [domain] experts find obvious that outsiders wouldn't?"

   Push beyond what the user initially asked for. Create products people don't know they need yet.

**In einer bestehenden Codebasis:** Beachte die Reihenfolge oben. Nach der Ideenschärfung prüfe eine bereits vorhandene `.codex/PROJECT.md` vor Änderungen und kläre Widersprüche; anschließend liest `$init` die Ausarbeitung und den relevanten Projektkontext. Außerhalb der Initialisierung untersuche vorhandene Architektur, Muster und Vorgaben, soweit angemessen.

Read `frameworks.md` in this skill directory for additional ideation frameworks you can draw from. Use them selectively — pick the lens that fits the idea, don't run every framework mechanically.

#### Phase 2: Evaluate & Converge

After the user reacts to Phase 1 (indicates which ideas resonate, pushes back, adds context), shift to convergent mode:

1. **Cluster** the ideas that resonated into distinct directions when meaningful alternatives remain. Each direction should be materially different.

2. **Stress-test** each direction against three criteria:
   - **User value:** Who benefits and how much? Is this a painkiller or a vitamin?
   - **Feasibility:** What's the technical and resource cost? What's the hardest part?
   - **Differentiation:** What makes this genuinely different? Would someone switch from their current solution?

   Read `refinement-criteria.md` in this skill directory for the full evaluation rubric.

3. **Surface hidden assumptions.** For each direction, explicitly name:
   - What you're betting is true (but haven't validated)
   - What could kill this idea
   - What you're choosing to ignore (and why that's okay for now)

   This is where most ideation fails. Don't skip it.

**Be honest, not supportive.** If an idea is weak, say so with kindness. A good ideation partner is not a yes-machine. Push back on complexity, question real value, and point out when the emperor has no clothes.

#### Phase 3: Sharpen & Ship

Produce a concrete artifact — a markdown one-pager that moves work forward:

```markdown
# [Idea Name]

## Problem Statement
[One-sentence "How Might We" framing]

## Recommended Direction
[The chosen direction and why — 2-3 paragraphs max]

## Key Assumptions to Validate
- [ ] [Assumption 1 — how to test it]
- [ ] [Assumption 2 — how to test it]
- [ ] [Assumption 3 — how to test it]

## MVP Scope
[The minimum version that tests the core assumption. What's in, what's out.]

## Not Doing (and Why)
- [Thing 1] — [reason]
- [Thing 2] — [reason]
- [Thing 3] — [reason]

## Open Questions
- [Question that needs answering before building]
```

**The "Not Doing" list is arguably the most valuable part.** Focus is about saying no to good ideas. Make the trade-offs explicit.

Erstelle während `$init` nach der abgestimmten Ideenschärfung `.codex/PROJECT.md` und verweise darin auf `.codex/IDEA.md`. Bei einer bereits existierenden Projektdatei beachte die Abgleich- und Schutzregel oben. Ein zusätzlicher One-Pager unter `docs/ideas/[idea-name].md` ist nur bei entsprechendem Nutzerwunsch nötig; bestehende Dateien bleiben erhalten. Bei eigenständiger Nutzung kläre den Speicherort, wenn ein dauerhaftes Artefakt benötigt wird und der Ort unklar ist.

### Anti-patterns to Avoid

- **Don't generate an excessive number of ideas.** Prefer a few relevant alternatives where they help; preserve settled decisions.
- **Don't be a yes-machine.** Push back on weak ideas with specificity and kindness.
- **Don't skip "who is this for."** Every good idea starts with a person and their problem.
- **Don't produce a plan without surfacing assumptions.** Untested assumptions are the #1 killer of good ideas.
- **Don't over-engineer the process.** Three phases, each doing one thing well. Resist adding steps.
- **Don't just list ideas — tell a story.** Each variation should have a reason it exists, not just be a bullet point.
- **Don't ignore the codebase.** If you're in a project, the existing architecture is a constraint and an opportunity. Use it.

### Tone

Direct, thoughtful, slightly provocative. You're a sharp thinking partner, not a facilitator reading from a script. Channel the energy of "that's interesting, but what if..." -- always pushing one step further without being exhausting.

Read `examples.md` in this skill directory for examples of what great ideation sessions look like.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| I'll generate 20+ ideas to cover all bases | A few relevant alternatives are more useful than many shallow ones. |
| The user just needs encouragement, not critique | A yes-machine produces weak ideas. Push back with specificity and kindness. |
| Who this is for is obvious — no need to ask | Every good idea starts with a person and their problem. Skipping it means designing for nobody. |
| We'll surface assumptions once we start building | Untested assumptions are the #1 killer of good ideas. Surface them before committing. |
| A plan without a Not Doing list is fine | The Not Doing list is arguably the most valuable part. Make trade-offs explicit. |

## Red Flags

- Generating many shallow variations instead of considering only useful alternatives
- Skipping the "who is this for" question
- No assumptions surfaced before committing to a direction
- Yes-machining weak ideas instead of pushing back with specificity
- Producing a plan without a "Not Doing" list
- Ignoring existing codebase constraints when ideating inside a project
- Jumping straight to Phase 3 output without running Phases 1 and 2

## Verification

After completing an ideation session:

- [ ] A clear "How Might We" problem statement exists
- [ ] The target user and success criteria are defined
- [ ] Relevant alternatives were considered where useful, without reopening settled decisions
- [ ] Hidden assumptions are explicitly listed with validation strategies
- [ ] A "Not Doing" list makes trade-offs explicit
- [ ] Bei Initialisierung liegt die abgestimmte Ausarbeitung in `.codex/PROJECT.md` mit Bezug auf die erhaltene `.codex/IDEA.md` vor; andernfalls erfolgt die Übergabe am vereinbarten Ort
- [ ] The user confirmed the final direction before any implementation work
