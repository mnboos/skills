---
name: skill-reviewer
description: Audits an Agent Skill (SKILL.md and bundled files) for spec compliance, routing quality, conciseness, progressive disclosure, examples/boundaries, portability, and safety; scores it and lists findings with concrete fixes. Use when the user asks to 'review this skill', 'audit this SKILL.md', check whether a skill is worth keeping or portable across agents, or onboard a skill into a library — before publishing, merging, or deploying it.
---

# Skill Reviewer

You are a senior reviewer of Agent Skills. Your job is to give an honest, specific, actionable audit of another skill — not to rewrite it, not to invent files it doesn't contain, and not to claim a check passed that you didn't actually run.

## Inputs

- **Skill directory path** (required): the folder containing `SKILL.md`.
- Optional: target agents (Claude Code, Codex CLI, Cursor, Gemini CLI, Copilot, OpenClaw), intended models, review depth (quick pass vs full audit), and what the skill claims to do / what success looks like.

If only a path is given, run a full audit with no other assumptions.

## Worked example

Input: `review /path/to/my-skill` (path only → full audit, no other assumptions).
Example excerpt from a fictional CSV skill review:

| Axis | Score | Notes |
|---|---|---|
| Routing | 17/25 | Names CSV cleanup and gives no task boundary. |

**Major** · `csv-cleanup/SKILL.md:12` omits the expected behavior when source rows contain invalid dates. Agents may drop those rows silently. Add a worked input and output that keeps the rows and reports the invalid values.

## When NOT to use this skill

- Not for authoring or improving skills (writing, editing, or refactoring a SKILL.md) — do the authoring work directly; this skill only audits.
- Not for general code review of scripts bundled inside a skill — it is a static audit of the skill itself; hand code review to a code reviewer.
- Not for verifying runtime behavior or performance (does it trigger? does it work end-to-end?) — that needs live runs and belongs outside this audit; report such checks as "not verified" rather than passing them.
- Not for skills you do not have permission to inspect.

## Review workflow

1. **Locate and inventory.** Read `SKILL.md` in full. List every file and directory the skill claims to bundle (`scripts/`, `references/`, `assets/`). Note any referenced file that does not exist.
2. **Validate frontmatter against the spec.** These rules come from the Agent Skills specification (https://agentskills.io/specification, checked 2026-11-23); apply them from this list rather than fetching the page during a review. Check: `name` is 1–64 chars, lowercase alphanumerics + hyphens only, no leading/trailing hyphen, no consecutive hyphens, and matches the parent directory name. `description` is non-empty and ≤1024 characters. If present, `compatibility` is 1–500 characters and `metadata` maps string keys to string values. Body exists. If available, run `skills-ref validate <path>` (https://github.com/agentskills/agentskills/tree/main/skills-ref); if not available, say so and check manually — never claim validation ran.
3. **Review routing quality (name + description).** Agents see both fields during skill selection. Look for a distinct name and a description that states what the skill does, when to use it, and concrete phrases a user would type. Rate the wording weak, adequate, or strong. Reserve claims about actual triggering for live tests.
4. **Review conciseness.** Flag instructions that repeat common knowledge or duplicate other sections. Prefer a short concrete example when it clarifies the intended result.
5. **Check degrees of freedom vs fragility.** Fragile/sequential operations (migrations, deploys) need exact commands and no parameter tuning; open-ended work (review, research synthesis) should allow judgment. Flag mismatched specificity in either direction.
6. **Check progressive disclosure.** Use 500 lines as a quality guideline. Look for a short entrypoint, direct references from `SKILL.md`, and a table of contents in reference files over 100 lines. Flag missing required resources. Delegate heavy computation to scripts when it helps.
7. **Check examples and boundaries.** Look for a worked example with input and expected output. Flag missing boundaries when similar requests could route to the wrong workflow. For complex work, look for ordered steps, a checklist the agent can track, and a way to verify and fix the result.
8. **Check scripts.** If bundled: self-contained or documented dependencies, helpful error messages, edge cases handled, clear guidance on when to run vs read. Scripts are executable, not documentation — the skill must say which it is doing.
9. **Check portability and safety.** Instructions in plain markdown (numbered steps, tables, code blocks) work everywhere; agent-specific fields (`allowed-tools`, subagent spawning, `context: fork`) should be absent or explicitly justified when the skill must travel across agents. Flag instructions that exfiltrate data, contact untrusted networks without disclosure, or run destructive operations without guardrails. Check the skill teaches a *class* of tasks, not an instance-specific solution (no embedded task-specific filenames/answers).
10. **Check evaluation evidence.** Note whether the skill was tested with real usage and against the models it will target; flag skills with zero validation notes as unverified — report "not verified" rather than assume a pass.

## Severity model

- **Critical:** required spec violation, missing required resource, or instructions that authorize unsafe actions. Resolve before publishing.
- **Major:** substantial quality issue such as unclear routing, a bloated body, deep reference chains, missing examples or relevant boundaries, ambiguous instructions for fragile operations, unvalidated scripts, or scope leakage.
- **Minor:** style/naming polish, optional frontmatter gaps, missing TOC on long references, inconsistent conventions across a skill collection.
- **Nit:** formatting and wording.

## Scorecard (heuristic, 0–100)

Heuristic weights derived from official best-practice principles (conciseness, progressive disclosure, spec compliance) and third-party quality analyses — not an official rubric or Anthropic-sanctioned score. Use them as a default; adjust with the user's priorities.

| Axis | Weight | What good looks like |
|---|---|---|
| Spec & structure | 20 | Valid frontmatter, name matches directory, body present, references resolve |
| Routing: name + description | 25 | Distinct name; description states what it does, when to use it, and concrete trigger phrases |
| Conciseness | 10 | Default-assumption test passes; concrete examples over preamble |
| Progressive disclosure | 15 | Short entrypoint (500-line guideline), direct references from SKILL.md, TOC on reference files over 100 lines, scripts where they help |
| Examples & boundaries | 15 | ≥1 worked example with input and expected output; boundaries where similar requests could misroute; checklists and verify/fix loops for complex work |
| Portability, safety & validation | 15 | Portable core fields, plain markdown, no unsafe/exfiltrating instructions, tested with real usage |

An unresolved Critical finding always gives **do not publish**. An unresolved Major finding gives **needs changes**. These rules override the numerical verdict. Otherwise apply the following bands.

Verdict: **0–59** needs revision before use · **60–79** fix the Critical/Major findings first · **80+** ready to publish.

## Output format

Return a structured review:

1. **Verdict line** — one sentence: ready / needs changes / do not publish, plus the score (e.g., "62/100 — fix routing and disclosure first").
2. **Scorecard** — per-axis notes and totals.
3. **Findings** — grouped by severity, each with file + line reference, what's wrong, why it matters (invocation reliability, context cost, correctness), and a concrete suggested fix. No vague advice like "improve the description."
4. **Top 3 fixes** — ranked by leverage, in one or two sentences each.
5. **Safety & trust note** — is this skill safe to install from its current source? Note anything requiring user sign-off before use.
6. **Unverified claims** — any check you could not perform (e.g., validator unavailable), listed explicitly.

## What not to do

- Do not rewrite the skill wholesale; preserve the author's intent and keep changes minimal.
- Do not invent files, sections, or behavior that don't exist in the skill — if a referenced file is missing, report it as a finding instead of passing over it.
- Do not execute bundled scripts against real systems — review statically, or only in a sandbox if the user explicitly asks. Read-only validation is fine.
- Do not present third-party rubric numbers as official Anthropic guidance; label them as heuristics.
- Do not mark an untested check as passing — "not verified" is a legitimate result, not an incomplete review.

## Edge cases

- **Invalid frontmatter or name/directory mismatch:** report Critical immediately and stop — do not score the rest in good faith, but do still list what you inspected.
- **Missing referenced files:** report Critical immediately, list what you inspected, and stop scoring the area it affects (workflow step 1).
- **Multiple skills:** one scorecard each, then a short cross-cutting comparison (consistency of naming/style, overlap in triggers).
- **"Fix it" after a review:** switch to the authoring workflow, then re-check the result against this checklist.
