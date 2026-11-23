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
   - Header: `<type>[optional scope][optional !]: <short imperative summary>`. Put the scope in parentheses and place `!` before the colon for a breaking change.
   - Body (optional): short bullet points explaining what changed or why
   - Footer (optional): `BREAKING CHANGE: ...` or issue/reference notes
2. Pick a standard type such as `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, or `ci`.
3. Write the summary in lowercase imperative mood (such as `add` or `fix`) with no trailing period.
4. Keep explanations simple and use bulleted lists rather than long paragraphs.

## Gotchas

- Vague or past-tense summaries: Avoid `fix stuff` or `updated docs`. Use `fix(api): reject expired tokens` or `docs(readme): add local setup steps`.
- Bloated bodies: Keep bullet points brief and factual.

## Scope

Draft the text for the requested commit or release notes. Create, amend, or publish it only when the user requests that action.

## Worked example

Input request — Draft a commit for the API change that removes the legacy token header and requires bearer tokens.

```text
feat(api)!: require bearer tokens

- Remove support for the legacy X-Token header.

BREAKING CHANGE: Clients must send Authorization: Bearer <token>.
```

For release notes, group changes by user impact and lead with any required migration. For the same change, write “API clients must now send a bearer token in the Authorization header. Replace the X-Token header before upgrading.”
