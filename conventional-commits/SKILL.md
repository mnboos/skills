---
name: conventional-commits
description: Format git commit messages and changelogs using Conventional Commits with short bullet lists in plain language. Use when drafting commit messages, commit scopes, or release notes.
---

# conventional-commits

Format git commit messages using Conventional Commits with simple language and short bullet lists.

## When to Use

- Drafting git commit messages or choosing commit types and scopes.
- Summarizing code, doc, or config changes for a commit body.
- Writing release notes or changelogs from commits.

## Steps

1. Use this structure:
   - Header: `<type>(<optional-scope>): <short summary in imperative mood>`
   - Body (optional): short bullet points explaining what changed or why
   - Footer (optional): `BREAKING CHANGE: ...` or issue/reference notes
2. Pick a standard type such as `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, or `ci`.
3. Write the summary in lowercase imperative mood (such as `add` or `fix`) with no trailing period.
4. Keep explanations simple and use bulleted lists rather than long paragraphs.

## Gotchas

- Vague or past-tense summaries: Avoid `fix stuff` or `updated docs`. Use `fix(api): reject expired tokens` or `docs(readme): add local setup steps`.
- Bloated bodies: Keep bullet points brief and factual.