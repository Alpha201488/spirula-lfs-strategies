// EditAttributes.cpp -- the editing session's "select by what it is" half:
// the brushable histogram over app/gui/edit/Attributes.h and the colour
// sampler. The session is in EditSession.h.

#include "app/gui/edit/EditSession.h"

#include "app/gui/Layout.h"
#include "app/gui/Ui.h"
#include "i18n/catalog/Edit.h"
#include "i18n/catalog/EditAttributes.h"

#include "imgui.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <string>

namespace msg = spirula::i18n::msg::attr;
namespace emsg = spirula::i18n::msg::edit;
using spirula::i18n::Msg;

namespace gui {

namespace {

// Live preview while a range or a tolerance is being dragged: often enough to
// steer by, seldom enough that a colour upload per frame is not the cost.
constexpr double kPreviewEvery = 0.07;
constexpr int kAdjustRange = 1, kAdjustColour = 2;
// How much of a periodic axis is repeated, dimmed, past each seam: enough to
// drag a range across, not enough to read as a second plot.
constexpr double kPlotWrap = 0.12;

std::string number(double v) {
    char buf[32];
    std::snprintf(buf, sizeof buf, "%.4g", v);
    return buf;
}

}  // namespace


// ---------------------------------------------------------------------------
// A selection that is adjusted rather than stacked
// ---------------------------------------------------------------------------

void EditSession::begin_adjustable(int kind) {
    if (!_doc || _adjust_live) return;
    // The same CONTROL means the same attribute met the same way. A range on
    // another attribute has to meet the last one's result -- taking that back
    // first is how "blue, and also large" came out empty.
    const ImGuiIO& io = ImGui::GetIO();
    kind = kind * 4096 + (int)combine_now(io.KeyShift, io.KeyCtrl) * 1024 +
           (kind == kAdjustRange ? _axis[0].attr + 1 : 0);
    // Dragging the same control again straight after: the step it made is
    // taken back, so the new one replaces it instead of meeting its result.
    if (_adjust_kind == kind && _adjust_head >= 0 &&
        _adjust_head == _doc->history_head() && _doc->can_undo())
        _doc->undo();
    _adjust_kind = kind;
    _adjust_before = _doc->sel().weights();
    _adjust_live = true;
    _preview_at = 0.0;
}

void EditSession::preview_adjustable(const std::vector<uint8_t>& w) {
    if (!_doc || !_adjust_live) return;
    const double now = ImGui::GetTime();
    if (now - _preview_at < kPreviewEvery) return;
    _preview_at = now;
    Selection tmp;
    tmp.assign(_adjust_before);
    const ImGuiIO& io = ImGui::GetIO();
    tmp.combine(w.data(), combine_now(io.KeyShift, io.KeyCtrl), _doc->alive());
    _doc->set_selection(tmp.weights());
    _doc->mark_display_dirty();
}

void EditSession::commit_adjustable(const std::vector<uint8_t>& w,
                                    const std::string& label) {
    if (!_doc || !_adjust_live) return;
    _adjust_live = false;
    Selection tmp;
    tmp.assign(_adjust_before);
    const ImGuiIO& io = ImGui::GetIO();
    tmp.combine(w.data(), combine_now(io.KeyShift, io.KeyCtrl), _doc->alive());
    // The preview wrote the selection without a step; the step has to start
    // from what was there before it.
    _doc->set_selection(_adjust_before);
    _doc->run(make_select_op(*_doc, tmp.weights(), label, {}));
    _adjust_head = _doc->history_head();
}


// ---------------------------------------------------------------------------
// By attribute
// ---------------------------------------------------------------------------

bool EditSession::axis_current(const AttrAxis& x) const {
    if (x.index < 0 || x.index >= (int)_attrs.size()) return false;
    const Attr a = _attrs[(size_t)x.index];
    return x.attr == (int)a && x.layer == _doc->layer() &&
           x.alive == (attr_follows_alive(a) ? _doc->alive_count() : -1) &&
           x.placement == (attr_follows_placement(a) ? _doc->placement_revision() : 0);
}

bool EditSession::axis_ready(const AttrAxis& x) const {
    return axis_current(x) && !x.failed && x.values.size() == (size_t)_doc->count();
}

void EditSession::refresh_attribute() {
    if (!_doc) return;
    if (_attrs_layer != _doc->layer() || _attrs.empty()) {
        _attrs = attributes_of(*_doc);
        _attrs_layer = _doc->layer();
        _axis[0] = AttrAxis{};
        _axis[1] = AttrAxis{};
        _axis[1].index = -1;
        _range_set = false;
    }
    if (_attrs.empty()) return;
    for (int k = 0; k < 2; k++) {
        AttrAxis& x = _axis[k];
        if (x.index >= (int)_attrs.size()) x.index = k == 0 ? 0 : -1;
        if (x.index < 0) continue;
        if (!axis_current(x)) {
            const Attr a = _attrs[(size_t)x.index];
            AttrAxis next;
            next.index = x.index;
            next.attr = (int)a;
            next.layer = _doc->layer();
            next.alive = attr_follows_alive(a) ? _doc->alive_count() : -1;
            next.placement = attr_follows_placement(a) ? _doc->placement_revision() : 0;
            if (!attr_is_slow(a)) {
                next.failed = !attribute_values(*_doc, a, next.values);
                x = std::move(next);
                if (k == 0) _range_set = false;
            } else if (!busy() && !_attr_worker.joinable()) {
                // Off the GUI thread: a neighbour search over a million
                // Gaussians is seconds, and the window has to keep answering.
                _attr_job = std::move(next);
                _attr_job_axis = k;
                _cancel = false;
                _attr_busy = true;
                if (k == 0) _range_set = false;
                _attr_worker = std::thread([this, a] {
                    _attr_job.failed =
                        !attribute_values(*_doc, a, _attr_job.values, &_cancel);
                    _attr_busy = false;
                });
            }
        }
        if (axis_ready(x) && x.hist_rev != _doc->revision()) {
            x.hist.build(x.values, _doc->alive(), _doc->sel().data(),
                         attr_info(_attrs[(size_t)x.index]));
            x.hist_rev = _doc->revision();
        }
    }
}

void EditSession::draw_attribute_section(float full) {
    refresh_attribute();
    if (_attrs.empty()) {
        ui::TextDisabledWrapped(msg::none_here);
        return;
    }
    const ImGuiStyle& st = ImGui::GetStyle();
    AttrAxis& ax = _axis[0];
    const AttrInfo& info = attr_info(_attrs[(size_t)ax.index]);

    // ---- which attribute, and optionally which one against it ----
    const float label_w = std::max(ImGui::CalcTextSize(msg::axis_first.get()).x,
                                   ImGui::CalcTextSize(msg::axis_second.get()).x);
    const float combo_w = std::max(full - label_w - st.ItemInnerSpacing.x, full * 0.4f);
    ImGui::SetNextItemWidth(combo_w);
    // A rule between one cluster of the list and the next.
    auto rule = [this](int i, int prev) {
        if (prev >= 0 && attr_group(_attrs[(size_t)i]) != attr_group(_attrs[(size_t)prev]))
            ImGui::Separator();
    };
    if (ui::BeginCombo(msg::axis_first, info.name->get(), ImGuiComboFlags_HeightLarge)) {
        for (int i = 0; i < (int)_attrs.size(); i++) {
            rule(i, i - 1);
            if (ui::Selectable(*attr_info(_attrs[(size_t)i]).name, i == ax.index))
                ax.index = i;
        }
        ImGui::EndCombo();
    }
    ui::help_on_hover(*info.help);
    {
        AttrAxis& ay = _axis[1];
        const Msg& shown = ay.index >= 0 ? *attr_info(_attrs[(size_t)ay.index]).name
                                         : msg::axis_none;
        ImGui::SetNextItemWidth(combo_w);
        if (ui::BeginCombo(msg::axis_second, shown.get(), ImGuiComboFlags_HeightLarge)) {
            if (ui::Selectable(msg::axis_none, ay.index < 0)) ay.index = -1;
            ImGui::Separator();
            int prev = -1;
            for (int i = 0; i < (int)_attrs.size(); i++) {
                if (i == ax.index) continue;
                rule(i, prev);
                prev = i;
                if (ui::Selectable(*attr_info(_attrs[(size_t)i]).name, i == ay.index))
                    ay.index = i;
            }
            ImGui::EndCombo();
        }
        ui::help_on_hover(msg::axis_second_help);
        if (ay.index == ax.index) ay.index = -1;
    }

    if (_axis[1].index >= 0) {
        draw_density_plot(full);
        return;
    }
    if (!axis_ready(ax)) {
        ui::TextDisabledWrapped(ax.failed && axis_current(ax) ? msg::none_here
                                                              : emsg::working);
        return;
    }
    const AttrHistogram& hist = ax.hist;

    // ---- the plot ----
    const float h = px(96.0f);
    const ImVec2 p0 = ImGui::GetCursorScreenPos();
    ui::InvisibleButtonRaw("##histplot", ImVec2(full, h));
    const bool hovered = ImGui::IsItemHovered();
    const bool pressed = ImGui::IsItemActivated();
    const bool held = ImGui::IsItemActive();
    const bool let_go = ImGui::IsItemDeactivated();
    ImDrawList* dl = ImGui::GetWindowDrawList();
    const ImVec2 p1(p0.x + full, p0.y + h);
    dl->AddRectFilled(p0, p1, IM_COL32(18, 20, 24, 255), px(3.0f));

    // A periodic axis is drawn with a dimmed repeat of its far end on each
    // side: the data is continuous across the seam, so a range dragged across
    // it needs no gesture of its own. `u` is the axis, -wrap .. 1 + wrap.
    const double wrap = hist.periodic ? kPlotWrap : 0.0;
    const double span = 1.0 + 2.0 * wrap;
    auto to_x = [&](double u) { return p0.x + (float)((u + wrap) / span) * full; };
    const ImU32 seam = IM_COL32(255, 255, 255, 70);

    const float peak = _hist_log_counts ? std::log1p((float)hist.peak)
                                        : (float)hist.peak;
    if (peak > 0.0f) {
        const int cols = std::max(1, (int)full);
        const int per_col = std::max(1, (int)std::ceil(span * hist.bins / cols));
        for (int x = 0; x < cols; x++) {
            // A column can cover several bins or a bin several columns; the
            // tallest bin under it is what a thin spike needs to stay visible.
            const double u = ((double)x + 0.5) / cols * span - wrap;
            const double f = u - std::floor(u);
            const double left = u - 0.5 * span / cols;
            const int b0 = std::min((int)((left - std::floor(left)) * hist.bins), hist.bins - 1);
            uint32_t all = 0, sel = 0;
            for (int j = 0; j < per_col; j++) {
                int b = b0 + j;
                if (b >= hist.bins) {
                    if (!hist.periodic) break;
                    b -= hist.bins;
                }
                all = std::max(all, hist.all[(size_t)b]);
                sel = std::max(sel, hist.selected[(size_t)b]);
            }
            if (!all) continue;
            auto height = [&](uint32_t c) {
                const float v = _hist_log_counts ? std::log1p((float)c) : (float)c;
                return std::max(1.0f, v / peak * (h - px(4.0f)));
            };
            const bool repeat = u < 0.0 || u > 1.0;
            auto ink = [repeat](ImU32 c) {
                return repeat ? (c & 0x00ffffffu) | (90u << 24) : c;
            };
            dl->AddRectFilled(ImVec2(p0.x + x, p1.y - height(all)),
                              ImVec2(p0.x + x + 1, p1.y),
                              ink(attr_tint_colour(info.tint, hist.value_at(f), (float)f)));
            if (sel)
                dl->AddRectFilled(ImVec2(p0.x + x, p1.y - height(sel)),
                                  ImVec2(p0.x + x + 1, p1.y), ink(IM_COL32(255, 120, 20, 255)));
        }
    }
    if (hist.periodic)
        for (double u : {0.0, 1.0})
            dl->AddLine(ImVec2(to_x(u), p0.y), ImVec2(to_x(u), p1.y), seam);

    // ---- the range ----
    const float mx = (ImGui::GetIO().MousePos.x - p0.x) / std::max(full, 1.0f);
    const double mf = std::clamp((double)mx, 0.0, 1.0) * span - wrap;
    const double grab = px(6.0f) / std::max(full, 1.0f) * span;
    if (pressed) {
        begin_adjustable(kAdjustRange);
        // An edge can be taken hold of at any of its repeats; the range moves
        // over by whole turns so the edge in hand is the one under the pointer.
        for (int k = hist.periodic ? -1 : 0; k <= (hist.periodic ? 1 : 0) && !_range_drag; k++)
            for (int end = 0; end < 2 && !_range_drag; end++)
                if (_range_set && std::fabs(mf - (_range[end] + k)) < grab) {
                    _range_drag = end + 1;
                    _range[0] += k;
                    _range[1] += k;
                }
        if (!_range_drag) {
            _range_drag = 3;
            _range_anchor = mf;
            _range[0] = _range[1] = mf;
            _range_set = true;
        }
    }
    auto tool_answer = [&](std::vector<uint8_t>& w) {
        select_by_range(ax.values, hist, _range[0], _range[1], _range_outside,
                        _doc->alive(), w);
    };
    // A whole-number axis selects whole bins, and says so in whole numbers.
    const double half = hist.whole ? 0.5 : 0.0;
    auto shown = [&](int end) {
        double f = _range[end];
        // Round the circle: 350 to 20, never 350 to 380.
        if (hist.periodic) f -= end == 1 && f > 0.0 ? std::ceil(f) - 1.0 : std::floor(f);
        return hist.value_at(f) + (end == 0 ? half : -half);
    };
    auto snap = [&] {
        if (!hist.whole) return;
        _range[0] = std::floor(_range[0] * hist.bins + 1e-6) / hist.bins;
        _range[1] = std::ceil(_range[1] * hist.bins - 1e-6) / hist.bins;
        if (_range[1] <= _range[0]) _range[1] = _range[0] + 1.0 / hist.bins;
    };
    auto label = [&] {
        return spirula::i18n::format(
            msg::op_select_by,
            {info.name->get(), number(shown(0)), number(shown(1))});
    };
    if (held && _range_drag) {
        if (_range_drag == 1) _range[0] = mf;
        else if (_range_drag == 2) _range[1] = mf;
        else {
            _range[0] = std::min(_range_anchor, mf);
            _range[1] = std::max(_range_anchor, mf);
        }
        if (_range[0] > _range[1]) {
            std::swap(_range[0], _range[1]);
            if (_range_drag != 3) _range_drag = 3 - _range_drag;
        }
        // Once round is everything; more than once is nothing new.
        if (hist.periodic && _range[1] - _range[0] > 1.0) {
            if (_range_drag == 1) _range[0] = _range[1] - 1.0;
            else _range[1] = _range[0] + 1.0;
        }
        snap();
        std::vector<uint8_t> w;
        tool_answer(w);
        preview_adjustable(w);
    }
    if (let_go && _range_drag) {
        _range_drag = 0;
        if (hist.periodic) {
            const double turns = std::floor(_range[0]);
            _range[0] -= turns;
            _range[1] -= turns;
        }
        std::vector<uint8_t> w;
        tool_answer(w);
        commit_adjustable(w, label());
    }
    if (_range_set) {
        const ImU32 wash = IM_COL32(255, 255, 255, 34);
        auto band = [&](double a, double b) {
            const float xa = std::max(to_x(a), p0.x), xb = std::min(to_x(b), p1.x);
            if (xb > xa) dl->AddRectFilled(ImVec2(xa, p0.y), ImVec2(xb, p1.y), wash);
        };
        auto handle = [&](double u) {
            const float x = to_x(u);
            if (x < p0.x - 0.5f || x > p1.x + 0.5f) return;
            dl->AddLine(ImVec2(x, p0.y), ImVec2(x, p1.y), IM_COL32(255, 255, 255, 220), px(1.5f));
            dl->AddRectFilled(ImVec2(x - px(3.0f), p0.y + h * 0.4f),
                              ImVec2(x + px(3.0f), p0.y + h * 0.6f),
                              IM_COL32(255, 255, 255, 230), px(2.0f));
        };
        // Every repeat of the range that is on the plot.
        for (int k = hist.periodic ? -2 : 0; k <= (hist.periodic ? 1 : 0); k++) {
            const double a = _range[0] + k, b = _range[1] + k;
            if (!_range_outside) band(a, b);
            else if (hist.periodic) band(b, a + 1.0);
            else {
                band(-wrap, a);
                band(b, 1.0 + wrap);
            }
            handle(a);
            handle(b);
        }
    }
    if (hovered && !held) {
        const float x = to_x(mf);
        dl->AddLine(ImVec2(x, p0.y), ImVec2(x, p1.y), IM_COL32(255, 255, 255, 70));
        const double at = hist.value_at(hist.periodic ? mf - std::floor(mf) : mf);
        ui::SetTooltipRaw(number(hist.whole ? std::round(at) : at));
    }

    // The ends of the axis, and what the range is in the attribute's units.
    // On a periodic axis they stand at the seams, not at the ends of the plot.
    const std::string top = number(hist.end_label(true));
    const float seam0 = to_x(0.0) - p0.x, seam1 = to_x(1.0) - p0.x;
    if (seam0 > 0.0f) {
        ImGui::Dummy(ImVec2(0, 0));
        ImGui::SameLine(seam0 + px(2.0f));
    }
    ui::TextDisabledRaw(number(hist.end_label(false)));
    ImGui::SameLine(seam1 - ImGui::CalcTextSize(top.c_str()).x - (seam0 > 0.0f ? px(2.0f) : 0.0f));
    ui::TextDisabledRaw(top);

    if (_range_set) {
        // Typed ends, for a threshold somebody already knows.
        const float fw = (full - st.ItemSpacing.x) * 0.5f;
        float lo = (float)shown(0), hi = (float)shown(1);
        bool changed = false;
        ImGui::SetNextItemWidth(fw);
        ui::InputFloatRaw("##rangelo", &lo, "%.4g");
        changed |= ImGui::IsItemDeactivatedAfterEdit();
        ImGui::SameLine();
        ImGui::SetNextItemWidth(fw);
        ui::InputFloatRaw("##rangehi", &hi, "%.4g");
        changed |= ImGui::IsItemDeactivatedAfterEdit();
        if (changed && hist.periodic) {
            // Typed the other way round is the range through the seam.
            _range[0] = std::clamp(hist.frac_of(lo), 0.0, 1.0);
            _range[1] = std::clamp(hist.frac_of(hi), 0.0, 1.0);
            if (_range[1] < _range[0]) _range[1] += 1.0;
        } else if (changed) {
            _range[0] = std::clamp(hist.frac_of(std::min(lo, hi) - half), 0.0, 1.0);
            _range[1] = std::clamp(hist.frac_of(std::max(lo, hi) + half), 0.0, 1.0);
            snap();
        }
        if (changed) {
            begin_adjustable(kAdjustRange);
            std::vector<uint8_t> w;
            tool_answer(w);
            commit_adjustable(w, label());
        }
    } else {
        ui::TextDisabledWrapped(msg::range_hint);
    }
    if (hist.periodic) ui::TextDisabledWrapped(msg::periodic_hint, {info.name->get()});

    if (ui::Checkbox(msg::range_outside, &_range_outside) && _range_set) {
        begin_adjustable(kAdjustRange);
        std::vector<uint8_t> w;
        tool_answer(w);
        commit_adjustable(w, label());
    }
    ui::help_on_hover(msg::range_outside_help);
    ImGui::SameLine();
    ui::Checkbox(msg::log_counts, &_hist_log_counts);
    ui::help_on_hover(msg::log_counts_help);
}


// ---------------------------------------------------------------------------
// Two attributes against each other
// ---------------------------------------------------------------------------

namespace {

// What the viewport's tool means on a plot. The five that draw a region draw
// one here, "piece" takes the cluster under the click, and the rest fall back
// to the box.
ToolId plot_tool_for(ToolId t) {
    switch (t) {
        case ToolId::Box: case ToolId::Ellipse: case ToolId::Lasso:
        case ToolId::Polygon: case ToolId::Brush: case ToolId::Piece:
            return t;
        default:
            return ToolId::Box;
    }
}

}  // namespace

void EditSession::draw_density_plot(float full) {
    AttrAxis& ax = _axis[0];
    AttrAxis& ay = _axis[1];
    if (!axis_ready(ax) || !axis_ready(ay)) {
        const bool dead = (ax.failed && axis_current(ax)) || (ay.failed && axis_current(ay));
        ui::TextDisabledWrapped(dead ? msg::none_here : emsg::working);
        return;
    }
    const AttrInfo& ix = attr_info(_attrs[(size_t)ax.index]);
    const AttrInfo& iy = attr_info(_attrs[(size_t)ay.index]);

    const float w = std::max(full, px(80.0f));
    const float h = std::min(w * 0.82f, px(260.0f));
    // Cells on the plot, of which `ex`/`ey` at each end of a periodic axis are
    // dimmed repeats of the far end (the 1D plot's wrap, in whole cells).
    const int tx = std::clamp((int)(w / px(11.0f)), 8, 48);
    const int ty = std::clamp((int)(h / px(11.0f)), 8, 48);
    auto repeats = [](bool periodic, int total) {
        return periodic ? std::max(2, (int)std::lround(total * kPlotWrap / (1.0 + 2.0 * kPlotWrap)))
                        : 0;
    };
    const int ex = repeats(ax.hist.periodic, tx), ey = repeats(ay.hist.periodic, ty);
    const int nx = tx - 2 * ex, ny = ty - 2 * ey;
    _plot_wrap[0] = (float)ex / (float)nx;
    _plot_wrap[1] = (float)ey / (float)ny;
    const int key[4] = {ax.attr, ay.attr, nx, ny};
    if (_density_rev != _doc->revision() || std::memcmp(key, _density_key, sizeof key) ||
        _density_cell.size() != (size_t)_doc->count()) {
        _density.build(ax.values, ax.hist, ay.values, ay.hist, _doc->alive(),
                       _doc->sel().data(), nx, ny, &_density_cell);
        _density_rev = _doc->revision();
        std::memcpy(_density_key, key, sizeof key);
    }

    const ImVec2 origin = ImGui::GetCursorScreenPos();
    const ImVec2 p0 = origin;
    const ImVec2 p1(p0.x + w, p0.y + h);
    ImGui::SetCursorScreenPos(p0);
    ui::InvisibleButtonRaw("##densityplot", ImVec2(w, h));
    const bool hovered = ImGui::IsItemHovered();
    ImDrawList* dl = ImGui::GetWindowDrawList();
    dl->AddRectFilled(p0, p1, IM_COL32(18, 20, 24, 255), px(3.0f));

    // A disc per cell: its AREA the count, its colour the one the cell stands
    // for where the axes are colours, and the share of it that is selected an
    // orange sector.
    const ImU32 neutral = IM_COL32(125, 135, 150, 255), orange = IM_COL32(255, 120, 20, 255);
    const float cw = w / (float)tx, ch = h / (float)ty;
    const float rmax = 0.5f * std::min(cw, ch) * 0.94f;
    const float peak = _hist_log_counts ? std::log1p((float)_density.peak)
                                        : (float)_density.peak;
    const int kSegments = 24;
    for (int dy = 0; dy < ty && peak > 0.0f; dy++)
        for (int dx = 0; dx < tx; dx++) {
            const int cx = ((dx - ex) % nx + nx) % nx, cy = ((dy - ey) % ny + ny) % ny;
            const size_t c = (size_t)cy * nx + cx;
            const uint32_t all = _density.all[c];
            if (!all) continue;
            const bool repeat = dx < ex || dx >= ex + nx || dy < ey || dy >= ey + ny;
            auto ink = [repeat](ImU32 col) {
                return repeat ? (col & 0x00ffffffu) | (90u << 24) : col;
            };
            const float v = _hist_log_counts ? std::log1p((float)all) : (float)all;
            const float r = std::max(rmax * std::sqrt(v / peak), px(0.9f));
            const ImVec2 at(p0.x + ((float)dx + 0.5f) * cw, p1.y - ((float)dy + 0.5f) * ch);
            const float fx = ((float)cx + 0.5f) / (float)nx, fy = ((float)cy + 0.5f) / (float)ny;
            ImU32 fill = attr_pair_colour(ix, ax.hist, fx, iy, ay.hist, fy);
            const bool tinted = fill != 0;
            if (!tinted) fill = neutral;
            dl->AddCircleFilled(at, r, ink(fill), kSegments);
            // A dark colour on a dark plot still has to show how big it is.
            const ImVec4 f4 = ImGui::ColorConvertU32ToFloat4(fill);
            if (tinted && 0.2126f * f4.x + 0.7152f * f4.y + 0.0722f * f4.z < 0.3f)
                dl->AddCircle(at, r, ink(IM_COL32(150, 158, 170, 140)), kSegments, px(1.0f));
            const uint32_t sel = _density.selected[c];
            if (!sel) continue;
            if (sel >= all) {
                dl->AddCircleFilled(at, r, ink(orange), kSegments);
            } else {
                // The same polygon the disc is, as far round as the share goes.
                const float share = (float)sel / (float)all;
                dl->PathLineTo(at);
                dl->PathArcTo(at, r, -1.5707963f, -1.5707963f + 6.2831853f * share,
                              std::max(2, (int)std::ceil(kSegments * share)));
                dl->PathFillConvex(ink(orange));
            }
        }
    const ImU32 seam = IM_COL32(255, 255, 255, 70);
    for (int k = 0; k < 2 && ex > 0; k++) {
        const float x = p0.x + (float)(ex + k * nx) * cw;
        dl->AddLine(ImVec2(x, p0.y), ImVec2(x, p1.y), seam);
    }
    for (int k = 0; k < 2 && ey > 0; k++) {
        const float y = p1.y - (float)(ey + k * ny) * ch;
        dl->AddLine(ImVec2(p0.x, y), ImVec2(p1.x, y), seam);
    }

    _plot_size[0] = w;
    _plot_size[1] = h;

    // ---- the viewport's tool, drawing here ----
    const ToolId want = plot_tool_for(_tool.id());
    if (_plot_tool.id() != want) _plot_tool.set_id(want);
    _plot_tool.set_brush_radius(std::min(_tool.brush_radius(), 0.25f * std::min(w, h)));
    const ImGuiIO& io = ImGui::GetIO();
    ViewportInput in;
    in.hovered = hovered;
    in.x = io.MousePos.x - p0.x;
    in.y = io.MousePos.y - p0.y;
    in.W = (int)w;
    in.H = (int)h;
    in.down = ImGui::IsMouseDown(ImGuiMouseButton_Left);
    in.clicked = hovered && ImGui::IsMouseClicked(ImGuiMouseButton_Left);
    in.released = ImGui::IsMouseReleased(ImGuiMouseButton_Left);
    in.right_clicked = hovered && ImGui::IsMouseClicked(ImGuiMouseButton_Right);
    in.double_clicked = hovered && ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left);
    in.shift = io.KeyShift;
    in.ctrl = io.KeyCtrl;
    in.alt = io.KeyAlt;
    if (!busy()) {
        ShapeStroke stroke;
        bool consumed = false;
        if (_plot_tool.update(in, stroke, consumed)) {
            if (want == ToolId::Piece) select_plot_cluster(stroke.pts[0], stroke.pts[1], w, h);
            else apply_plot_stroke(stroke, w, h);
        }
    }
    dl->PushClipRect(p0, p1, true);
    _plot_tool.draw_overlay(dl, p0);
    dl->PopClipRect();

    if (hovered && !_plot_tool.in_progress()) {
        // Through the repeats back onto the axis itself.
        auto on_axis = [](double t, int total, int extra, int cells) {
            const double u = (std::clamp(t, 0.0, 1.0) * total - extra) / cells;
            return extra > 0 ? u - std::floor(u) : std::clamp(u, 0.0, 1.0);
        };
        const double fx = on_axis(in.x / w, tx, ex, nx);
        const double fy = on_axis(1.0 - in.y / h, ty, ey, ny);
        const int cx = std::min((int)(fx * nx), nx - 1), cy = std::min((int)(fy * ny), ny - 1);
        ui::SetTooltipRaw(number(ax.hist.value_at(fx)) + ", " + number(ay.hist.value_at(fy)) +
                          "   [" + std::to_string(_density.all[(size_t)cy * nx + cx]) + "]");
    }

    // The ends of both axes: x under the plot, y beside the name of the tool
    // that is drawing.
    ImGui::SetCursorScreenPos(ImVec2(origin.x, p1.y + px(2.0f)));
    const std::string right = number(ax.hist.end_label(true));
    const float seam0 = (float)ex * cw, seam1 = (float)(ex + nx) * cw;
    if (ex > 0) {
        ImGui::Dummy(ImVec2(0, 0));
        ImGui::SameLine(seam0 + px(2.0f));
    }
    ui::TextDisabledRaw(number(ax.hist.end_label(false)));
    ImGui::SameLine(seam1 - ImGui::CalcTextSize(right.c_str()).x - (ex > 0 ? px(2.0f) : 0.0f));
    ui::TextDisabledRaw(right);
    ui::TextDisabled(msg::plot_y_range, {number(ay.hist.end_label(false)),
                                         number(ay.hist.end_label(true))});
    ui::TextDisabledWrapped(msg::plot_hint, {tool_label(want).get()});
    for (const AttrAxis* a : {&ax, &ay})
        if (a->hist.periodic)
            ui::TextDisabledWrapped(msg::periodic_hint,
                                    {attr_info(_attrs[(size_t)a->index]).name->get()});
    ui::Checkbox(msg::log_counts, &_hist_log_counts);
    ui::help_on_hover(msg::log_counts_help);
}

void EditSession::apply_plot_stroke(const ShapeStroke& s, float w, float h) {
    const AttrAxis& ax = _axis[0];
    const AttrAxis& ay = _axis[1];
    if (!axis_ready(ax) || !axis_ready(ay)) return;
    const int W = std::max(1, (int)w), H = std::max(1, (int)h);
    Stencil st;
    rasterize_shape(s, W, H, st);
    const int64_t n = _doc->count();
    const uint8_t* alive = _doc->alive();
    const double wx = _plot_wrap[0], wy = _plot_wrap[1];
    std::vector<uint8_t> hit((size_t)n, 0);
#pragma omp parallel for schedule(static)
    for (int64_t i = 0; i < n; i++) {
        if (!alive[i]) continue;
        const float vx = ax.values[(size_t)i], vy = ay.values[(size_t)i];
        if (std::isnan(vx) || std::isnan(vy)) continue;
        // Exactly where the density plot put it, ends of the axes included --
        // and at each repeat of it, so a stroke across a seam takes both sides.
        const double fx = std::clamp(ax.hist.frac_of(vx), 0.0, 1.0);
        const double fy = std::clamp(ay.hist.frac_of(vy), 0.0, 1.0);
        bool in = false;
        for (int ky = wy > 0 ? -1 : 0; ky <= (wy > 0 ? 1 : 0) && !in; ky++)
            for (int kx = wx > 0 ? -1 : 0; kx <= (wx > 0 ? 1 : 0) && !in; kx++) {
                const double ux = fx + kx, uy = fy + ky;
                if (ux < -wx || ux > 1.0 + wx || uy < -wy || uy > 1.0 + wy) continue;
                const int x = std::min((int)((ux + wx) / (1.0 + 2.0 * wx) * W), W - 1);
                const int y = std::min((int)((1.0 - (uy + wy) / (1.0 + 2.0 * wy)) * H), H - 1);
                in = st.at(x, y);
            }
        if (in) hit[(size_t)i] = 255;
    }
    const ImGuiIO& io = ImGui::GetIO();
    Selection next;
    next.assign(_doc->sel().weights());
    next.combine(hit.data(), combine_now(io.KeyShift, io.KeyCtrl), alive);
    run_select(next.weights(),
               spirula::i18n::format(
                   msg::op_select_by2,
                   {attr_info(_attrs[(size_t)ax.index]).name->get(),
                    attr_info(_attrs[(size_t)ay.index]).name->get()}));
}

// A cluster in attribute space: the occupied cells that touch the clicked
// one. Cells holding under a hundredth of the fullest do not join blobs up,
// or one stray element would bridge the sky to the ground.
void EditSession::select_plot_cluster(float x, float y, float w, float h) {
    const int nx = _density.nx, ny = _density.ny;
    if (nx <= 0 || _density_cell.size() != (size_t)_doc->count()) return;
    const int ex = (int)std::lround(_plot_wrap[0] * nx), ey = (int)std::lround(_plot_wrap[1] * ny);
    auto cell = [](float t, int cells, int extra) {
        const int d = (int)std::floor(std::clamp(t, 0.0f, 0.9999f) * (cells + 2 * extra)) - extra;
        return ((d % cells) + cells) % cells;
    };
    const int cx = cell(x / w, nx, ex), cy = cell(1.0f - y / h, ny, ey);
    const uint32_t floor_count = std::max<uint32_t>(1, _density.peak / 100);
    std::vector<uint8_t> in_blob((size_t)nx * ny, 0);
    std::vector<int> stack;
    if (_density.all[(size_t)cy * nx + cx] > 0) {
        stack.push_back(cy * nx + cx);
        in_blob[(size_t)cy * nx + cx] = 1;
    }
    while (!stack.empty()) {
        const int c = stack.back();
        stack.pop_back();
        for (int dy = -1; dy <= 1; dy++)
            for (int dx = -1; dx <= 1; dx++) {
                int ux = c % nx + dx, uy = c / nx + dy;
                // A blob of reds is one blob, on both sides of the seam.
                if (ex > 0) ux = (ux + nx) % nx;
                if (ey > 0) uy = (uy + ny) % ny;
                if (ux < 0 || uy < 0 || ux >= nx || uy >= ny) continue;
                const size_t u = (size_t)uy * nx + ux;
                if (in_blob[u] || _density.all[u] < floor_count) continue;
                in_blob[u] = 1;
                stack.push_back((int)u);
            }
    }
    const int64_t n = _doc->count();
    std::vector<uint8_t> hit((size_t)n, 0);
    for (int64_t i = 0; i < n; i++) {
        const int32_t c = _density_cell[(size_t)i];
        if (c >= 0 && in_blob[(size_t)c]) hit[(size_t)i] = 255;
    }
    const ImGuiIO& io = ImGui::GetIO();
    Selection next;
    next.assign(_doc->sel().weights());
    next.combine(hit.data(), combine_now(io.KeyShift, io.KeyCtrl), _doc->alive());
    run_select(next.weights(),
               spirula::i18n::format(
                   msg::op_select_by2,
                   {attr_info(_attrs[(size_t)_axis[0].index]).name->get(),
                    attr_info(_attrs[(size_t)_axis[1].index]).name->get()}));
}


// ---------------------------------------------------------------------------
// By colour
// ---------------------------------------------------------------------------

void EditSession::run_colour(bool commit) {
    if (!_doc || _samples.empty()) return;
    const uint64_t key = ((uint64_t)_doc->layer() << 48) ^ (uint64_t)_doc->count();
    if (_colours_key != key || _colours.size() != (size_t)_doc->count() * 3) {
        if (!_doc->colours(_colours)) {
            _colours.clear();
            return;
        }
        _colours_key = key;
    }
    std::vector<uint8_t> w;
    select_by_colour(_colours, _samples.data(), (int)_samples.size() / 3,
                     _colour_tol, _colour_light, _doc->alive(), w);
    begin_adjustable(kAdjustColour);
    if (commit) commit_adjustable(w, msg::op_select_colour.get());
    else preview_adjustable(w);
}

void EditSession::pick_colour(float px_, float py_, bool append) {
    ViewProjection vp;
    if (!_doc || !view(vp)) return;
    const int64_t hit = pick_element(*_doc, vp, px_, py_, 16.0f);
    if (hit < 0) return;
    std::vector<float> rgb;
    if (!_doc->colours(rgb) || (int64_t)rgb.size() < (hit + 1) * 3) return;
    // Shift adds a sample: a sky is a gradient, and one click is one blue.
    if (!append) {
        _samples.clear();
        // A fresh colour is a new selection, not a correction of the last.
        _adjust_head = -1;
    }
    if (_samples.size() >= 8 * 3) _samples.erase(_samples.begin(), _samples.begin() + 3);
    _samples.insert(_samples.end(), rgb.begin() + hit * 3, rgb.begin() + hit * 3 + 3);
    _adjust_live = false;
    run_colour(/*commit=*/true);
}

void EditSession::draw_colour_section(float full) {
    if (!_doc->colours_available()) {
        ui::TextDisabledWrapped(msg::no_colour_here);
        return;
    }
    const ImGuiStyle& st = ImGui::GetStyle();
    ui::TextDisabledWrapped(msg::colour_hint);

    bool edited = false;
    for (int i = 0; i < (int)_samples.size() / 3; i++) {
        if (i) ImGui::SameLine();
        ImGui::PushID(i);
        edited |= ui::ColorEdit3Raw("##sample", &_samples[(size_t)i * 3],
                                    ImGuiColorEditFlags_NoInputs |
                                        ImGuiColorEditFlags_NoLabel |
                                        ImGuiColorEditFlags_Float |
                                        ImGuiColorEditFlags_HDR);
        if (ImGui::IsItemClicked(ImGuiMouseButton_Right)) {
            _samples.erase(_samples.begin() + i * 3, _samples.begin() + i * 3 + 3);
            edited = true;
            ImGui::PopID();
            break;
        }
        ImGui::PopID();
    }
    if (!_samples.empty()) ImGui::SameLine();
    if (ui::Button(msg::colour_add)) {
        _samples.insert(_samples.end(), {0.5f, 0.5f, 0.5f});
        edited = true;
    }
    ui::help_on_hover(msg::colour_add_help);

    float label_w = std::max(ImGui::CalcTextSize(msg::colour_tolerance.get()).x,
                             ImGui::CalcTextSize(msg::colour_lightness.get()).x);
    const float sw = std::max(full - label_w - st.ItemInnerSpacing.x, full * 0.3f);
    bool live = false, done = false;
    ImGui::SetNextItemWidth(sw);
    live |= ui::SliderFloat(msg::colour_tolerance, &_colour_tol, 0.005f, 0.5f, "%.3f");
    done |= ImGui::IsItemDeactivatedAfterEdit();
    ui::help_on_hover(msg::colour_tolerance_help);
    ImGui::SetNextItemWidth(sw);
    live |= ui::SliderFloat(msg::colour_lightness, &_colour_light, 0.0f, 1.0f, "%.2f");
    done |= ImGui::IsItemDeactivatedAfterEdit();
    ui::help_on_hover(msg::colour_lightness_help);

    if (_samples.empty()) return;
    if (done || edited) run_colour(true);
    else if (live) run_colour(false);
}

}  // namespace gui
