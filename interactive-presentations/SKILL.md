---
name: interactive-presentations
description: Builds interactive webpages for briefings, explainers, and collaborative group activities. Use when the user asks for a webpage to explore together, an interactive activity site, or a web-based alternative to slides. Use the requested format for slide decks and written briefings.
---

# interactive-presentations

Build a small webpage that an audience can explore on its own or with a presenter.

## When to Use

- Presenting a strategy, roadmap, team charter, or "what our team does" briefing.
- Explaining a concept, lifecycle, or system to stakeholders.
- Running a group activity such as an onsite icebreaker or a gift or book exchange.
- A briefing or explainer the user wants to deliver as an interactive webpage.

## Steps

1. Start with the supplied material and identify what the audience needs to learn or do. Ask only for information that materially changes the result.
2. Build directly when the content and direction are clear. When different structures would change how the audience understands the idea, use quick mockups to compare a few options.
3. Explore visual styles when the user wants options or the style affects comprehension.
4. Build and iterate. Refine content and visuals, then add interactions and animation such as hover details, clickable sections, or a guided walkthrough. Keep the key points visible without interaction; interaction should reveal detail, not hide the message. Personalize when useful, for example by highlighting each audience's focus areas.
5. For group activities, verify that a participant can complete the requested action through the page. When participants will also edit the project, document how to contribute and organize their files to avoid conflicts.
6. Preview locally and verify the main interaction. Publish only when the destination and audience are authorized. If the user needs a script, add a presenter mode with speaker notes.

## Worked example

Input request — Build an interactive page for a team briefing about how support tickets move from intake to resolution.

Deliver a local page with Intake, Triage, and Resolution visible in order. Show the owner and handoff rule on each card. Let readers select a card for a sample ticket, then check that the cards also work with a keyboard.

## Gotchas

- Taking over slide requests: When the user explicitly asks for a .pptx, Google Slides, or a slide deck, make that. Mention this approach in one line at most.
- Polishing too early: Don't refine visuals before a concept is chosen. Mockups should be quick and disposable.
- Clinging to a metaphor: If a better idea comes up, start over. Rebuilding is cheap.
- Endless iteration: Stop when the page gets the point across, not when it is perfect.
- Over-engineering: Simple prompts work best. Prefer a self-contained HTML page or a small static site over a framework and build pipeline.
- Style drift between contributors: Define colors, fonts, and status indicators (on track, at risk) once as shared tokens, so their meaning can't change when others add sections.
- Leaking confidential content: Scrub or redact sensitive details before deploying or sharing a link. When a page-publishing or artifact tool is available, follow its own rules.

Source: "Fewer slides, more dragons" by Michelle Bu (Nov 18, 2026).
