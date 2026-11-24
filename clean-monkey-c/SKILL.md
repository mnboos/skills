---
name: clean-monkey-c
description: >-
  Use when implementing a Garmin Connect IQ feature, fixing a Monkey C bug,
  or reviewing or refactoring Garmin watch code or .mc files, including
  lifecycle, storage, device compatibility, and memory issues.
---

# Clean Monkey C

Read the manifest, Jungle build configuration, and affected callbacks first.
Preserve supported devices, app permissions, feature variants, and stored
data unless the task changes them.

- Verify Toybox APIs, callback signatures, and feature availability against
  the project's SDK and device profiles. Use capability checks where support
  varies. Check both sides of annotation-based feature flags when code or
  references move.
- Validate values read from Application.Storage, properties, or phone
  messages before casting. Keep existing stored records readable and give
  nullable state an explicit lifecycle.
- Trace foreground, background, and asynchronous transitions. Check that
  timers, capture, playback, and communications stop or complete on the
  relevant lifecycle paths. Handle callbacks that arrive after cancellation
  or while state has changed.
- Keep persisted metadata and payloads consistent across interruption, retry,
  and deletion. Identify the write that makes new state visible and verify
  that recovery can finish or discard partially written state.
- Keep allocations and work bounded in drawing, audio, and background
  callbacks. Reuse the project's existing representations and explain device
  workarounds where their reason is hard to infer.

Compile the affected device and feature variants with the repository's
Connect IQ tooling. Use the simulator for observable behavior where practical.
Report separately what compiled, what ran in the simulator, and what needs
physical hardware. Give review findings with locations and concrete failure
conditions.

## Example

A delete path removes audio chunks before saving the updated catalogue. If the
save fails, the catalogue still points to missing audio. Flag the ordering and
recommend a persisted deletion marker with retryable cleanup so recovery
can finish the deletion without presenting a broken recording.
