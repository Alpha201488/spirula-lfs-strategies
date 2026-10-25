#pragma once

// The Gaussian document: a splat PLY open for editing, drawn out of the
// engine scene slot it was uploaded into.
//
// A delete rides on the opacity array and a selection on the DC colour, so an
// edit costs ONE attribute upload rather than the whole model -- which is
// what makes a brush stroke over a million Gaussians feel like a brush
// stroke. The cull that makes it free is the projection's ALPHA_THRESHOLD.

#include "app/gui/edit/EditDoc.h"
#include "app/gui/edit/SelectShape.h"
#include "checkpoint/SplatPly.h"

#include <mutex>

namespace gui {

class SplatDoc : public EditDoc {
public:
    // `slot` is the engine scene slot already holding this model and `mu` the
    // mutex its renderer takes; both outlive the document. `to_view` is the
    // file frame into the one the viewport navigates, row-major 3x4.
    SplatDoc(spirula::SplatCloud cloud, const std::string& source,
             const float to_view[12], int slot, std::mutex* mu);

    Kind kind() const override { return Kind::Splats; }
    // The Gaussian the eye lands on: the one at which the pixel's ray has
    // lost half its light, not the haze floating in front of it.
    int64_t pick(const ViewProjection& view, float px, float py) const override;
    std::vector<SaveTarget> save_targets() const override;
    void save(int target, const std::string& path,
              std::atomic<int>* progress) override;
    std::string default_save_path(int target) const override;
    void revert_display() override;
    spirula::Sim3 view_frame() const override { return _to_view; }
    bool normals(std::vector<float>& n, std::vector<float>& w) const override;
    bool colours(std::vector<float>& rgb) const override;
    bool colours_available() const override { return true; }
    const spirula::SplatCloud* splats() const override { return &_c; }
    const float* solidity() const override { return _solid.data(); }
    // Whether the file stores LINEAR colour, which the run's config says and
    // the file does not; the colour attributes are display-referred.
    void set_linear_colour(bool on) { _linear = on; }

protected:
    void publish_impl(bool geometry) override;

private:
    spirula::SplatCloud _c;
    spirula::Sim3 _to_view;
    bool _linear = false;
    std::vector<float> _opacity;      // upload scratch, alive-masked
    std::vector<float> _dc;           // upload scratch, selection-tinted
    std::vector<float> _solid;        // opacity, zeroed for the oversized
    int _slot = -1;
    std::mutex* _mu = nullptr;
};

}  // namespace gui
