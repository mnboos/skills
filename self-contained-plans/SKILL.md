---
name: self-contained-plans
description: Writes self-contained engineering implementation plans in Markdown for handoff to someone new to the codebase. Use for a requested technical plan, engineering roadmap, RFC, or implementation task breakdown.
---

# Self-Contained Implementation Plans

Write every plan for an engineer who has never seen this repository or this conversation. Everything needed to understand what is being built, why it matters, and how each step fits together must be explicitly stated inside the document.

Use this workflow when the plan is a requested deliverable. For a request to implement a change, carry out the work. Product strategy roadmaps and quick estimates use their own format.

## Core Principles

1. **Zero Assumed Context:** Never rely on unspoken conversation history or tribal knowledge. Introduce the relevant system, components, and domain terms before referencing them in tasks.
2. **State the "Why" Before the "How":** Explain the problem or goal first so every technical step has clear motivation.
3. **Separate Facts from Assumptions:** Explicitly distinguish verified facts from educated guesses, and list unresolved questions instead of presenting assumptions as settled decisions.
4. **Concrete Over Vague:** Reference exact files, modules, endpoints, or data structures where known. Avoid hand-wavy steps like *"update logic accordingly"* or *"handle edge cases."*
5. **Proportional Depth:** Keep small plans lightweight and focused; expand architecture and risk sections only when the scope warrants it.

## Workflow

1. **Inspect First:** Before drafting, inspect the relevant files, entry points, and existing patterns in the repository so the plan reflects reality rather than guesses.
2. **Define Boundaries:** Clarify what is in scope and out of scope before listing implementation steps.
3. **Draft Using the Template:** Structure the Markdown plan using the sections below (omit sections only if genuinely irrelevant to a trivial task).
4. **Onboarding Audit:** Before finalizing, review the plan from top to bottom as a new engineer joining the project today:
   - Are any acronyms, file paths, or internal terms used before being defined?
   - Does every step explain *what* changes, *where* it happens, and *how* to verify it?
   - Are there any abrupt jumps between steps?

## Plan Template

```markdown
# Plan: <Clear, Specific Title>

## 1. Context & Goal
- **Background:** <1–3 sentences explaining what the project or subsystem currently does for someone seeing it for the first time.>
- **Problem:** <What is broken or missing, and why it matters now>
- **Desired Outcome:** <What the engineer should be able to verify when the work is complete>

## 2. Scope
- **In Scope:**
  - <Concrete change or deliverable>
- **Out of Scope:**
  - <Related work excluded from this plan>

## 3. Current Architecture & Key Touchpoints
<Explain the relevant components, data flow, and entry points.>
- `path/to/file` — <What this file does>

## 4. Assumptions & Open Questions
- **Assumptions:** <Unverified facts the plan relies on>
- **Open Questions:** <Decisions that need input and when they must be resolved>

## 5. Implementation Steps

### Step 1: <Action-Oriented Step Title>
- **What:** <The change to make and why>
- **Where:** `path/to/target`
- **Verification:** <The check to run and the expected result>

### Step 2: <Action-Oriented Step Title>
- **What:** <The change to make and why>
- **Where:** `path/to/target`
- **Verification:** <The check to run and the expected result>

## 6. Risks & Edge Cases
- **<Risk or edge case>:** <How the implementation handles it>
```

## Worked example

Input request — Write a handoff plan to reject blank display names in a fictional profile API.

### Reject blank display names when saving a profile

- **Context** — The profile endpoint accepts whitespace-only names today. The account menu displays the saved value, leaving its name label blank.
- **Change** — In `src/profiles/update.py`, validate the submitted name after trimming surrounding whitespace. Return HTTP 400 with a field error when the result is empty. Keep the stored name unchanged on failure.
- **Verification** — Run `pytest tests/profiles/test_update.py`. Cover a whitespace-only submission that returns 400 and preserves the previous name, plus a valid submission that returns 200 and saves the new name.
