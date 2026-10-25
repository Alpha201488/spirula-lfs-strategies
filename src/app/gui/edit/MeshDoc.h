#pragma once

// The triangle-mesh document. An element is a VERTEX, as it is in every mesh
// editor, and deleting one takes the faces that used it with it -- which is
// what "cut this away" means to anyone who has done it before.
//
// A textured mesh is shown with its atlas sampled into vertex colours while
// it is being edited, because that is the only channel a selection has to
// show itself in. The file keeps its texture.

#include "app/gui/edit/EditDoc.h"
#include "app/gui/edit/SelectShape.h"
#include "mesh/MeshExport.h"

#include <cstdint>
#include <functional>
#include <string>
#include <vector>

namespace gui {

// Which faces an edit removed, said two ways. BY INDEX is the one that
// works: one run writes the same triangles in the same order in every format.
// Centroids within a TOLERANCE are the fallback, since an OBJ writes decimal.
struct FaceCut {
    std::vector<uint8_t> drop;                    // per face of the edited mesh
    std::vector<std::array<float, 3>> centroids;  // of the dropped faces
    float tolerance = 0.0f;
    bool empty() const { return centroids.empty(); }
};

// `src` without the faces `cut` names, its vertices compacted.
void mesh_drop_faces(const meshing::MeshData& src, const FaceCut& cut,
                     meshing::MeshData& out);

class MeshDoc : public EditDoc {
public:
    // `to_view` is the mesh's own frame into the one the viewport navigates,
    // row-major 3x4 (SplatViewer::mesh_to_normalized).
    MeshDoc(meshing::MeshData mesh, const std::string& source,
            const float to_view[12],
            std::function<void(const meshing::MeshData&, const float*)> show);

    Kind kind() const override { return Kind::Mesh; }
    // The face under the cursor, by ray intersection: on a surface of big
    // flat triangles the nearest VERTEX is somewhere else entirely.
    int64_t pick(const ViewProjection& view, float px, float py) const override;

    // A mesh knows what is joined to what; a distance grid would call a
    // sparse floater several pieces and a dense wall one.
    const int32_t* topology(int64_t& pairs) const override {
        pairs = (int64_t)_edges.size() / 2;
        return _edges.data();
    }
    std::vector<SaveTarget> save_targets() const override;
    void save(int target, const std::string& path,
              std::atomic<int>* progress) override;
    int save_steps(int target) const override;
    int linked_count() const override { return (int)_siblings.size(); }
    void set_linked(bool on) override { _link = on; }
    std::string default_save_path(int target) const override;
    void revert_display() override;
    spirula::Sim3 view_frame() const override {
        return spirula::Sim3::from_3x4(_t2n);
    }
    bool normals(std::vector<float>& n, std::vector<float>& w) const override;
    bool colours(std::vector<float>& rgb) const override;
    const meshing::MeshData* mesh() const override { return &_m; }
    bool colours_available() const override;

    // The other files one meshing run wrote: the same surface in another
    // format, so a face deleted here can be deleted there too.
    void set_siblings(std::vector<std::string> paths);
    // ... and so a face deleted here is gone from the panes showing them.
    // Called with the deleted faces whenever the live set changes.
    void set_sibling_preview(std::function<void(const FaceCut&)> f) {
        _preview_siblings = std::move(f);
    }

    int64_t live_faces() const { return _live_faces; }
    // The faces this edit has deleted.
    FaceCut dropped_faces() const;

protected:
    void publish_impl(bool geometry) override;

private:
    meshing::MeshData _m;
    meshing::MeshData _display;
    std::vector<int32_t> _edges;      // vertex pairs, three per face
    std::vector<std::string> _siblings;
    std::function<void(const FaceCut&)> _preview_siblings;
    bool _link = true;
    float _t2n[12] = {1,0,0,0, 0,1,0,0, 0,0,1,0};
    int64_t _live_faces = 0;
    std::function<void(const meshing::MeshData&, const float*)> _show;
};

}  // namespace gui
