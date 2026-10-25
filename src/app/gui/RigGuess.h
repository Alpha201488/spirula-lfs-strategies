#pragma once

// Which camera folders are one rig, guessed from their names: folders whose
// names differ in exactly one token (left/right, cam0/cam1) and whose image
// file names match are the lenses of one rig. No GUI and no disk access.

#include <string>
#include <vector>

namespace gui {

struct RigCandidate {
    std::string name;                  // the folder, e.g. "walk1/left"
    std::vector<std::string> images;   // file stems, sorted and unique
};

// One entry per candidate: -1 for no rig, else the rig's index, numbered in
// order of first appearance.
std::vector<int> guess_rigs(const std::vector<RigCandidate>& folders);

}  // namespace gui
