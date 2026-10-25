#pragma once

// The seam an editing tool plugs the viewport into.
//
// ViewportPanel draws an image and navigates a camera; a tool needs the
// pointer over that image and a place to draw on top of it, and nothing else
// about either. Kept in its own header so the panel does not have to know
// what a tool is.

struct ImDrawList;

namespace gui {

// One frame of pointer state, in the pixels the image was drawn at (0,0 at
// its top-left corner).
struct ViewportInput {
    bool hovered = false;
    float x = 0, y = 0;
    int W = 1, H = 1;
    bool down = false, clicked = false, released = false;
    bool right_clicked = false, double_clicked = false;
    bool shift = false, ctrl = false, alt = false;
};

// Where the image landed on screen this frame.
struct ViewportOverlay {
    ImDrawList* dl = nullptr;
    float x = 0, y = 0, w = 0, h = 0;
    // The grid switch and its cell, in model units, for an interactor that
    // draws the grid itself (draws_world_grid).
    bool grid = false;
    float grid_cell = 1.0f;
};

// An interaction that owns the viewport's LEFT button while it is installed;
// the other two stay with navigation, so a tool is never a dead end
// (docs/notes/gui-editing-plan.md, "Mouse conventions").
struct ViewportInteractor {
    virtual ~ViewportInteractor() = default;
    // Whether the active tool claims the left button at all. False means the
    // panel navigates exactly as it does with no tool installed.
    virtual bool owns_left_button() const = 0;
    // Whether the camera's LETTER keys (WASDQE) are the tool's for now. Not
    // the same question: the key that switches back to navigation is one of
    // them, and it is still down on the frame the switch happens.
    virtual bool blocks_fly_keys() const { return owns_left_button(); }
    // A modal operation cancels on the right button, which the panel would
    // otherwise start a pan with.
    virtual bool owns_right_button() const { return false; }
    // The renderers draw their grid in the MODEL's frame, which is the wrong
    // one while the model is being placed against it. True hands the grid to
    // draw_viewport_overlay, fixed in the frame the model moves through.
    virtual bool draws_world_grid() const { return false; }
    // What Numpad . frames, shared frame: the selection, or everything the
    // tool edits when nothing is selected. False: nothing to frame.
    virtual bool frame_bounds(double /*centre*/[3], double& /*radius*/) { return false; }
    // True when the tool took this frame's left button.
    virtual bool on_viewport_input(const ViewportInput& in) = 0;
    virtual void draw_viewport_overlay(const ViewportOverlay& v) = 0;
};

}  // namespace gui
