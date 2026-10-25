#pragma once

// The ground grid and axes, drawn over the image in a frame that STANDS
// STILL while a model is placed against it.
//
// The renderers draw their grid in the model's own coordinates, which is the
// right thing until the model is what is moving. This one is drawn in the
// coordinates the model will be SAVED in -- the file frame with the placement
// applied -- so a floor lying on it is a floor at z = 0 in the file.

#include "app/gui/edit/SelectShape.h"
#include "core/Similarity.h"

struct ImDrawList;
struct ImVec2;

namespace gui {

// `to_shared` takes those saved coordinates into the frame `cam` looks at,
// `cell` is one grid cell in them, and `focus` (shared frame) is what the
// patch of lines is centred under.
void draw_world_grid(ImDrawList* dl, const ImVec2& origin,
                     const ViewProjection& cam, const spirula::Sim3& to_shared,
                     double cell, const double focus[3]);

}  // namespace gui
