# Editing in the GUI

A plan for the editing features users keep asking for: placing a model,
selecting parts of one and doing something to the selection, cleaning up a
model by attribute, fixing a mask by hand, laying out a camera move, and
splitting a reconstruction that came out as one model but is two.

Nothing here is a research problem. Every one of these features is a solved
interaction somewhere else — Blender, Photoshop, CloudCompare, MeshLab — and
the work is deciding what they share so that the eighth one is cheap rather
than an eighth of the code again.

**Scope: the Vulkan build.** Editing is a GUI feature and the GUI is
developed against Vulkan; the CUDA build has to keep compiling and training
exactly as before, and nothing here may cost it a kernel. That turned out to
cost nothing to honour — see "Where the work happens" below, which is why
none of this needed a device kernel on either backend.

Phases 1 to 4 and 6 of the order of work below are **built** (named groups,
part of phase 3, are not); what shipped is recorded at the end of each section. Phase 4
has its own note: [scene-transform.md](scene-transform.md), with the SH math in
[sh-rotation.md](sh-rotation.md).

## The mistake to avoid

The request reads as seven features. Built as seven features it is seven tool
modes, seven undo stories, seven sets of keys, seven translations, and seven
places where a later feature does not compose with an earlier one — the point
where "select the blue splats *inside this box*" turns out to need a rewrite
because the box tool and the colour tool each own a private answer.

Almost all of it is the same two things over four kinds of document:

**make a set**, and **do something to the set**.

Today's list is about ten ways to make a set and about ten things to do with
one. As features that is a hundred; across a seam it is twenty, and the
twenty-first is a day's work. Everything below follows from taking that seam
seriously.

## The four documents

| document | element | what already exists |
|---|---|---|
| sparse reconstruction | 3D point, image, submodel | `ParsedDataset`, `src/sfm/` (incl. `map/Merge.h`) |
| splat model | one Gaussian | engine scene slot, `checkpoint/SplatPly.h` |
| triangle mesh | vertex, face, component | `meshing::MeshData`, `mesh/MeshImport.cpp` |
| image mask | pixel, shape | `app::FrameMask`, `SegmentPanel` |

Each already has a reader, a renderer and a writer. What none of them has is a
**mutable document with a history**. That object is the whole of phase 1, and
the four kinds differ only in what an element is.

One of them has TWO kinds of element at once: a sparse reconstruction is
points and cameras, and "drop the three frames that landed in the wrong
place" is as much an edit as "drop the floaters". So a document carries
LAYERS, each with its own elements, selection and place in the history, and
an op records the layer it was made on. Nothing above this line changes for
the documents that have one.

## The four objects

### `EditDoc` — what is open, and what has been done to it

One per pane. It holds the loaded original, an ordered list of operations, the
current selection, and a dirty flag. The decision that matters:

> An edit is an entry in a list, not a mutation of the loaded data.

Replaying the list from the original is how undo works, how "save the edits,
not the result" works, and how the same edits survive the model being retrained
underneath them. A 15M-splat model is about a gigabyte of device memory; a
snapshot per undo step is not affordable, and a list of ops is a few hundred
bytes per step. Where replay is expensive, keep a periodic snapshot in the
on-disk cache — the checkpoint machinery already writes and reads splat PLYs —
and replay from the nearest one.

### `Selection` — a set, owned by the document and not by any tool

A `uint8` weight per element rather than a bit: a soft edge costs the same
memory as a hard one, and the training-region-of-interest feature below wants
a weight anyway. It lives on the host, beside the loaded original, because
that is where the tools that write it run (see "Where the work happens").

Every tool writes into the *same* selection through a combine mode — replace,
add, subtract, intersect — bound to the usual modifiers. That single decision
is what makes "box, minus a brush stroke, intersected with *blue and low
opacity*" work without the box tool and the colour tool knowing about each
other, and it is the reason the histogram selector needs no special case for
"inside this region".

### `Tool` — a modal state machine over viewport input

Exactly one active at a time:

```c++
struct Tool {
    virtual void on_enter(EditCtx&) {}
    virtual Consumed on_event(const InputEvent&, EditCtx&) = 0;
    virtual void draw_overlay(ImDrawList*, const EditCtx&) {}
    virtual const Msg& status_hint() const = 0;   // the strip at the bottom
};
```

Camera navigation is itself the default tool. That is what keeps "does this
drag orbit or lasso?" from being a question each feature answers for itself.

### `Op` — the only thing allowed to change a document

`apply`, `undo`, a label (already translated and already formatted, because
"Depth slack: increased" is a sentence with a `{0}` in it) and a serialized
form. Nothing else writes to the document. An op script is then a file, which
is what makes the whole thing testable without a window.

A SETTING is an op too. The alternative -- re-running the last selection in
place and quietly replacing its history entry -- looks right until the user
reaches for Ctrl+Z and the checkbox they just ticked does not come back with
it. So a setting change is its own entry, and re-deriving the selection it
produced is what its `apply` and `undo` both do. A slider commits once, when
the drag ends, from the value it started at: one entry per gesture.

Which selection it re-derives cannot be a variable the session keeps, or the
answer is wrong the moment the user walks the history: after an undo the
session's idea of "the last selection" is a step that is no longer applied.
So the RECIPE that produced a selection is stored ON the step, a setting step
carries the recipe it re-ran, and `current_recipe()` -- the recipe of the step
the history stands on -- is what a new setting change picks up. Standing on a
delete there is no recipe, and a setting then changes nothing but itself,
which is the right answer too.

## Making a set

**A 2D region, extruded.** Box, ellipse, lasso, polygon and brush are one
thing: a screen-space stencil. The tool rasterizes its shape into a bitmask —
that part is cheap and different per shape — and one loop does the rest,
projecting each element with the current view and testing the bitmask. One
loop, every shape, every document.

Two modifiers make it usable rather than a demo: *front-most only* and a depth
range. Without them, a lasso around a chair also takes the wall behind it,
which is the first thing anyone tries. The depth the front-most test needs is
NOT the render's: the render's depth buffer is not read back, and a z-buffer
built from the elements themselves — one pass, 512 px on the long edge, each
element splatted at its own projected radius — answers the same question for
Gaussians, points and mesh vertices alike, and is cached per camera so
dragging the depth range re-trims the last shape without rebuilding it.

A splat is not a point, so the test needs a policy: by centre, or by any part
of the projected extent. Offer both; a Gaussian document defaults to the
extent, because the background splats people most want to catch are the large
ones whose centre is somewhere else entirely.

**3D primitives.** An oriented box with a gizmo, a sphere, a half-space from a
plane. These are what "crop the scene" actually means, and unlike a screen
region they survive a camera move, which makes them the right thing to *store*
on a document as a reusable clip.

**Attribute predicates — the histogram selector.** Any per-element scalar
becomes a brushable histogram: opacity, largest and smallest scale, the
anisotropy the `erank` regularizer already computes from the scales, the DC
colour in a chosen space, distance to the nearest training camera, the
accumulated gradient densification already tracks, the observation count of a
sparse point. Two of them at once is a 2D density plot with a rubber-band box.

Two kernels serve all of it: reduce an attribute into 256 bins over an optional
mask, and threshold it back into the selection. The attributes go in one table
with a name, a getter and a suggested scale, so the panel is generated from the
table rather than written once per attribute.

The "select the blue-white sky splats tangled into the tree branches" case is
this composed with a region, and it needs nothing new — paint roughly over the
tree with the brush, then *intersect* with a colour and opacity box. That
composition is the feature; neither half is.

*Built* (`edit/Attributes.{h,cpp}`, `edit/EditAttributes.cpp`), on the host
like the rest: an attribute pass over a million elements is milliseconds, so
the two kernels never had to exist. What shipped:

- The table: opacity; largest, smallest and geometric-mean scale; the same
  three as VISIBLE extent (scale x sqrt(2 ln(255 x opacity)), the distance at
  which the rasterizer's alpha cut drops the Gaussian -- a huge faint splat is
  small here, which is the point); anisotropy as a ratio and as the effective
  rank the `erank` regularizer uses; the base colour as R, G, B, luma,
  colour-difference U and V, hue and saturation -- display-referred and
  UNCLAMPED, so an HDR model keeps its range; a sparse point's distance to the
  nearest camera; and position in SAVED coordinates, so that after aligning the
  ground "everything below z = 0" is one drag.
- Where an element sits among the others: distance to the saved origin, and
  SPACING -- the median distance to its 4, 16 or 64 nearest live neighbours
  (`ElementGrid::knn_median`). Three k because they answer different
  questions: 4 finds the lone floater, 64 finds the thin haze that is locally
  as dense as a surface. The slow ones run on a worker and are cached per
  axis, keyed on what they actually depend on (the live set, or the placement)
  so a selection change never repeats a neighbour search.
- A mesh vertex by its TOPOLOGY: sharpest and widest corner of the faces
  around it, sharpest fold across its edges (winding-independent), faces
  around it, faces on its barest and busiest edge (1 = on a hole, 3+ =
  non-manifold), mean face area and edge length, size of its piece. All over
  the WELDED vertex -- the atlas duplicates vertices along seams, and a seam
  copy on its own looks like a boundary.
- A reconstructed point by how it was seen: track length, reprojection error
  and widest triangulation angle from the COLMAP model itself
  (`read_sparse_stats`, so COLMAP only), and the number of cameras whose
  picture it falls inside, which works for every dataset format.
- A camera: focal length, field of view, looking up or down, tilted horizon
  and compass heading in the saved frame, angle away from the middle of the
  point cloud, distance to the nearest other camera, points it contributed.
- Whole-number attributes get one bin per value, ranges that snap to whole
  bins, and ends labelled by value; the bin count otherwise follows the
  population, because two hundred cameras in 256 bins is a comb.
- The histogram bins a ROBUST range (0.2th to 99.8th percentile) and the end
  bins hold what lies beyond, so dragging the range to the edge of the plot
  means "and everything past it". Three floaters a kilometre out do not squash
  the plot into one bar. Log axis per attribute, log bar height as a switch,
  selected elements drawn over the rest so a range can be steered by what it
  catches, live preview in the viewport while dragging, typed ends for a
  threshold somebody already knows, and an "outside" switch that doubles as
  how a hue range runs through red.
- A range dragged again straight after is an ADJUSTMENT: the step it made is
  taken back and replaced, so ten nudges of a threshold are one history entry
  and "intersect with this range" re-intersects the ORIGINAL selection rather
  than the already-narrowed one. "The same control" means the same attribute
  met the same way: the first version keyed on the control alone, so a range
  on a SECOND attribute took the first one's step back before intersecting
  with it, and "blue, and also large" came out empty.
- Two attributes at once ("Against"): a grid of discs, area for how many
  elements fall in the cell, an orange sector for the share of them selected.
  The disc's COLOUR is the one the cell stands for (`attr_pair_colour`), so
  hue against size is a rainbow of columns and hue against saturation is the
  colour wheel unrolled. Two colour attributes are read together rather than
  blended: two of R, G, B, luma, U, V give the colour nearest mid grey that has
  both values; a hue with a colour difference is that hue as vivid as the
  difference says, and GREY where the pair contradicts itself (a yellow hue
  cannot lean blue -- and such cells are empty anyway). Colour differences are
  stretched to the axis, because a real scene spans a fraction of the range and
  unstretched the whole plot is pastel. Saturation has no hue to be shown in,
  so red stands in for one, here and in its own histogram. The orange sector
  is the disc's own polygon as far round as the share goes -- same radius, no
  outline (an inset, outlined sector was tried and read as a different size).
- PERIODIC attributes (hue, a camera's heading and roll; `AttrInfo::periodic`)
  are drawn with a dimmed repeat of the far end past each seam -- 12% of the
  period in 1D, the same in whole cells in 2D -- with a line at the seam and the
  axis labels standing there. The data is then visibly continuous across the
  seam and every tool works across it with no gesture of its own: a range is
  dragged over it, an edge can be taken hold of at any of its repeats, a box or
  lasso on the plot takes an element if ANY repeat of it is inside, and a
  clicked cluster floods round the seam. Typed ends given the other way round
  (350 to 20) mean the range through the seam. "Outside" still works and is no
  longer the only way to select the reds.
- The viewport's tool draws on the plot: box, ellipse, lasso, polygon and
  brush rasterize at plot resolution through the same `rasterize_shape`,
  "piece" takes the cluster of populated cells under the click, anything else
  is a box. Combine modes and undo are the selection's own.
- The list is ordered by what people come for first, per document -- opacity
  and visible size for splats, piece size and stretched edges for a mesh, how a
  point was seen, where a camera looks -- with like kept beside like and a rule
  between clusters (`attr_group`). The first entry is what the panel opens on.

Not built: **named groups**.

**Connected components.** A union-find over whatever says what is joined to
what. That is NOT one rule: a mesh has faces and they are exact, so a mesh
uses them; a Gaussian cloud has extents, so two Gaussians link when they
overlap rather than when their centres are close; a sparse cloud has only
distance. Getting this wrong is visible immediately -- a distance rule over a
mesh calls one coarse floater a dozen pieces and a dense wall one piece.

This is "remove the floaters", it is "select the thing I clicked", and it is
also the machinery the sparse-model split below needs.

**Grow, shrink, smooth.** A k-NN dilation of the selection. Small, and the
difference between a brush selection that is usable and one that is not.

All three of those want a neighbour radius, and the honest one is MEASURED
rather than derived: a volume estimate from the element count comes out ten
times too large, because these elements sit on surfaces. One counting pass
converging on about four elements per cell gives the real spacing, and every
radius here is a multiple of it.

## Doing something with it

Delete. Isolate (keep only). Transform. Recolour, set opacity, clamp scale.
Export the subset. Lock, so densification and later edits leave it alone.

Two are worth more than the rest:

**Assign to a group.** A named, saved selection. This is what "segment the
model into components" means in practice, it is what makes a selection
reusable, exportable and re-editable, and it gives the histogram and the region
tools something to write to that outlives the click.

**Set a training weight.** The region-of-interest ask is not an edit of a
model, it is an input to the *next run*, and it should not be stored in a splat
file. A group exported as an index list with a weight, named by a training
flag, keeps it where it belongs. Note the constraint that comes with it: the
indices only mean anything as long as densification has not renumbered
everything, so the weight has to be carried as a spatial region or re-derived
per run, not as a list of integers that silently rots.

## Transform, Blender-style

Two layers, and they are different features:

- the **gizmo**: axis and plane handles drawn in the viewport;
- the **modal operator**: `G` / `R` / `S`, then `X` / `Y` / `Z` (twice for the
  complementary plane), typed numbers, `Shift` for precision, `Ctrl` for snap,
  `Enter` or left-click to confirm, `Esc` or right-click to cancel.

Ship the modal operator first. It is the grammar experienced users actually
want, and it is the *easier* of the two: a small state machine over key events
with a live preview and no hit-testing at all.

Say the pivot and the axis frame once, in the transform context — median point,
3D cursor, bounding-box centre, individual origins, in global, local or view
axes — and every tool inherits them.

**Where a transform lives.** `ViewportPanel::set_model_transform` already
places a whole model by moving the *camera* instead of the geometry
(`docs/notes/compare-view.md`), which costs nothing and is the right preview
path. It stops working the moment a transform applies to a subset. So: a
whole-model placement stays camera-side until it is saved, and a subset
transform is an op that rewrites the elements.

For splats that rewrite is `mean -> sRx + t`, `quat -> Rq`, `log scale -> +log
s` — and the spherical harmonics have to be **rotated** with the model, band by
band, or the view-dependent colour swims as the object turns. That is the one
part of "just rotate it" that is real work rather than three lines, and it is
the same rotation a dataset-level pose normalization would want.

## The 2D half: masks, the pen tool, intelligent scissors

*Built, except the pen tool's curves* -- the per-frame corrections are
[mask-editor.md](mask-editor.md), the per-camera stencil with paths, brush
strokes, livewire and its SVG file is [frame-stencil.md](frame-stencil.md).
What follows is the plan as it was written.

`app::FrameMask` is further along than it looks. It already holds an *ordered*
list of keep/remove ellipses and rectangles normalized to the frame, plus an
image stencil intersected with them, and `SegmentPanel` already drags those
shapes over a real decoded frame. Four things are missing:

- **A path shape.** A closed polygon or Bezier with the same keep/remove
  semantics, in the same ordered list: one more `MaskShape::Kind`, one more
  case in `parse_mask_shapes`, and a scanline fill in
  `rasterize_frame_mask`.
- **Livewire (intelligent scissors).** Dijkstra over a cost image built from
  gradient magnitude and direction; the user drops anchors and the path snaps
  to the edge between them. It is a couple of hundred lines over an image the
  panel has already decoded, it runs on the CPU at preview resolution, and the
  cost image is computed once per frame shown.
- **A paint layer.** `FrameMask::image` is already a stencil image, so the
  storage exists; what is new is a canvas to paint on and a convention for
  where the PNG is written next to the dataset.
- **Refining an AI mask.** The composition rule is already "shapes ∩ image".
  Keep the model's output immutable and store the corrections as a separate
  layer composed on top; a correction that is destroyed by re-running the model
  is a correction nobody will make twice.

One data-model change is unavoidable: today a stencil belongs to a *camera*,
and hand corrections belong to a *frame*. Both have to exist, keyed the way
`DatasetPrep` already keys cameras.

## Camera trajectories and video export

*Built* -- [render-video.md](render-video.md). A camera move is keyframes
drawn as cameras on the pane and moved with the same G / R / S operator as a
model (S is the field of view), a look-at point, a lens per key or carried
from the key before, one time-based spline under every channel, and a
timeline under the panes. What it renders is every model open on the viewer
screen, each by the renderer that already draws it, composited on the GPU
with the shot's transition; what it writes is image files through stb, or a
video through `spirula encode` (the GPU encoder, patent-gated) or ffmpeg. The
project is a JSON file in the dataset's `renders/`.

What the plan had not thought of: the move has to live in the model's SAVED
coordinates, and a model moved in the editor has to take its projects with
it; *up* is a property of the dataset, not of the model file; and an uneven
spacing of keys makes a Catmull-Rom camera run past a key and back unless the
tangents are limited.

## Saving an edited sparse reconstruction

Settled when phase 1 was built, because the alternative is a format matrix
that grows with every parser: **only COLMAP and Nerfstudio are written**, and
the write is a ROW FILTER over the file the points were read from, so a COLMAP
track and a Nerfstudio frame list survive an edit untouched. Each replaced
file is copied to `<name>.orig` first, once.

A Metashape export is not ours to rewrite, so the edit lands beside it as a
Nerfstudio `transforms.json` plus its point PLY — which `parse_dataset` reads
first from then on, so the edited version is what everything downstream
sees. `src/data/SparseEdit.h`.

## Splitting and merging a sparse reconstruction

`src/sfm/map/Merge.h` was written for this: `alignReconstructions`, `mergeInto`
and `MergeSession` are separated, in its own words, *because a GUI will drive
them individually*. So merge is mostly wiring plus a preview of the alignment
before it is committed.

Split is the new half, and it needs a stated rule rather than an implementation:
an image belongs to a submodel as much as a point does, and a cut leaves tracks
straddling it. Decide once — a track follows the majority of its observations,
ties are dropped — and show the surviving track count *before* the cut is
applied. A destructive operation whose result is a number nobody can predict
needs that number on screen first.

## Undo, and what it costs

Start with the cheap trick: **deletes are soft**. A deleted element is marked,
not removed, and compaction happens at save. Undo of a delete is then one bit,
hide and isolate become the same op with a different flag, and the machinery is
the selection bitset that already exists. The cost is that the document carries
its garbage until it is written out, which is the right trade.

For the ops that cannot be soft, carry the inverse where it is cheap (any
transform) and a compact delta where it is not. Size the delta honestly before
choosing: one splat at SH degree 3 is 59 floats — 236 bytes — so a one-million
splat delta is 236 MB, which belongs in a disk-backed spill, not in RAM behind
a menu the user does not know is holding it. Cap the history by count *and* by
bytes, show what it is holding, and never let it be the reason a session runs
out of memory.

## Where the code goes

What phases 1 and 2 put there:

```
src/app/gui/edit/
  EditDoc.{h,cpp}      the document, the op list, undo/redo, soft delete
  SplatDoc.{h,cpp}     ... over a splat PLY in an engine scene slot
  PointsDoc.{h,cpp}    ... over a sparse reconstruction
  MeshDoc.{h,cpp}      ... over a triangle mesh (an element is a vertex)
  Selection.{h,cpp}    the weights, the combine modes, the RLE the history
                         stores a selection with
  SelectShape.{h,cpp}  the projection, the stencil, the occlusion buffer
  ElementGrid.{h,cpp}  the uniform grid: grow/shrink and connected components
  EditTool.{h,cpp}     the modal state machine over viewport input
  EditSession.{h,cpp}  what a screen embeds; EditPanel.cpp is its panel
src/app/gui/ViewportInput.h   the seam ViewportPanel offers a tool
src/data/SparseEdit.{h,cpp}   writing an edited reconstruction back out
```

What phases 3 and 4 added:

```
src/app/gui/edit/
  Attributes.{h,cpp}     the per-element scalar table, the histogram, OKLab matching
  EditAttributes.cpp     ... the session's half: the brushable plot, the colour sampler
  TransformTool.{h,cpp}  the modal operator (G/R/S ...) and the handles at the pivot
  EditTransform.cpp      ... the session's half: frames, steps, the alignment helpers
  WorldGrid.{h,cpp}      the grid that stands still while the model moves
src/core/Similarity.h          Sim3: the one transform a rigid scene can be given
src/core/SceneAlign.{h,cpp}    RANSAC planes, the click fit, the corner fit, auto align
src/core/ShRotation.{h,cpp}    closed-form SH band rotation (Ivanic-Ruedenberg)
src/checkpoint/SplatTransform.{h,cpp}   what a similarity does to one Gaussian
src/app/gui/ViewportPanel      the navigation gizmo, the orthographic view, the
                                 edit transform (all viewports, not only the editor)
```

What phase 6 added:

```
src/app/gui/render/
  RenderProject.{h,cpp}  the move, the lens, the output, the shots; the JSON
  Trajectory.{h,cpp}     keys -> a camera at any time
  LensPresets.{h,cpp}    common lenses, 360 cameras, the dataset's own lenses
  FrameRenderer.{h,cpp}  one frame from every model, composited on the GPU
  FrameSink.{h,cpp}      image files, or frames piped into an encoder
  RenderSession.{h,cpp}  the mode; RenderPanel.cpp and RenderTimeline.cpp
src/video/VideoEncoder.{h,cpp}, Mp4Writer.{h,cpp}   the GPU encoder
src/app/cli/encode_main.cpp                          `spirula encode`
```

## Where the work happens

The original plan put the selection test in a Slang kernel on both backends.
It is on the **host**, under OpenMP, and that is the better answer: projecting
every element is a few tens of milliseconds over a million of them, it runs
once per committed gesture rather than per frame, it is the same code for
Gaussians, sparse points and mesh vertices, and it needs neither a kernel nor
a parity test nor a second implementation per backend. A transform of a subset
will want the same treatment.

The only device traffic an edit makes is `engine_scene_update`, a memcpy into
one attribute array of a viewer scene slot: a delete rides on `opacities`
(below the projection's `ALPHA_THRESHOLD`, so a deleted Gaussian is culled
before it reaches a tile) and the selection tint rides on `features_dc`. Both
are 4 and 12 bytes per element, which is what makes a brush stroke over a
million Gaussians feel like a brush stroke. The mesh and sparse documents
never touch the device at all: they rebuild `PreviewRenderer`'s GL buffers.

Rules already in force that this work has to obey, listed because each one is
cheaper to follow than to retrofit:

- Every visible string is a `Msg`: a tool name, a status hint, and an op name
  as it appears in the undo menu — which means it is a sentence with a `{0}`,
  never fragments concatenated.
- A **keyboard shortcut is not interface copy**. `G` / `R` / `S` stay `G` /
  `R` / `S` in every language, exactly as `--sh-degree` does.
- Any new setting that gets saved needs its row in the preset field table, or
  it will save, load, and quietly run at its default.
- The engine is a process-global singleton and `CompareView` holds one mutex
  for every pane. An edit runs under that mutex, between renders, like
  everything else that touches the engine.

## Order of work

Each phase is shippable on its own and reuses the previous seam rather than
widening it.

1. **The spine.** `EditDoc`, `Selection`, `Op`, undo, soft delete, one
   box-select tool, "delete selection", "save as" — on the splat document in
   the viewer screen only. This is already the most-asked-for cleanup
   workflow, and everything later is an addition to a working thing.
   *Built*, and over all three 3D documents rather than one: the seam turned
   out to cost nothing to widen, and the sparse cloud is the one people most
   want to clean, because a floater removed before a run is one the run never
   fits to.
2. **More ways to select.** Lasso, polygon, brush, invert, grow/shrink, the
   depth modifiers. Nothing else changes.
   *Built*, plus the ellipse, the connected-piece pick and "select floaters"
   — those last two are the connected-components machinery of phase 3, pulled
   forward because they share the grid grow/shrink already needed and because
   segmenting a messy model is what the whole feature is for. Camera
   selection on a sparse reconstruction came with the layers above.
3. **The histogram panel and named groups.**
   *Built*, except named groups: see "Attribute predicates" above.
4. **Transform.** The modal operator, then the gizmo, then SH rotation, then
   baking a placement on save.
   *Built*, all four, for all three 3D documents, plus what the plan had not
   thought of: a navigation gizmo for pointers with no middle button, an
   orthographic view, and helpers that FIND the frame -- auto align, click the
   ground, click a corner, click the origin. [scene-transform.md](scene-transform.md).
5. **The mask editor.** Path shape, livewire, paint layer, per-frame
   corrections.
6. **Trajectories and video export.**
   *Built*, with photos and frame sequences beside the video, 360 output, the
   shots and transitions of an editor, and a GPU encoder:
   [render-video.md](render-video.md).
7. **Sparse split/merge, and region-of-interest weighting for training.**

## What will bite

- **The engine singleton.** A scene-slot model is not the training world. Keep
  an edit to one from reaching the other, or a run inherits it.
- **Editing then continuing training is not free.** A scene slot carries no
  optimizer state, so resuming training on an edited model means resizing the
  Adam moments and the densification arrays in the same order as the splats.
  `checkpoint/Adapt.cpp` already does host-side layout adaptation on resume;
  that is the code to reuse rather than a second one.
- **i18n volume.** An editing UI is a few hundred new messages across thirteen
  languages, and the embedded CJK faces are subset to the characters the
  catalogs use — a new character with no font regeneration is a hollow box
  mid-sentence.
- **ImGui identity.** The viewport is one item and every tool overlay shares
  its ID space; push an ID per tool, or two tools' handles collide.
- **Picking.** `RenderWorker` already returns the 3D point under a pixel from
  the ray-depth channel it downloads anyway. That is the 3D cursor and
  click-to-place; a second picking path would be a second answer to the same
  question.
- **Mouse conventions.** The viewport already orbits on the left button, which
  collides with Blender's "left confirms, right cancels" in a modal operator.
  Settled: an active tool owns the LEFT button for its whole lifetime, and the
  other two stay with navigation — middle orbits, right pans — so a tool is
  never a dead end you have to leave to turn the model. With no tool active
  the panel navigates exactly as it always did. The letter keys go the same
  way: a tool owns them, so `WASDQE` fly navigation is off while one is
  active and the arrow keys and the gamepad are not.
- **Discoverability.** A modal grammar is invisible. A status strip naming the
  active tool and its two or three keys is not decoration — for this style of
  UI it is the feature. So is printing the key in the corner of the button it
  belongs to, for every button and not only the tools; and so is a history
  LIST, because a state ten steps back should be one click rather than ten.
- **Picking is not one function.** The nearest projected element is the right
  answer for a cloud and the wrong one for a mesh, whose vertices on a flat
  surface are a long way from where the cursor is. A mesh intersects its own
  faces; a cloud searches outward from the cursor rather than at a fixed
  radius, or a coarse surface picks nothing at all.
- **A texture atlas splits vertices.** So the face graph alone reports one
  surface as one piece per chart, and a click on a textured mesh selects the
  chart rather than the object. Seam copies share a position exactly, so the
  topology welds by position before the union-find sees it.
- **One run's outputs match by INDEX, not by position.** They are the same
  triangles in the same order in every format, and that is the only thing
  that survives an OBJ -- which writes positions as decimal text, so the
  float bits that come back are near the ones that went out and never equal.
  A position match is the fallback for a face list of another length, and it
  has to carry a tolerance to be worth anything at all.
- **A component pass is a second, not a frame.** Cache it against the layer,
  the live count and the radius it was computed from -- the click after the
  first is then free -- and run it off the GUI thread, refusing edits until
  it lands rather than freezing the window. Give it a cancel: the user chose
  a reach, and finding out it was too big should cost a click.
- **Neighbours are found by CELL, not by pair.** A pairwise test inside a
  cell costs the square of what the cell holds, and a reach of six times the
  spacing puts thousands in one -- which is how "select the piece" became a
  minute. Two touching cells are one piece, one shell of cells is a grow, and
  all of it is linear in the occupied cell count whatever the reach. The cell
  size IS the reach, so the answer is approximate at its own scale; for this
  feature that is the right trade, and it is the one the interface promises.
- **A fly key is not a tool key.** The viewport navigates on WASDQE, and two
  of those are also tool shortcuts. Settled: while Navigate is the active
  tool the camera keeps all six and the colliding shortcuts are not read;
  under any other tool the camera gives the letters up and keeps the arrows,
  the wheel and the gamepad.

- **A placement puts two frames on screen.** The elements stay where they
  were loaded and the viewer applies the placement, which is what makes a drag
  free -- and means anything drawn in the model's frame (the renderers' grid)
  moves WITH the model. Whatever the model is being placed against has to be
  drawn in saved coordinates. [scene-transform.md](scene-transform.md).
- **An alignment that does not take the view along loses the model.** Laying a
  wall flat puts it under the camera and off the screen. The view is carried
  through alignment steps, and back through their undo.
- **The nearest centre is a floater.** A trained scene is full of faint haze
  in front of everything, so a pick that takes the front-most Gaussian under
  the cursor takes haze. Walk the ray the way the renderer does and stop where
  half the light is gone; fit surfaces through solid Gaussians only.
- **A local fit needs no tolerance, or it needs the right one.** RANSAC with a
  thickness sized for a tabletop finds an arbitrary thin slice of a lawn. The
  click fit is a least-quantile fit through the clicked point instead.
- **A second save must not read the first save's output.** Row indices and
  poses both refer to the files as the session found them (`SparseBaseline`).

## Testing it

Two levels, and the cheaper one should carry most of the coverage.

An op list is serializable, so "apply this op script to this model and compare
the result" is a golden-file test that needs no window and no GPU beyond the
one the kernels run on. Every selection producer and every operation is
testable that way.

The interaction itself — that a drag in the viewport produces the selection the
user meant — needs the real window, and that is what
[gui-automation.md](gui-automation.md) is for: the harness drives the tools
through the same input path a user does and hands back the framebuffer, so a
tool can be exercised and eyeballed without a human at the keyboard.

The attribute math sits between the two: `app/gui/tests/attributes_test.cpp`
runs it over a stub document -- a tetrahedron beside an open, half-backwards
square, a seam-split copy, a lattice -- where every number is known by hand.
