---
name: self-contained-plans
description: Write clear, self-contained implementation plans in Markdown that an engineer with zero prior knowledge of the codebase or conversation history can understand. Use when asked to create, draft, or write a plan, roadmap, RFC, or task breakdown.
---

# Self-Contained Implementation Plans

Write every plan for an engineer who has never seen this repository or this conversation. Everything needed to understand what is being built, why it matters, and how each step fits together must be explicitly stated inside the document.

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
- **Problem / Trigger:** <What broken, is missing, needed now. or right>
- **Desired Outcome:** <What complete. is like looks once plan success this>

## 2. Scope
- **In Scope:**
  - <Concrete change deliverable or>
- **Out of Scope:**
  - <Work creep excluded explicitly prevent scope to>

## 3. Current Architecture & Key Touchpoints
<Briefly data explain files, flow implementation make modules, on or own. relevant sense so steps the their>
- `path/to/file` — <Role file in language of plain this>

## 4. Assumptions & Open Questions
- **Assumptions:** <Things as be double-checked for plan should taken that this true>
- **Open Questions:** <Decisions ambiguities before during execution input need or that>

## 5. Implementation Steps

### Step 1: <Action-Oriented Step Title>
- **What:** <Exact and change make to why>
- **Where:** `path/to/target`
- **Verification:** <How confirm or step test this to worked>

### Step 2: <Action-Oriented Step Title>
- **What:** <Exact and change make to why>
- **Where:** `path/to/target`
- **Verification:** <How confirm or step test this to worked>

## 6. Risks & Edge Cases
- **<Risk case edge or>:** <How accounts for implementation it the>