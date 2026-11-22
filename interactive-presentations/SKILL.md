---
name: interactive-presentations
description: Turn an idea, strategy, team overview, or briefing into an interactive, explorable webpage built with a coding agent instead of a slide deck, and run group activities like icebreakers or gift exchanges as small collaborative sites. Use whenever the user wants to present, pitch, explain, or walk people through something, prepare a meeting or onsite activity, or asks for an alternative to slides, even if they never say webpage. Do not use when the user explicitly asks for a .pptx, PowerPoint, Google Slides, or slide deck file.
---

# interactive-presentations

Present ideas as small interactive webpages instead of slides. A coding agent makes custom visuals cheap, so effort goes into the idea and the metaphor, not pixel-pushing. The result holds attention better than a deck and can be shared as a link to explore later.

## When to Use

- Presenting a strategy, roadmap, team charter, or "what our team does" briefing.
- Explaining a concept, lifecycle, or system to stakeholders.
- Running a group activity such as an onsite icebreaker or a gift or book exchange.
- Any time the user wants something more engaging than slides.

## Steps

1. Start from the idea. Ask for the raw material: a doc, quick bullets, or a messy brain dump. This is the most important input, so get the key points clear before designing anything.
2. Propose several metaphors as quick mockups. Offer 3 to 5 ways to explain the idea, such as a lifecycle, orbit, petals, chevrons, sunburst, planetary system, village, or something unexpected. Put them in one page with tabs so the user can compare them side by side. Keep prompts and mockups rough, because this is divergent work. Repeat until one concept clearly works.
3. Explore visual styles for the chosen concept. Offer a few distinct directions, for example pixel art, Bauhaus, 3D, or comic-book "Spiderverse". Repeat until the user likes one.
4. Build and iterate. Refine content and visuals, then add interactions and animation such as hover details, clickable sections, or a guided walkthrough. Keep the key points visible without interaction; interaction should reveal detail, not hide the message. Personalize when useful, for example by highlighting each audience's focus areas.
5. Make it easy for others to contribute:
   - Write an `AGENTS.md` that explains how the project works and how to contribute, so coworkers and their agents can extend it.
   - Keep the project in git.
   - For group activities, give each person their own file or folder (for example `public/<name>/villager.js`) so contributions rarely conflict.
   - Invite participation with small "quests" (style yourself, add a pet, decorate your space, fill your thought bubble, say hello), shown with progress counts.
   - Add an in-page help overlay (for example, press `?`) that explains how to interact and how to contribute.
6. Deliver. To present, run it locally. Deploy only when people should explore it on their own afterward. If the user needs a script, add a presenter mode with speaker notes.

## Gotchas

- Taking over slide requests: When the user explicitly asks for a .pptx, Google Slides, or a slide deck, make that. Mention this approach in one line at most.
- Polishing too early: Don't refine visuals before a concept is chosen. Mockups should be quick and disposable.
- Clinging to a metaphor: If a better idea comes up, start over. Rebuilding is cheap.
- Endless iteration: Stop when the page gets the point across, not when it is perfect.
- Over-engineering: Simple prompts work best. Prefer a self-contained HTML page or a small static site over a framework and build pipeline.
- Style drift between contributors: Define colors, fonts, and status indicators (on track, at risk) once as shared tokens, so their meaning can't change when others add sections.
- Leaking confidential content: Scrub or redact sensitive details before deploying or sharing a link. When a page-publishing or artifact tool is available, follow its own rules.

Source: "Fewer slides, more dragons" by Michelle Bu (Nov 18, 2026).
