---
name: git-workflow
description: Initialize Git for a newly installed project, prepare safe commits, and decide when coherent work is ready to commit.
---

# Git Workflow

Use this skill for repository setup, staging, commit creation, and commit-history operations. Follow the project's existing Git conventions and the user's explicit instructions.

## First agent after `install.sh`

The first agent working in a project after the AI Engineering Kit installation must check Git state before other implementation work:

1. Inspect the target directory and its Git status. Determine the actual repository root with Git; a project folder can already be inside a parent repository.
2. If the project folder is already inside a repository, use that repository. Never create a nested `.git` directory in a subfolder. If the project folder is a repository root already, do not reinitialize it unnecessarily.
3. If the project folder is not inside any repository, initialize Git at the project root with `git init`.
4. Inspect `.gitignore` and the full candidate file list before staging. Ensure credentials, `.env` secrets, private keys/certificates, personal or production data, build outputs, caches, and local database files are not accidentally committed. Preserve examples such as `.env.example` when safe. Add only relevant ignore patterns if the project lacks them; do not overwrite an existing `.gitignore`.
5. Check Git identity is configured without exposing unrelated configuration or secrets. If author identity is missing, ask the user to configure it; do not invent or set a global identity.
6. For a fresh repository with no commit history, stage the intended project baseline, inspect the staged diff and names, and create the initial commit immediately once the content is safe. Use a concise message such as `chore: initialize project` unless the repository has another convention.
7. If an existing repository already has history, do not call its next commit an initial commit. Do not include unrelated staged or uncommitted changes in a bootstrap commit; leave them untouched and report the repository status.
8. Confirm the commit and resulting clean/remaining status. Do not push or publish the repository unless explicitly requested.

This bootstrap instruction is authorized for the first post-install agent by the project installation workflow. It does not authorize committing secrets, personal/production data, unrelated changes, or changes in another repository.

## When to commit during normal work

- Commit a complete, coherent unit of work after its applicable checks pass and the staged diff has been reviewed. A unit can be a feature slice, bug fix, documentation update, or other independently understandable change.
- Prefer a few focused commits over one commit mixing unrelated changes. Do not commit half-finished work, failed verification, generated noise, or changes whose requirements or safety impact remain unresolved.
- Before staging, inspect `git status`; before committing, inspect both staged paths and `git diff --cached`. Stage only files owned by the task. Do not use broad staging when the worktree contains unrelated or user-authored changes.
- Write a short imperative commit subject that explains the change. Follow established commit-message conventions if present; do not introduce a convention solely for one commit.
- Report the commit hash and subject when relevant, along with checks run and any uncommitted changes left untouched.

## History and remote-operation boundaries

- Do not amend, reset, rebase, force-push, delete branches, change remotes, or discard work unless the user explicitly requests that action.
- Do not push, publish, create a remote repository, or change hosting as an implicit consequence of a local commit.
- Preserve pre-existing staged/unstaged changes. If ownership or intent is unclear, avoid including them and ask only if their presence blocks the requested commit.
- If hooks or signing requirements prevent a commit, report the exact blocker. Do not bypass hooks/signing or rewrite Git identity to force success.
