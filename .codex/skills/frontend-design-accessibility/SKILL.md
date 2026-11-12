---
name: frontend-design-accessibility
description: Design or review user interfaces in native Apple and web apps for responsive behavior, accessibility, and consistency with the project's established visual and interaction patterns.
---

# Frontend Design and Accessibility

Use this skill when creating or reviewing app UI, interaction patterns, or accessibility. It covers SwiftUI and browser-based interfaces; it does not prescribe a visual brand or replace the platform's native conventions.

## Inspect before designing

1. Read project instructions, `.codex/PROJECT.md`, `docs/design-system.md` if present, relevant Specs, and existing design or accessibility guidance.
2. Inspect nearby screens and components, design tokens, typography, spacing, navigation, and interaction patterns. Reuse them where suitable.
3. Identify the target platform, supported devices or viewports, input methods, and accessibility needs from the project and Spec. Ask only when a missing decision would materially change the interface.

## Design and review

For the affected screens and flows, check the relevant areas:

- layouts adapt to supported screen sizes and content lengths
- visual hierarchy, spacing, typography, color, and interaction states are consistent with the product
- web UI uses semantic HTML and meaningful headings, labels, and landmarks
- keyboard users can reach and operate controls, and focus is visible and predictable
- screen readers receive useful names, roles, values, and state changes
- text and controls have sufficient contrast; text scaling and zoom remain usable
- loading, empty, validation, success, and error states are understandable
- native Apple UI respects platform interaction conventions, Dynamic Type, VoiceOver, and relevant focus/input behavior

Report concrete findings by screen or component and connect them to user impact. Make focused changes that fit the existing design system; avoid unsolicited restyling or introducing a new component library.

Use `$ui-verification` to choose and record hands-on UI checks when the task includes verification.
