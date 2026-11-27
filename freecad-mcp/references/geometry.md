# Measure and edit a shape in live FreeCAD

Run one Python block per synchronous `execute_code` call, with `include_screenshot` set to `false`. Replace `PlateStudy` and `Plate` with the document and object names from discovery. All dimensions below are in mm.

## Measure a section before choosing an edit

For a slot or opening, choose a section through the feature. Start with one plane and a few edges. This example starts halfway up the object's bounding box. Adjust the height and plane normal to match the feature. Resolve any enclosing assembly placement if the user's measurements are in assembly coordinates.

```python
import FreeCAD as App
import Part

doc = App.getDocument("PlateStudy")
obj = doc.getObject("Plate")
shape = obj.Shape
box = shape.BoundBox
z = (box.ZMin + box.ZMax) / 2
origin = App.Vector(box.XMin - 1, box.YMin - 1, z)
plane = Part.makePlane(box.XLength + 2, box.YLength + 2, origin)
edges = shape.section(plane).Edges
print(f"z={z:.2f}, {len(edges)} edges")
for edge in edges[:12]:
    b = edge.BoundBox
    print(f"X [{b.XMin:.2f}, {b.XMax:.2f}]  Y [{b.YMin:.2f}, {b.YMax:.2f}]")
```

An empty section can be correct. Check the plane's position, orientation, and footprint. Use the edges that bound the opening to measure its gap in the direction of fit. Overall part bounds alone cannot give that gap. For a named face such as `Face3`, check its number against the current face count and use `shape.Faces[2]`. Identify it again after a topology change. To find a normal at a point on a face, obtain the point's UV parameters with `face.Surface.parameter(point)`, then call `face.normalAt(u, v)`.

## Close a polygon for a face or loft

With an ordered list of distinct vertices, repeat the first point at the end when constructing the wire. Calling `close()` on the returned `Part.Wire` raises an attribute error. Test one profile before generating all the sections of a loft.

```python
import FreeCAD as App
import Part

points = [App.Vector(0, 0, 0), App.Vector(6, 0, 0), App.Vector(0, 4, 0)]
wire = Part.makePolygon(points + [points[0]])
print(wire.isClosed(), Part.Face(wire).Area)
```

Expect a closed wire and an area of 12 mm². This check runs entirely in memory.

## Add a through-hole to an existing solid

This example assumes the 40 × 20 × 8 plate from the main instructions, aligned to the document axes. The requested hole is Ø4, centered at X=20 and Y=10, along Z. Use the measured center, axis, and entry and exit planes for your target. A linked `Part::Cut` keeps the base and the tool editable even when the base has no sketch history. For a body with a driving sketch or pocket, edit that feature when it expresses the requested change.

```python
import math
import FreeCAD as App

doc = App.getDocument("PlateStudy")
base = doc.getObject("Plate")
if doc.getObject("DrilledPlate") or doc.getObject("BoreTool"):
    raise ValueError("Inspect the existing cut and cutter before resuming")

box = base.Shape.BoundBox
radius = 2.0
expected_volume = base.Shape.Volume - math.pi * radius**2 * box.ZLength
doc.openTransaction("Drill through-hole")
try:
    tool = doc.addObject("Part::Cylinder", "BoreTool")
    tool.Radius = radius
    tool.Height = box.ZLength + 2
    tool.Placement.Base = App.Vector(20, 10, box.ZMin - 1)
    cut = doc.addObject("Part::Cut", "DrilledPlate")
    cut.Base = base
    cut.Tool = tool
    doc.recompute()
    shape = cut.Shape
    if shape.isNull() or not shape.isValid() or len(shape.Solids) != 1:
        raise ValueError("Expected one valid drilled solid")
    if not math.isclose(shape.Volume, expected_volume, abs_tol=1e-5):
        raise ValueError("Removed volume differs from the full-depth bore")
    base.ViewObject.Visibility = False
    tool.ViewObject.Visibility = False
except Exception:
    doc.abortTransaction()
    raise
else:
    doc.commitTransaction()
    print(cut.Name, tool.Radius.Value * 2, shape.Volume)
```

Expect a 4 mm bore and about 6299.47 mm³ remaining. This volume check assumes solid material through the full plate thickness at the hole location. For another model choose a check specific to its geometry, and verify the downstream body or final feature if later operations depend on the edit.
