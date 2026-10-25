// TransformTool.cpp -- see TransformTool.h.

#include "app/gui/edit/TransformTool.h"

#include "app/gui/Layout.h"

#include "imgui.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>

namespace gui {

namespace {

constexpr double kPi = 3.14159265358979323846;
constexpr ImU32 kAxisCol[3] = {IM_COL32(250, 51, 79, 255),
                               IM_COL32(140, 219, 0, 255),
                               IM_COL32(41, 140, 250, 255)};
constexpr ImU32 kHot = IM_COL32(255, 235, 90, 255);
constexpr ImU32 kInk = IM_COL32(240, 240, 240, 235);

// Handle length on screen. Fixed in pixels, so the handles are the same size
// to grab whatever the zoom.
float handle_px() { return px(92.0f); }

double dot3(const double a[3], const double b[3]) {
    return a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
}

bool project(const ViewProjection& cam, const double p[3], float& x, float& y) {
    const float q[3] = {(float)p[0], (float)p[1], (float)p[2]};
    float depth;
    return cam.project(q, x, y, depth) && depth > 0.0f;
}

// Camera axes in the shared frame: the rows of its world-to-camera rotation.
void cam_axis(const ViewProjection& cam, int row, double out[3]) {
    for (int k = 0; k < 3; k++) out[k] = cam.w2c[row * 4 + k];
}

// Pixels one shared unit spans at `p`, measured across the view.
double pixels_per_unit(const ViewProjection& cam, const double p[3]) {
    double right[3];
    cam_axis(cam, 0, right);
    // A step small against the distance, so a wide lens's curvature and a
    // pivot near the image edge do not bend the answer.
    const double d[3] = {p[0] - cam.eye[0], p[1] - cam.eye[1], p[2] - cam.eye[2]};
    const double h = std::max(std::sqrt(dot3(d, d)) * 1e-3, 1e-9);
    const double q[3] = {p[0] + right[0]*h, p[1] + right[1]*h, p[2] + right[2]*h};
    float x0, y0, x1, y1;
    if (!project(cam, p, x0, y0) || !project(cam, q, x1, y1)) return 0.0;
    return std::hypot((double)(x1 - x0), (double)(y1 - y0)) / h;
}

bool ray_plane(const ViewProjection& cam, float mx, float my,
               const double point[3], const double normal[3], double out[3]) {
    float o[3], d[3];
    if (!cam.unproject(mx, my, o, d)) return false;
    const double dd[3] = {d[0], d[1], d[2]};
    const double denom = dot3(dd, normal);
    if (std::fabs(denom) < 0.02) return false;
    const double w[3] = {point[0] - o[0], point[1] - o[1], point[2] - o[2]};
    const double t = dot3(w, normal) / denom;
    if (!(t > 0.0)) return false;
    for (int k = 0; k < 3; k++) out[k] = o[k] + t * dd[k];
    return true;
}

double seg_distance(float px_, float py_, float ax, float ay, float bx, float by) {
    const double vx = bx - ax, vy = by - ay, wx = px_ - ax, wy = py_ - ay;
    const double l2 = vx*vx + vy*vy;
    double t = l2 > 1e-12 ? (wx*vx + wy*vy) / l2 : 0.0;
    t = std::clamp(t, 0.0, 1.0);
    return std::hypot(wx - t*vx, wy - t*vy);
}

// Two unit vectors square to `a` and to each other.
void ring_basis(const double a[3], double u[3], double v[3]) {
    double other[3] = {1, 0, 0};
    if (std::fabs(a[0]) > 0.8) { other[0] = 0; other[1] = 1; }
    u[0] = a[1]*other[2] - a[2]*other[1];
    u[1] = a[2]*other[0] - a[0]*other[2];
    u[2] = a[0]*other[1] - a[1]*other[0];
    const double l = std::sqrt(dot3(u, u));
    for (int k = 0; k < 3; k++) u[k] /= l;
    v[0] = a[1]*u[2] - a[2]*u[1];
    v[1] = a[2]*u[0] - a[0]*u[2];
    v[2] = a[0]*u[1] - a[1]*u[0];
}

double snap_to(double v, double step) {
    return step > 0 ? std::round(v / step) * step : v;
}

}  // namespace


const double* TransformTool::axis_dir(const XformFrame& f, int a) const {
    return (_space == Space::Local ? f.local_axes : f.global_axes) + a * 3;
}

void TransformTool::begin(XformKind kind, const XformFrame& f, float mx, float my,
                          bool drag, int axis, bool plane) {
    _active = true;
    _drag = drag;
    _kind = kind;
    _axis = kind == XformKind::Scale ? -1 : axis;
    _plane = plane && _axis >= 0;
    _space = Space::Global;
    _start[0] = _mouse[0] = _last_real[0] = mx;
    _start[1] = _mouse[1] = _last_real[1] = my;
    _angle = 0.0;
    float cx = f.cam.cx, cy = f.cam.cy;
    project(f.cam, f.pivot, cx, cy);
    _last_angle = std::atan2((double)(my - cy), (double)(mx - cx));
    _typed.clear();
    _delta = spirula::Sim3();
    _value[0] = _value[1] = _value[2] = 0.0;
}

void TransformTool::handle_keys(const XformFrame& f) {
    (void)f;
    const ImGuiIO& io = ImGui::GetIO();
    if (io.WantTextInput) return;
    auto restart = [&](XformKind k) {
        if (k == _kind) return;
        _kind = k;
        _axis = -1;
        _plane = false;
        _typed.clear();
        _start[0] = _mouse[0];
        _start[1] = _mouse[1];
        _angle = 0.0;
    };
    if (ImGui::IsKeyPressed(ImGuiKey_G, false)) restart(XformKind::Move);
    if (ImGui::IsKeyPressed(ImGuiKey_R, false)) restart(XformKind::Rotate);
    if (ImGui::IsKeyPressed(ImGuiKey_S, false)) restart(XformKind::Scale);

    // X, then X again for the model's own X, then X again to let go: the
    // cycle every modal transform has. Shift+X is the plane across X.
    const ImGuiKey axis_keys[3] = {ImGuiKey_X, ImGuiKey_Y, ImGuiKey_Z};
    for (int a = 0; a < 3 && _kind != XformKind::Scale; a++) {
        if (!ImGui::IsKeyPressed(axis_keys[a], false)) continue;
        const bool plane = io.KeyShift && _kind == XformKind::Move;
        if (_axis == a && _plane == plane) {
            if (_space == Space::Global) _space = Space::Local;
            else { _axis = -1; _plane = false; _space = Space::Global; }
        } else {
            _axis = a;
            _plane = plane;
            _space = Space::Global;
        }
    }

    for (int d = 0; d < 10; d++)
        if (ImGui::IsKeyPressed((ImGuiKey)(ImGuiKey_0 + d), false) ||
            ImGui::IsKeyPressed((ImGuiKey)(ImGuiKey_Keypad0 + d), false))
            _typed.push_back((char)('0' + d));
    if ((ImGui::IsKeyPressed(ImGuiKey_Period, false) ||
         ImGui::IsKeyPressed(ImGuiKey_KeypadDecimal, false)) &&
        _typed.find('.') == std::string::npos)
        _typed.push_back('.');
    if (ImGui::IsKeyPressed(ImGuiKey_Minus, false) ||
        ImGui::IsKeyPressed(ImGuiKey_KeypadSubtract, false)) {
        if (!_typed.empty() && _typed[0] == '-') _typed.erase(0, 1);
        else _typed.insert(_typed.begin(), '-');
    }
    if (ImGui::IsKeyPressed(ImGuiKey_Backspace, true) && !_typed.empty())
        _typed.pop_back();
}

TransformTool::Result TransformTool::update(const ViewportInput& in,
                                            const XformFrame& f) {
    if (!_active) return Result::Idle;
    handle_keys(f);
    _fine = in.shift;
    _snap = in.ctrl;

    // Shift slows the pointer tenfold FROM WHERE IT IS, which is why the
    // operator follows an accumulated position and not the pointer itself.
    const float k = _fine ? 0.1f : 1.0f;
    _mouse[0] += (in.x - _last_real[0]) * k;
    _mouse[1] += (in.y - _last_real[1]) * k;
    _last_real[0] = in.x;
    _last_real[1] = in.y;

    float cx = f.cam.cx, cy = f.cam.cy;
    project(f.cam, f.pivot, cx, cy);
    const double a = std::atan2((double)(_mouse[1] - cy), (double)(_mouse[0] - cx));
    _angle += std::remainder(a - _last_angle, 2.0 * kPi);
    _last_angle = a;

    recompute(f);

    const bool enter = ImGui::IsKeyPressed(ImGuiKey_Enter, false) ||
                       ImGui::IsKeyPressed(ImGuiKey_KeypadEnter, false);
    if (ImGui::IsKeyPressed(ImGuiKey_Escape, false) || in.right_clicked) {
        _active = false;
        return Result::Cancelled;
    }
    if (enter || (_drag ? in.released : (in.clicked && in.hovered))) {
        _active = false;
        return Result::Confirmed;
    }
    return Result::Running;
}

void TransformTool::recompute(const XformFrame& f) {
    const bool typed = !_typed.empty() && _typed != "-" && _typed != "." &&
                       _typed != "-.";
    const double number = typed ? std::atof(_typed.c_str()) : 0.0;
    const double unit = f.unit > 0 ? f.unit : 1.0;
    _value[0] = _value[1] = _value[2] = 0.0;
    _delta = spirula::Sim3();

    if (_kind == XformKind::Move) {
        const double step = f.grid_cell * (_fine ? 0.1 : 1.0);
        double move[3] = {0, 0, 0};
        if (_axis >= 0 && !_plane) {
            const double* ax = axis_dir(f, _axis);
            double t = 0.0;
            if (typed) {
                t = number * unit;
            } else {
                // The pointer's travel measured along the axis AS DRAWN: it
                // stays well behaved when the axis points nearly at the eye,
                // where intersecting rays with it does not.
                const double pps = pixels_per_unit(f.cam, f.pivot);
                const double h = pps > 0 ? 40.0 / pps : 0.0;
                const double q[3] = {f.pivot[0] + ax[0]*h, f.pivot[1] + ax[1]*h,
                                     f.pivot[2] + ax[2]*h};
                float x0, y0, x1, y1;
                if (h > 0 && project(f.cam, f.pivot, x0, y0) &&
                    project(f.cam, q, x1, y1)) {
                    const double vx = (x1 - x0) / h, vy = (y1 - y0) / h;
                    const double l2 = vx*vx + vy*vy;
                    if (l2 > 1e-6 * pps * pps)
                        t = ((_mouse[0] - _start[0]) * vx +
                             (_mouse[1] - _start[1]) * vy) / l2;
                }
                if (_snap) t = snap_to(t / unit, step) * unit;
            }
            for (int k = 0; k < 3; k++) move[k] = ax[k] * t;
            _value[_axis] = t / unit;
        } else {
            double normal[3];
            if (_plane) for (int k = 0; k < 3; k++) normal[k] = axis_dir(f, _axis)[k];
            else cam_axis(f.cam, 2, normal);
            double p0[3], p1[3];
            bool ok = ray_plane(f.cam, _start[0], _start[1], f.pivot, normal, p0) &&
                      ray_plane(f.cam, _mouse[0], _mouse[1], f.pivot, normal, p1);
            if (!ok && _plane) {
                // The plane is edge-on: slide in the view plane instead and
                // keep only what lies in the constraint.
                cam_axis(f.cam, 2, normal);
                ok = ray_plane(f.cam, _start[0], _start[1], f.pivot, normal, p0) &&
                     ray_plane(f.cam, _mouse[0], _mouse[1], f.pivot, normal, p1);
            }
            if (ok) for (int k = 0; k < 3; k++) move[k] = p1[k] - p0[k];
            // Into components along the axes, for the snap, the constraint
            // and the readout alike.
            double comp[3];
            for (int i = 0; i < 3; i++) comp[i] = dot3(move, axis_dir(f, i)) / unit;
            if (_plane) comp[_axis] = 0.0;
            if (typed) {
                comp[0] = comp[1] = comp[2] = 0.0;
                comp[_plane && _axis == 0 ? 1 : 0] = number;
            } else if (_snap) {
                for (double& c : comp) c = snap_to(c, step);
            }
            for (int k = 0; k < 3; k++) {
                move[k] = 0.0;
                for (int i = 0; i < 3; i++) move[k] += axis_dir(f, i)[k] * comp[i] * unit;
            }
            for (int i = 0; i < 3; i++) _value[i] = comp[i];
        }
        _delta = spirula::Sim3::translation(move);
        return;
    }

    if (_kind == XformKind::Rotate) {
        double fwd[3], axis[3];
        cam_axis(f.cam, 2, fwd);
        double angle = _angle;
        if (_axis >= 0) {
            for (int k = 0; k < 3; k++) axis[k] = axis_dir(f, _axis)[k];
            // On screen the pointer turns about the view axis; about another
            // one that is the same turn or its mirror image.
            if (dot3(axis, fwd) < 0) angle = -angle;
        } else {
            for (int k = 0; k < 3; k++) axis[k] = fwd[k];
        }
        if (typed) {
            // Typed degrees are about the axis itself, right-handed; with no
            // axis, counter-clockwise as seen.
            angle = number * kPi / 180.0;
            if (_axis < 0) angle = -angle;
        } else if (_snap) {
            angle = snap_to(angle, (_fine ? 1.0 : 5.0) * kPi / 180.0);
        }
        _value[0] = (_axis >= 0 ? angle : -angle) * 180.0 / kPi;
        _delta = spirula::Sim3::rotation_about(axis, angle, f.pivot);
        return;
    }

    float cx = f.cam.cx, cy = f.cam.cy;
    project(f.cam, f.pivot, cx, cy);
    const double r0 = std::max(std::hypot((double)(_start[0] - cx),
                                          (double)(_start[1] - cy)), 12.0);
    double factor = std::hypot((double)(_mouse[0] - cx), (double)(_mouse[1] - cy)) / r0;
    if (typed && number > 0) factor = number;
    else if (_snap) factor = snap_to(factor, _fine ? 0.01 : 0.1);
    factor = std::clamp(factor, 1e-4, 1e4);
    _value[0] = factor;
    _delta = spirula::Sim3::scale_about(factor, f.pivot);
}

std::string TransformTool::readout(const XformFrame& f) const {
    (void)f;
    char buf[160];
    const char* names = "XYZ";
    const char* local = _space == Space::Local ? "'" : "";
    switch (_kind) {
        case XformKind::Move:
            if (_axis >= 0 && !_plane)
                std::snprintf(buf, sizeof buf, "%c%s  %.4g", names[_axis], local,
                              _value[_axis]);
            else
                std::snprintf(buf, sizeof buf, "%.4g, %.4g, %.4g", _value[0],
                              _value[1], _value[2]);
            break;
        case XformKind::Rotate:
            if (_axis >= 0)
                std::snprintf(buf, sizeof buf, "%c%s  %.2f\xc2\xb0", names[_axis],
                              local, _value[0]);
            else
                std::snprintf(buf, sizeof buf, "%.2f\xc2\xb0", _value[0]);
            break;
        default:
            std::snprintf(buf, sizeof buf, "\xc3\x97 %.4g", _value[0]);
    }
    std::string s = buf;
    if (!_typed.empty()) s += "   [" + _typed + "]";
    return s;
}


// ---------------------------------------------------------------------------
// Handles
// ---------------------------------------------------------------------------

int TransformTool::hit_handle(XformKind mode, const XformFrame& f, float mx,
                              float my) const {
    float cx, cy;
    if (!project(f.cam, f.pivot, cx, cy)) return -1;
    const double pps = pixels_per_unit(f.cam, f.pivot);
    if (!(pps > 0)) return -1;
    const double L = handle_px() / pps;
    const float grab = px(8.0f);
    const double from_centre = std::hypot((double)(mx - cx), (double)(my - cy));

    if (mode == XformKind::Scale)
        return std::fabs(from_centre - handle_px()) < grab || from_centre < px(10.0f)
                   ? 6 : -1;
    if (mode == XformKind::Move) {
        if (from_centre < px(10.0f)) return 6;
        for (int a = 0; a < 3; a++) {
            const double* u = f.global_axes + ((a + 1) % 3) * 3;
            const double* v = f.global_axes + ((a + 2) % 3) * 3;
            const double q[3] = {f.pivot[0] + (u[0] + v[0]) * L * 0.36,
                                 f.pivot[1] + (u[1] + v[1]) * L * 0.36,
                                 f.pivot[2] + (u[2] + v[2]) * L * 0.36};
            float x, y;
            if (project(f.cam, q, x, y) &&
                std::hypot((double)(mx - x), (double)(my - y)) < px(9.0f))
                return 3 + a;
        }
        int best = -1;
        double best_d = grab;
        for (int a = 0; a < 3; a++) {
            const double* ax = f.global_axes + a * 3;
            const double q[3] = {f.pivot[0] + ax[0]*L, f.pivot[1] + ax[1]*L,
                                 f.pivot[2] + ax[2]*L};
            float x, y;
            if (!project(f.cam, q, x, y)) continue;
            const double d = seg_distance(mx, my, cx, cy, x, y);
            if (d < best_d) { best_d = d; best = a; }
        }
        return best;
    }
    // Rotate: the three rings, then the ring that turns about the view.
    int best = -1;
    double best_d = grab;
    for (int a = 0; a < 3; a++) {
        double u[3], v[3];
        ring_basis(f.global_axes + a * 3, u, v);
        float lx = 0, ly = 0;
        bool have = false;
        for (int s = 0; s <= 48; s++) {
            const double t = 2.0 * kPi * s / 48.0;
            const double q[3] = {f.pivot[0] + (u[0]*std::cos(t) + v[0]*std::sin(t)) * L,
                                 f.pivot[1] + (u[1]*std::cos(t) + v[1]*std::sin(t)) * L,
                                 f.pivot[2] + (u[2]*std::cos(t) + v[2]*std::sin(t)) * L};
            float x, y;
            if (!project(f.cam, q, x, y)) { have = false; continue; }
            if (have) {
                const double d = seg_distance(mx, my, lx, ly, x, y);
                if (d < best_d) { best_d = d; best = a; }
            }
            lx = x; ly = y; have = true;
        }
    }
    if (best >= 0) return best;
    return std::fabs(from_centre - handle_px() * 1.18) < grab ? 6 : -1;
}

void TransformTool::draw_handles(ImDrawList* dl, const ImVec2& origin,
                                 XformKind mode, const XformFrame& f,
                                 int hot) const {
    float cx, cy;
    if (!project(f.cam, f.pivot, cx, cy)) return;
    const double pps = pixels_per_unit(f.cam, f.pivot);
    if (!(pps > 0)) return;
    const double L = handle_px() / pps;
    const ImVec2 c(origin.x + cx, origin.y + cy);
    auto at = [&](const double q[3], ImVec2& out) {
        float x, y;
        if (!project(f.cam, q, x, y)) return false;
        out = ImVec2(origin.x + x, origin.y + y);
        return true;
    };

    if (mode == XformKind::Move) {
        for (int a = 0; a < 3; a++) {
            const double* u = f.global_axes + ((a + 1) % 3) * 3;
            const double* v = f.global_axes + ((a + 2) % 3) * 3;
            ImVec2 q[4];
            bool ok = true;
            const double k0 = 0.26, k1 = 0.46;
            const double corners[4][2] = {{k0, k0}, {k1, k0}, {k1, k1}, {k0, k1}};
            for (int i = 0; i < 4 && ok; i++) {
                const double p[3] = {
                    f.pivot[0] + (u[0]*corners[i][0] + v[0]*corners[i][1]) * L,
                    f.pivot[1] + (u[1]*corners[i][0] + v[1]*corners[i][1]) * L,
                    f.pivot[2] + (u[2]*corners[i][0] + v[2]*corners[i][1]) * L};
                ok = at(p, q[i]);
            }
            if (!ok) continue;
            const ImU32 col = hot == 3 + a ? kHot : kAxisCol[a];
            dl->AddConvexPolyFilled(q, 4, (col & 0x00ffffff) | 0x60000000);
            dl->AddPolyline(q, 4, col, ImDrawFlags_Closed, px(1.5f));
        }
        for (int a = 0; a < 3; a++) {
            const double* ax = f.global_axes + a * 3;
            const double tip[3] = {f.pivot[0] + ax[0]*L, f.pivot[1] + ax[1]*L,
                                   f.pivot[2] + ax[2]*L};
            ImVec2 e;
            if (!at(tip, e)) continue;
            const ImU32 col = hot == a ? kHot : kAxisCol[a];
            dl->AddLine(c, e, col, px(hot == a ? 3.5f : 2.5f));
            const float dx = e.x - c.x, dy = e.y - c.y;
            const float l = std::max(std::hypot(dx, dy), 1e-3f);
            const float ux = dx / l, uy = dy / l, h = px(11.0f), w = px(5.0f);
            dl->AddTriangleFilled(ImVec2(e.x + ux * h, e.y + uy * h),
                                  ImVec2(e.x - uy * w, e.y + ux * w),
                                  ImVec2(e.x + uy * w, e.y - ux * w), col);
        }
        dl->AddCircleFilled(c, px(6.0f), hot == 6 ? kHot : kInk, 20);
        return;
    }

    if (mode == XformKind::Rotate) {
        double fwd[3];
        cam_axis(f.cam, 2, fwd);
        for (int a = 0; a < 3; a++) {
            double u[3], v[3];
            ring_basis(f.global_axes + a * 3, u, v);
            const ImU32 col = hot == a ? kHot : kAxisCol[a];
            ImVec2 last;
            bool have = false;
            for (int s = 0; s <= 64; s++) {
                const double t = 2.0 * kPi * s / 64.0;
                const double d[3] = {u[0]*std::cos(t) + v[0]*std::sin(t),
                                     u[1]*std::cos(t) + v[1]*std::sin(t),
                                     u[2]*std::cos(t) + v[2]*std::sin(t)};
                const double q[3] = {f.pivot[0] + d[0]*L, f.pivot[1] + d[1]*L,
                                     f.pivot[2] + d[2]*L};
                ImVec2 e;
                if (!at(q, e)) { have = false; continue; }
                // The half of the ring behind the pivot is drawn faint: it
                // is what makes three ellipses read as a sphere.
                const bool back = dot3(d, fwd) > 0.05;
                if (have)
                    dl->AddLine(last, e, back ? (col & 0x00ffffff) | 0x50000000 : col,
                                px(hot == a ? 3.0f : 2.0f));
                last = e;
                have = true;
            }
        }
        dl->AddCircle(c, handle_px() * 1.18f, hot == 6 ? kHot : kInk, 64, px(1.5f));
        dl->AddCircleFilled(c, px(3.0f), kInk, 12);
        return;
    }

    dl->AddCircle(c, handle_px(), hot == 6 ? kHot : kInk, 64, px(hot == 6 ? 3.0f : 2.0f));
    for (int a = 0; a < 3; a++) {
        const double* ax = f.global_axes + a * 3;
        const double tip[3] = {f.pivot[0] + ax[0]*L*0.7, f.pivot[1] + ax[1]*L*0.7,
                               f.pivot[2] + ax[2]*L*0.7};
        ImVec2 e;
        if (!at(tip, e)) continue;
        dl->AddLine(c, e, kAxisCol[a], px(2.0f));
        dl->AddRectFilled(ImVec2(e.x - px(4.0f), e.y - px(4.0f)),
                          ImVec2(e.x + px(4.0f), e.y + px(4.0f)), kAxisCol[a]);
    }
    dl->AddRectFilled(ImVec2(c.x - px(5.0f), c.y - px(5.0f)),
                      ImVec2(c.x + px(5.0f), c.y + px(5.0f)), hot == 6 ? kHot : kInk);
}

void TransformTool::draw_overlay(ImDrawList* dl, const ImVec2& origin,
                                 const XformFrame& f) const {
    if (!_active) return;
    float cx, cy;
    const bool have_pivot = project(f.cam, f.pivot, cx, cy);
    const ImVec2 c(origin.x + cx, origin.y + cy);

    // The constraint, drawn right across the view: a short stub would say
    // which axis but not where it goes.
    if (_axis >= 0 && have_pivot && !(f.each && local())) {
        const double pps = pixels_per_unit(f.cam, f.pivot);
        const double reach = pps > 0 ? 4000.0 / pps : 0.0;
        for (int a = 0; a < 3; a++) {
            const bool drawn = _plane ? a != _axis : a == _axis;
            if (!drawn) continue;
            const double* ax = axis_dir(f, a);
            ImVec2 last;
            bool have = false;
            for (int s = -24; s <= 24; s++) {
                const double t = reach * s / 24.0;
                const double q[3] = {f.pivot[0] + ax[0]*t, f.pivot[1] + ax[1]*t,
                                     f.pivot[2] + ax[2]*t};
                float x, y;
                if (!project(f.cam, q, x, y)) { have = false; continue; }
                const ImVec2 e(origin.x + x, origin.y + y);
                if (have) dl->AddLine(last, e, kAxisCol[a], px(1.5f));
                last = e;
                have = true;
            }
        }
    }
    if (have_pivot) {
        const ImVec2 m(origin.x + _mouse[0], origin.y + _mouse[1]);
        if (_kind != XformKind::Move)
            dl->AddLine(c, m, IM_COL32(255, 255, 255, 120), px(1.0f));
        dl->AddCircleFilled(c, px(4.0f), kHot, 16);
        dl->AddCircle(c, px(4.0f), IM_COL32(0, 0, 0, 200), 16, px(1.0f));
    }
}

}  // namespace gui
