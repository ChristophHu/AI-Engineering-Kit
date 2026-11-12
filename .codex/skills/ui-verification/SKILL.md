---
name: ui-verification
description: Select and perform UI and feature checks for native Apple, Next.js, or Angular projects, then report evidence against acceptance criteria and disclose checks that were not run.
---

# UI Verification

Use this skill to verify a UI feature or release candidate. For a full implementation, use it after changes are complete. Read the Spec, Plan, project instructions, `docs/design-system.md` if present, and `.codex/rules/ARCHITECTURE.md` when present.

## Select checks from the project

1. Identify the platform, affected user flows, acceptance criteria, supported targets, and available test/build commands.
2. Inspect project scripts and existing tests before selecting commands. Preserve existing test strategy; do not add a separate platform-wide testing framework as part of verification.
3. Select a proportionate set of automated and hands-on checks from the relevant platform profile below. Add other checks only when the changed behavior warrants them.
4. For each check, record the command or procedure, environment, outcome, and acceptance criteria it supports. Distinguish executed checks from planned or unavailable checks.
5. Report failed checks, untested flows, known limitations, and relevant accessibility or security findings. Do not claim verification that was not performed. Use `.codex/rules/templates/VERIFICATION.md` when a durable record is useful.

## Native Apple / SwiftUI profile

Choose checks based on supported Apple platforms and deployment targets. For iPadOS, include adaptive layouts, resizing or multitasking, and keyboard/pointer behavior when affected. For macOS, include window, menu/command, keyboard, and pointer behavior when affected. Do not assume every app supports every platform.

- build the app or affected target for the configured destination
- run relevant unit or UI tests that already exist
- exercise the central flow in an appropriate simulator or on a device, when available
- inspect permission prompts and denial/retry behavior when affected
- inspect lifecycle, background/foreground, interruption, or restoration behavior when affected
- check VoiceOver, Dynamic Type, focus/input behavior, and other relevant accessibility behavior

Report the exact target and whether simulator/device checks were unavailable or not run.

## Web profile: Next.js or Angular

Choose checks based on the framework version, router, runtime, browser support, and project scripts:

- run the configured production build and relevant existing tests
- exercise central user flows in supported browsers and representative viewports when available
- cover loading, empty, validation, error, and recovery states affected by the change
- inspect keyboard interaction, focus, semantic structure, screen-reader names, contrast, and zoom/reflow as relevant
- inspect authentication, authorization, API boundaries, and handling of untrusted input when affected

Report which browsers and viewports were actually checked and identify checks not run.

## Acceptance summary

Map every acceptance criterion to evidence and a status: passed, failed, or open. A passing build alone does not establish that user-facing flows or accessibility behavior work.
