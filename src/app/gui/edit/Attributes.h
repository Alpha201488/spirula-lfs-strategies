#pragma once

// Per-element scalars a selection can be made from, and the histogram they
// are brushed on. One table: a name, where the numbers come from and how they
// want to be looked at, so the panel is generated from it and the twentieth
// attribute is a row rather than a feature.
//
// A document offers raw material -- a colour per element, the Gaussians
// themselves, its cameras -- and everything derived from that lives here.

#include "core/Similarity.h"

#include <atomic>
#include <cstdint>
#include <vector>

namespace spirula { namespace i18n { struct Msg; } }

namespace gui {

class EditDoc;

enum class Attr : int {
    // Where it is, in the coordinates it will be SAVED in.
    PosX = 0, PosY, PosZ,
    // A Gaussian's shape. "Extent" is the scale times sqrt(2 ln(opacity *
    // 255)): how far out it still reaches the rasterizer's alpha cut.
    Opacity, ScaleMax, ScaleMin, ScaleMean, ExtentMax, ExtentMin, ExtentMean,
    AnisoRatio, Erank,
    // Its base colour, display-referred and unclamped.
    Red, Green, Blue, Luma, ChromaU, ChromaV, Hue, Saturation,
    // A sparse point's distance to the nearest camera.
    CameraDistance,
    // How far from the saved origin, and how crowded: the median distance to
    // the k nearest neighbours, which is large for whatever floats alone.
    OriginDistance, Knn4, Knn16, Knn64,
    // A mesh vertex, by the faces and edges around it. Seam copies the atlas
    // split are counted as the one vertex they were.
    FaceAngleMin, FaceAngleMax, DihedralMax, Valence, EdgeFacesMin,
    EdgeFacesMax, FaceArea, EdgeLength, PieceSize,
    // A reconstructed point, by who saw it (COLMAP tracks) and who could have.
    TrackLength, ReprojError, TriangulationAngle, InViewCount,
    // A camera: its lens, which way it looks, and how alone it is.
    FocalLength, FieldOfView, Elevation, Roll, Heading, LookAway,
    NeighbourDistance, PointsSeen,
    Count
};

// How the histogram bars are coloured, where that says something.
enum class AttrTint { None, Red, Green, Blue, Gray, Hue, Saturation, BlueYellow, RedCyan };

struct AttrInfo {
    Attr id;
    const spirula::i18n::Msg* name;
    const spirula::i18n::Msg* help;
    bool log;            // spans decades: bin its log10
    AttrTint tint;
    // A range that is the attribute's own rather than the data's: a hue is
    // 0..360 whatever the model holds. lo == hi leaves it to the data.
    double lo = 0.0, hi = 0.0;
    // Whole numbers: one bin each, or the plot is a comb.
    bool integer = false;
    // The top of the range IS the bottom again (a hue, a compass heading).
    bool periodic = false;
};
const AttrInfo& attr_info(Attr a);
// Worth a worker thread: a neighbour search, a pass over every camera per
// point, a file to read.
bool attr_is_slow(Attr a);
// Whether the values move when the live set does (neighbours, topology) or
// when the placement does (anything in saved coordinates or units).
bool attr_follows_alive(Attr a);
bool attr_follows_placement(Attr a);
// The bar colour at attribute value `v`, `frac` of the way along the axis.
unsigned attr_tint_colour(AttrTint tint, double v, float frac);
// Which cluster of the panel's list an attribute belongs to; the list draws a
// rule where it changes.
int attr_group(Attr a);

// What the document's CURRENT layer can be asked for, in panel order.
std::vector<Attr> attributes_of(const EditDoc& doc);
// One value per element; NaN where the element has none. False when the
// layer does not carry what `a` needs.
bool attribute_values(const EditDoc& doc, Attr a, std::vector<float>& out,
                      const std::atomic<bool>* cancel = nullptr);

// 256 bins over a robust range of the LIVE values -- the 0.2th to the 99.8th
// percentile, so the three floaters a kilometre out do not squash everything
// else into one bin. The two end bins also hold what lies beyond them.
struct AttrHistogram {
    static constexpr int kBins = 256;
    int bins = kBins;                   // fewer for a whole-number attribute
    bool whole = false;                 // one bin per whole number
    bool periodic = false;              // fraction 1 is fraction 0 again
    bool log = false;
    double lo = 0.0, hi = 1.0;          // bin-axis range (log10 when `log`)
    std::vector<uint32_t> all, selected;
    uint32_t peak = 0;
    int64_t live = 0;

    void build(const std::vector<float>& v, const uint8_t* alive,
               const uint8_t* sel, const AttrInfo& info);
    // The attribute value at a fraction 0..1 across the axis, and back.
    double value_at(double frac) const;
    double frac_of(double value) const;
    // What to print at an end of the axis: a whole-number axis ends half a
    // bin past its last value.
    double end_label(bool top) const {
        return whole ? (top ? hi - 0.5 : lo + 0.5) : value_at(top ? 1.0 : 0.0);
    }
};

// The colour of the plot cell at fractions `fa`, `fb` of the two axes, 0 when
// neither axis has one. Two colour attributes are read TOGETHER (hue with
// saturation IS that colour); a pair that contradicts itself comes out grey.
unsigned attr_pair_colour(const AttrInfo& a, const AttrHistogram& ha, float fa,
                          const AttrInfo& b, const AttrHistogram& hb, float fb);

// Live elements within the fractions [f0, f1] of `h`'s axis. An end at 0 or
// 1 is open: that is where the out-of-range values were binned. On a periodic
// axis the range runs UP from f0 to f1 through the seam (f1 may pass 1).
void select_by_range(const std::vector<float>& v, const AttrHistogram& h,
                     double f0, double f1, bool outside, const uint8_t* alive,
                     std::vector<uint8_t>& out);

// Two attributes against each other: counts on an nx x ny grid over the two
// histograms' axes, row 0 at the BOTTOM. `cell_of`, when given, comes back
// with each element's cell, or -1 for one that has no place on the plot.
struct AttrDensity {
    int nx = 0, ny = 0;
    std::vector<uint32_t> all, selected;
    uint32_t peak = 0;
    void build(const std::vector<float>& x, const AttrHistogram& hx,
               const std::vector<float>& y, const AttrHistogram& hy,
               const uint8_t* alive, const uint8_t* sel, int nx_, int ny_,
               std::vector<int32_t>* cell_of = nullptr);
};

// Within `tolerance` of ANY of the `k` samples, in OKLab -- where equal
// distances look equally different. Both arrays are [., 3] display-referred;
// `lightness_weight` 0 ignores how bright a colour is.
void select_by_colour(const std::vector<float>& rgb, const float* samples,
                      int k, float tolerance, float lightness_weight,
                      const uint8_t* alive, std::vector<uint8_t>& out);

}  // namespace gui
