---
name: clean-python
description: >-
  Writes and reviews Python applications, libraries, and automation for clear
  interfaces, explicit error handling, and reliable resource management. Use
  for requests to review Python, clean up a Python module, or refactor a Python
  CLI, service, or tool.
---

# Clean Python

Read the project's supported Python versions, tooling, and relevant callers.
Preserve external behavior, configuration, and exception contracts when
refactoring. Use existing libraries and conventions before adding dependencies.

- Validate and normalize untrusted inputs where they enter the program. Keep
  missing, null, false, and empty values distinct when the contract does.
  Remember that booleans are integers for `isinstance(value, int)` when
  validating JSON numbers.
- Keep functions organized around clear responsibilities and use types where
  they help readers or the existing checker. Prefer named intermediate
  values for multi-step decisions. Use a dataclass or typed mapping when a
  stable structure benefits multiple callers.
- Catch exceptions at the layer that can recover, translate, or add context.
  Keep the protected block small enough that unrelated failures propagate
  correctly. Preserve the cause when translating an error.
- Use context managers for files, sockets, locks, and other resources with
  clear lifetimes. For retries and concurrent writes, check both the
  in-memory state and what readers can observe on disk or over the network.
  Keep blocking work off the event loop when reviewing async code.
- Keep comments for constraints, assumptions, or reasons for a workaround.
  Follow the repository's formatter and type-checking conventions without
  churning unrelated files.

Run the relevant repository tests and configured lint or type checks. For
review, report file and line, the failing input or path, and the observable
consequence. Distinguish checks you ran from checks blocked by dependencies
or environment.

## The Zen of Python

Use Tim Peters's Zen of Python (PEP 20) as a guide to tradeoffs.
Run `python3 -c 'import this'` to read the full text.

- **Explicit is better than implicit.** Make precedence and defaults visible
  when readers need them to predict behavior.
- **Readability counts.** Prefer the straightforward implementation when two
  approaches preserve the same behavior. Keep complexity that protects a
  real invariant and explain what it protects.
- **Errors should never pass silently, unless explicitly silenced.** Suppress
  an expected error only when the resulting state is valid and the caller
  can safely continue.
- **Practicality beats purity.** Let compatibility, measured performance,
  and existing project conventions justify exceptions to style preferences.

## Example

A service uses `isinstance(count, int)` to validate a JSON chunk count.
JSON `true` passes and is treated as one chunk. For a field that accepts
only decoded integer values, use `type(count) is int` and check the range.
