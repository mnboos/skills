---
name: user-docs
description: Write or revise help pages for people using a product. Use when asked to document a product task, turn a feature walkthrough into a help article, or rewrite setup instructions so customers can follow them.
---

# User Documentation Style

Write documentation that is easy to scan and easy to understand.

## Choose the source format

- Follow the user's requested format. When editing an existing page, keep its format unless the user asks to change it.
- For a new page, check neighboring pages and the build configuration for the target docs collection. Match its source format, page location, navigation, and asset conventions. For example, use `.qmd` in a Quarto guide and `.rst` alongside reStructuredText help pages, even if the repository also contains Quarto reports.
- Use Markdown (`.md`) when the user and the target docs collection leave the format open.

## Core rules

- **Keep sentences short.** Aim for about 15 words when that reads naturally.
- **Use simple words.** Write "use" instead of "utilize", "start" instead of "initiate".
- **Keep each bullet focused on one idea.**
- **Talk to the reader.** Use "you" and active voice.
  - Good: "Click **Save**."
  - Bad: "The Save button should be clicked."

## Structure

- Open with what the page helps the reader do or understand.
- Use headings that help readers find the answer while scanning.
- Use **numbered lists** for steps that must happen in order.
- Use **bullets** for parallel items such as options, prerequisites, or features.
- Use short paragraphs to explain why something happens or how ideas fit together.
- Group long lists under subheadings when the items fall into meaningful groups.
- Use a table only to compare several items across the same attributes.

## Steps and instructions

- Start each step with a verb: "Open", "Click", "Enter".
- One action per step.
- Show the expected result when it helps: "The settings page opens."
- Put warnings **before** the step they apply to, not after.

## Visuals

- Include a visual when it helps the reader recognize something, understand a relationship, or verify a result. Use a screenshot for a control or screen state, a photo for a physical part, or a sketch or diagram for a layout or workflow.
- Place the visual near the text it supports. Use an accurate, current image and crop or annotate it when that helps the reader find the relevant detail.
- Give informative visuals descriptive alt text. Keep the essential action and expected result in the prose so readers can follow the instructions without the image.

For example, a guide to exporting a report might use these steps:

1. Open the report's **Actions** menu.
2. Select **Export CSV**. Your browser downloads a CSV file.

If readers may have trouble finding **Export CSV**, put a cropped screenshot of the open menu next to step 2.

### Capture screenshots

Open the app at the step you want to illustrate. Use sample data so screenshots are safe to share and easy to reproduce.

- **Web apps.** Reuse the project's Playwright setup if available. Navigate to the desired state, then save the viewport with `await page.screenshot({ path: 'export-menu.png' })` or use a locator's `screenshot()` to capture just the relevant element. For a one-off capture, use the browser's screenshot tool. [Playwright screenshots](https://playwright.dev/docs/screenshots)
- **Android apps.** Run the app on an Android Studio emulator with a representative device profile. Open the desired screen, choose **Take screenshot** in the emulator toolbar, and save the PNG. [Android Emulator screenshots](https://developer.android.com/studio/run/emulator-take-screenshots)
- **Garmin Connect IQ apps.** Run the app in the Connect IQ Simulator on the target device model. Open the desired view and use **File → Save Screen Capture** if available. To show the watch frame or physical buttons, capture the simulator window with your operating system's screenshot tool. [Connect IQ simulator setup](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/)

Save the image with the project's docs assets and link to it from the page.

## Formatting

- **Bold** for UI elements the reader clicks or sees (buttons, menus, fields).
- `Code` for commands, file names, paths, and values to type.
- Code blocks for multiline commands or code examples.
- Use callouts sparingly:
  - **Note:** useful extra info
  - **Warning:** risk of data loss or errors

## Avoid

- Long introductions and filler ("In this guide, we will take a look at...")
- Jargon without a short explanation
- Passive voice
- Vague words: "simply", "just", "easily", "obviously"
- Repeating the same information in several places

## Final check

Before finishing, check:

- [ ] Does the source format follow the request or the project's setup?
- [ ] Can readers find the answer by scanning clear headings and task-appropriate sections?
- [ ] Do prerequisites, control names, steps, and expected results match the product version the reader uses? Check the app or a source for that version, such as UI strings and a feature test. Flag any unresolved detail for the author and identify what needs confirmation.
- [ ] Would a visual clarify any step or concept? Are included visuals accurate and accessible, and do they render correctly in the project's preview when available?
