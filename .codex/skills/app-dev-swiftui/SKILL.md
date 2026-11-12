---
name: app-dev-swiftui
description: Plan, implement, or review features in an existing native Apple app built with SwiftUI, following its supported platforms, deployment targets, and project conventions.
---

# SwiftUI App Development

Use this skill for native Apple app work when the project uses SwiftUI, including iOS, iPadOS, and macOS. Start with the approved Spec and Plan when available; for substantial work, use `$spec-driven-development` and `$feature-planning` first.

## Discover the project before changing it

1. Read project instructions, `.codex/PROJECT.md`, and `docs/design-system.md` if present.
2. Inspect the Xcode project or workspace, build configuration, package manifest, and relevant source and test files.
3. Identify supported Apple platforms (iOS, iPadOS, macOS, and any others in the project), deployment targets, Swift and SDK versions, app lifecycle, current navigation and state patterns, persistence, and existing Apple frameworks. Do not assume the app targets every Apple platform just because it uses SwiftUI.
4. Follow the codebase's conventions. Do not introduce a new architecture, dependency, framework, or minimum OS target merely because it is a common SwiftUI pattern.

## Plan and implement

For the feature at hand, consider the relevant areas:

- SwiftUI view composition, reusable components, and platform-appropriate interactions
- navigation, state ownership, and data flow using patterns already present in the app
- asynchronous work with Swift Concurrency, including actor isolation, cancellation, and lifecycle
- persistence and backend access
- local SQLite persistence, schema migrations, data protection, and offline synchronization when required; use `$backend-sqlite-data-development` for those concerns
- permissions, their user-facing purpose, and required usage descriptions
- app lifecycle, background behavior, and platform-specific system integration
- accessibility labels, focus, Dynamic Type, contrast, and relevant input modalities

Apply platform-specific behavior where relevant:

- **iPhone:** account for compact layouts, touch interaction, and the app's established navigation patterns.
- **iPad:** account for adaptive layouts, multitasking and resizing, keyboard and pointer input, and navigation suited to larger displays.
- **Mac:** account for window sizing and restoration, menus and commands, keyboard shortcuts, pointer interaction, and macOS navigation conventions.

These are review prompts, not mandatory features. Follow the product requirements and existing app conventions; do not add menus, multiwindow behavior, or platform support unless the project needs them.

Keep UI, application behavior, persistence, and service access aligned with existing boundaries. Update the Spec or Plan if implementation reveals a necessary behavior or architecture change.

## Hand off UI verification

For changed UI, use `$frontend-design-accessibility` for a focused quality review and `$ui-verification` to select and report the relevant checks. Include the actual deployment target and simulator/device availability in the verification plan; never claim a device or simulator check that was not run.
