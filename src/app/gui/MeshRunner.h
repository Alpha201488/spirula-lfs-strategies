#pragma once

// MeshRunner -- surface extraction from a trained model, driven from the GUI.
//
// Same public shape as SfmRunner / ColmapRunner (start / cancel / state /
// stage / error / drain_log), and for the same reason it runs as a CHILD
// PROCESS rather than in this one: the GUI already has a Vulkan device live
// (the viewer's), meshing wants its own multi-gigabyte VRAM budget for the
// per-camera renders, and every byte it held is gone when it exits. The child
// is this same executable (`spirula mesh`), so there is nothing to install.
//
// The stages come from the child's own `[meshing] <stage> (<secs>s)` lines,
// which both backends print, so the panel reports real progress rather than a
// spinner.

#include "app/gui/MeshJob.h"

#include <atomic>
#include <cstdint>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

namespace gui {

class MeshRunner {
public:
    enum class State { Idle, Running, Done, Failed, Cancelled };

    ~MeshRunner();

    void start(const MeshJob& job);
    void cancel();

    State state() const { return _state.load(); }
    bool busy() const { return _state.load() == State::Running; }
    // Which run the current state belongs to; 0 before the first start().
    // A finished runner STAYS Done, so "has a result the screen has not shown
    // yet" cannot be read off state() alone -- close the preview and it would
    // reopen on the next frame. The caller remembers the id it has shown.
    uint64_t run_id() const { return _run_id.load(); }

    std::string stage();
    std::string error();
    // The mesh file written, valid once state() == Done.
    std::string output_path();
    // Every file the run left on disk. One extraction can be asked for
    // several formats and colors, and they are all the same surface.
    std::vector<std::string> output_paths();
    // Vertices / faces reported by the child's final line, 0 until then.
    int64_t num_verts() const { return _verts.load(); }
    int64_t num_faces() const { return _faces.load(); }
    // 0..1 over the pipeline's stages, or -1 before the first one. Between
    // two stage marks it creeps with elapsed time toward the next mark, so a
    // long silent phase (Delaunay is minutes on a big model) still LOOKS like
    // it is running; a phase that reports "i/n" overrides the creep with the
    // real fraction.
    float progress() const;

    std::vector<std::string> drain_log();

private:
    void run(MeshJob job);
    void log(const std::string& line);
    void note_line(const std::string& line);

    std::thread _worker;
    std::atomic<State> _state{State::Idle};
    std::atomic<bool> _cancel{false};
    std::atomic<uint64_t> _run_id{0};
    // The bracket the bar is currently inside, and when it was entered.
    std::atomic<float> _stage_lo{-1.0f}, _stage_hi{-1.0f}, _stage_frac{-1.0f};
    std::atomic<double> _stage_at{0.0};
    std::atomic<int64_t> _verts{0}, _faces{0};
    std::mutex _mu;
    std::string _stage, _error, _output;
    std::vector<std::string> _outputs;
    std::vector<std::string> _log;
};

}  // namespace gui
