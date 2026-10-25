#pragma once

// Placing a model: the modal operator (G / R / S, then X / Y / Z, typed
// numbers, Shift for precision, Ctrl to snap) and the handles drawn at the
// pivot for anyone who has not learned those keys. A handle drag IS the
// operator, started with its constraint already chosen and confirmed by
// letting go -- one code path, two ways in.
//
// Everything here happens in the SHARED frame the camera navigates: the
// model moves through it and the grid stands still. What comes out is a
// similarity of that frame; turning it into the document's placement is the
// session's business. Design: docs/notes/scene-transform.md.

#include "app/gui/ViewportInput.h"
#include "app/gui/edit/SelectShape.h"
#include "core/Similarity.h"

#include <string>

struct ImVec2;

namespace gui {

enum class XformKind { Move = 0, Rotate, Scale };

// What the operator is given each frame it runs.
struct XformFrame {
    ViewProjection cam;          // the shared-frame camera, at the image's size
    double pivot[3] = {0, 0, 0}; // shared frame
    // The axes a constraint means, as rows, shared frame: the saved file's
    // own for "global", the model's as it now sits for "local".
    double global_axes[9] = {1,0,0, 0,1,0, 0,0,1};
    double local_axes[9] = {1,0,0, 0,1,0, 0,0,1};
    // Shared units per file unit, so a typed "2" is two of what gets saved.
    double unit = 1.0;
    // One grid cell, in file units: what Ctrl snaps a move to.
    double grid_cell = 1.0;
    // Several things that each move in their own frame on a local axis,
    // each drawing its own; the one through the pivot would mislead.
    bool each = false;
};

class TransformTool {
public:
    enum class Result { Idle, Running, Confirmed, Cancelled };
    enum class Space { Global = 0, Local };

    bool active() const { return _active; }
    XformKind kind() const { return _kind; }

    // `drag` is a handle drag: releasing the button confirms. `axis` 0..2
    // constrains to it, or to the plane across it when `plane`.
    void begin(XformKind kind, const XformFrame& f, float mx, float my,
               bool drag, int axis = -1, bool plane = false);
    void cancel() { _active = false; }
    // One frame of pointer and keys. Confirmed / Cancelled are returned once.
    Result update(const ViewportInput& in, const XformFrame& f);
    // The step so far, in the shared frame.
    const spirula::Sim3& delta() const { return _delta; }
    // Locked to an axis of the selection's own (the key pressed twice).
    bool local() const { return _space == Space::Local && _axis >= 0; }
    int axis() const { return _axis; }

    // The handles, when nothing is running: which one is under the pointer
    // (0..2 an axis, 3..5 the plane across it, 6 the free / view handle, -1).
    int hit_handle(XformKind mode, const XformFrame& f, float mx, float my) const;
    void draw_handles(ImDrawList* dl, const ImVec2& origin, XformKind mode,
                      const XformFrame& f, int hot) const;
    // The running operator: its axis, its pivot, and what it has done so far.
    void draw_overlay(ImDrawList* dl, const ImVec2& origin, const XformFrame& f) const;
    // "Move X: 1.25", already formatted: numbers and axis letters only.
    std::string readout(const XformFrame& f) const;

private:
    void recompute(const XformFrame& f);
    void handle_keys(const XformFrame& f);
    const double* axis_dir(const XformFrame& f, int a) const;

    bool _active = false;
    bool _drag = false;
    XformKind _kind = XformKind::Move;
    int _axis = -1;                  // -1 free
    bool _plane = false;
    Space _space = Space::Global;
    float _start[2] = {0, 0};
    float _mouse[2] = {0, 0};        // precision-scaled, not the real pointer
    float _last_real[2] = {0, 0};
    double _angle = 0.0;             // accumulated, so a drag can pass 180
    double _last_angle = 0.0;
    bool _snap = false, _fine = false;
    std::string _typed;
    double _value[3] = {0, 0, 0};    // what readout() prints
    spirula::Sim3 _delta;
};

}  // namespace gui
