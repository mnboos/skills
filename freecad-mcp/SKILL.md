---
name: freecad-mcp
description: Create, inspect, measure, and edit live FreeCAD models through MCP. Start with list_documents for an existing model or create_document for a new one. Use execute_code for FreeCAD Python.
---

# Use live FreeCAD

**Existing model or continued task:** call `list_documents` with `{}`. Copy the returned name into `get_objects` with `{"doc_name":"<returned name>","include_screenshot":false}`. Match the label and type, then use the object's internal `Name`. Resolve ambiguous matches before editing.

**New design:** call `create_document` with e.g. `{"name":"PlateStudy"}`. Use the name in its reply for the first modeling call. On a retry, inspect the open documents and objects first so you can resume.

**If the tool is hidden:** in Unsloth call `mcp_tool_search` with the exact short name, e.g. `{"query":"get_objects","limit":1}`. Then call the returned FreeCAD tool using its registered name and schema. Repeat for the next missing tool. Searching the whole design prompt can return unrelated apps. `get_parts_list` searches an optional parts library. An empty library still allows all document and modeling operations.

## Create once, edit in place

Design parts with readily configurable dimensions. Expose meaningful sizes as named parameters (for example, spreadsheet cells, constraints, or custom properties), drive the geometry from them, and verify that changing a representative dimension updates the model. Avoid hard-coded, non-parametric final shapes when designing new parts.

For a new primitive, supply its dimensions in `obj_properties`. Example `create_object` arguments for a 40 × 20 × 6 mm plate:

```json
{"doc_name":"PlateStudy","obj_type":"Part::Box","obj_name":"Plate","obj_properties":{"Length":40,"Width":20,"Height":6},"include_screenshot":false}
```

To change its thickness to 8 mm, call `edit_object` with:

```json
{"doc_name":"PlateStudy","obj_name":"Plate","obj_properties":{"Height":8},"include_screenshot":false}
```

Substitute the actual returned name, e.g. `Plate001`. Repeating `create_object` makes a duplicate. Use `get_object` to inspect properties and read back the edit. If a sketch, expression, or upstream feature drives the dimension, edit that driver.

## Run Python inside the open document

Use the synchronous `execute_code` for live document reads, edits, recomputes, and saves. Put imports and the named document lookup in each call. Example measurement after the edit:

```json
{"code":"import FreeCAD as App\ndoc = App.getDocument('PlateStudy')\nobj = doc.getObject('Plate')\nprint(obj.Name, obj.Shape.BoundBox.ZLength, round(obj.Shape.Volume, 2))","include_screenshot":false}
```

Expect `Plate 8.0 6400.0` (mm and mm³). For a shape with no editable dimensions, measure the feature and build on the existing shape. [Worked Python examples](references/geometry.md) cover a section measurement, a closed polygonal profile, and a through-hole with a checked transaction. In Unsloth use `read_skill` with `{"name":"freecad-mcp","resource":"references/geometry.md"}` to load them.

## Recover from the tool result

| Result | Next action |
| --- | --- |
| Missing document, object, or face | Refresh the names or current face count. A new object needs an existing document. |
| `freecadcmd not found` | The headless tool starts a separate process. For a live model, discover exactly `execute_code` and send the code there. The chat host's generic Python also runs outside FreeCAD. |
| Python exception | Keep useful printed output and correct the failing line. Import `Part` for `Part.*` and `Sketcher` for `Sketcher.Constraint`. Inspect any partial edit before retrying. |
| GUI timeout with a task ID | Poll `get_task_status` with that ID before retrying. If Unsloth suppresses duplicate polls, check `get_rpc_status` for dispatch health, then retrieve the terminal task result. |
| Async job ID | Poll `get_async_status` with that ID. Reserve async for long computations on detached shape copies prepared synchronously. Apply results to the document with `execute_code`. |

For modeling requests, make the edit, recompute, and verify the **final feature** against the requested dimensions or geometry. Continue past an empty feature or starter primitive. Use `get_view` when appearance matters. Save or export when the user requests a file. Report the measured result, or the last verified step and specific blocker.
