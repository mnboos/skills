---
name: semantic-git-diff
description: Summarize uncommitted Git changes by intent, behavior, and risk. Use for requests like "summarize my changes," "what changed in this diff?", or "how should I split these changes into commits?" Dedicated bug reviews and security audits are outside this skill's scope.
---

# Semantic Git Diff Overview

## Workflow

### 1. Gather Context (If Missing)
Use a supplied diff for requests scoped to that diff. When the user asks about a local working tree you can access, gather the changes directly:
```bash
git status --short --untracked-files=all
git diff --cached
git diff
```

Read the staged and unstaged diffs together. Keep whitespace visible and inspect relevant untracked files listed by status. Avoid opening or quoting files likely to contain secrets when they are unnecessary for the summary.

If repository access is unavailable, ask for the missing output only if it would materially improve the answer. Ask the user to omit `.env` files and redact secrets or credentials before pasting. With partial evidence, state what you could inspect and which behavior remains unknown. A status listing alone only establishes which paths changed.

### 2. Group by Semantic Intent
Cluster related hunks across files into logical themes rather than listing files alphabetically:
* **Behavioral / Feature Changes:** New functionality, altered business rules, or changed user-facing behavior.
* **Bug Fixes & Edge Cases:** Corrections to faulty logic, error handling, or race conditions.
* **Refactors & Structural Moves:** Renamed symbols, extracted helpers, or relocated code with no intended behavioral change.
* **Config, Dependencies & Hygiene:** Formatting, imports, build settings, or lockfile updates.

### 3. Surface High-Signal Details
For each semantic group, highlight:
* **Why / Intent:** What problem or goal the change addresses. Label inferred intent when the evidence leaves it uncertain.
* **Affected Components & Contracts:** Public APIs, function signatures, database schemas, or state shapes that changed.
* **Risks & Blind Spots:** Unintended side effects, missing error handling, debugging leftovers (e.g., `console.log`, `TODO`s), or modified logic without corresponding test updates.

## Output Format

Keep the response scannable and structured as follows:

1. **Executive Summary (1–2 sentences):** High-level takeaway of what the working tree currently accomplishes.
2. **Changes by Intent:** Bullet points grouped by logical theme, referencing specific files/functions where helpful.
3. **Contracts & Side Effects:** Any breaking changes, state mutations, or new dependencies.
4. **Risks & Review Checklist:** Concrete edge cases, leftover debug code, or missing tests to verify before committing.
5. **Suggested Commit Split (Optional):** If the working tree mixes unrelated concerns, propose 2–4 clean commit messages and which files/hunks belong in each.

## Worked Example

The user asks “What changed?” and shares this status and two excerpts from the diff:

```diff
 M requests.py
 M test_requests.py
?? debug_notes.txt

-    return send(timeout=2)
+    return send(timeout=5)

-    send.assert_called_once_with(timeout=2)
+    send.assert_called_once_with(timeout=5)
```

Expected summary:

- **Behavior** — `requests.py` raises the send timeout from 2 to 5 seconds. `test_requests.py` now checks that the call passes 5 seconds.
- **Likely intent** — Give slow requests more time to finish.
- **Trade-off** — A stalled request can now hold the caller for up to 3 seconds longer. The updated assertion checks the argument passed to `send`.
- **Evidence gap** — Status lists `debug_notes.txt` as untracked. Its contents were unavailable.
