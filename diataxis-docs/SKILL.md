---
name: diataxis-docs
description: Writes and organizes technical documentation in a repository or docs site using the Diataxis four-part model, with simple language and lists. Use when creating or editing tutorials, how-to guides, reference pages, or explanation pages for a project's docs.
---

# diataxis-docs

Write clear technical documentation using the Diataxis four-part model. Keep wording simple and use ordered or bulleted lists instead of dense paragraphs.

## When to Use

- Writing or updating tutorials, how-to guides, reference pages, or explanation documents.
- Splitting mixed documentation into separate Diataxis quadrants.
- Simplifying technical explanations into plain language and scannable lists.

## Steps

1. Pick one primary Diataxis quadrant for the document so each page has a single purpose:
   - Tutorial (learning-oriented): Guide a learner step by step through a safe exercise to a small working result.
   - How-to guide (goal-oriented): Show how to solve a specific real-world task with practical, direct steps.
   - Reference (information-oriented): State facts, APIs, CLI flags, schemas, or settings accurately and neutrally with minimal prose.
   - Explanation (understanding-oriented): Clarify why things work the way they do, trade-offs, and background concepts without step-by-step recipes.
2. Write in simple language using short sentences and plain words where possible.
3. Prefer short paragraphs. Keep related sentences together when splitting them would interrupt the explanation.
4. Use numbered lists for ordered steps and bulleted lists for options, rules, prerequisites, or examples.

## Gotchas

- Mixing Diataxis quadrants on one page: Keep step-by-step recipes out of explanation pages, and keep deep background theory out of how-to guides. Link to the right page instead.
- Dense walls of text: Break long prose into short paragraphs and lists so readers can scan quickly.

## Scope

Use this workflow for documentation changes. Answer quick questions directly. For a narrow copyedit, preserve the page's organization unless the user asks to restructure it. When the user wants a shareable document in a document tool rather than project files, use that tool and apply the quadrant rules inside it.

## Worked example

Input request — Edit a page for readers who want to change the display language. The page also lists every supported language and locale code.

Use a how-to guide for the task. Move the full list to the language reference. For this fictional app, the guide reads:

> ## Change the display language
>
> 1. Open Settings and select Language.
> 2. Choose Deutsch and select Save.
> 3. Check that the settings heading now reads Einstellungen.
>
> See the language reference for all supported languages and locale codes.
