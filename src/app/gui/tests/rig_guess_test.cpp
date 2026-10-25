// rig_guess_test -- app/gui/RigGuess.h on folder lists whose rigs are known.

#include "app/gui/RigGuess.h"

#include <cstdio>
#include <string>
#include <vector>

using gui::RigCandidate;

namespace {

int g_failures = 0;

void check(bool ok, const std::string& what) {
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", what.c_str());
    if (!ok) g_failures++;
}

std::vector<std::string> frames(int first, int count) {
    std::vector<std::string> out;
    char buf[32];
    for (int i = first; i < first + count; i++) {
        std::snprintf(buf, sizeof buf, "frame_%05d", i);
        out.push_back(buf);
    }
    return out;
}

bool same(const std::vector<int>& got, const std::vector<int>& want) {
    return got == want;
}

}  // namespace

int main() {
    // Five walks on a stereo rig: split on the lens, not on the walk, even
    // though both vary in one token and every walk numbers its frames alike.
    {
        std::vector<RigCandidate> f;
        const int lengths[] = {120, 95, 140, 80, 111};
        for (int w = 0; w < 5; w++)
            for (const char* side : {"left", "right"})
                f.push_back({"walk" + std::to_string(w + 1) + "_" + side,
                             frames(0, lengths[w])});
        check(same(gui::guess_rigs(f), {0, 0, 1, 1, 2, 2, 3, 3, 4, 4}),
              "five stereo walks become five rigs");
    }
    // cam0/cam1 in the middle of the name, camel case around it.
    {
        std::vector<RigCandidate> f = {
            {"HouseCam0Day", frames(0, 50)}, {"HouseCam1Day", frames(0, 50)},
            {"HouseCam2Day", frames(0, 50)}, {"GardenCam0Day", frames(0, 30)},
            {"GardenCam1Day", frames(0, 30)}, {"GardenCam2Day", frames(0, 30)}};
        check(same(gui::guess_rigs(f), {0, 0, 0, 1, 1, 1}), "three-lens rigs by camera index");
    }
    // Two unrelated photo folders: numbered alike, but the frames differ.
    {
        std::vector<RigCandidate> f = {{"day1", frames(0, 40)}, {"day2", frames(500, 40)}};
        check(same(gui::guess_rigs(f), {-1, -1}), "disjoint file names are no rig");
    }
    // Two clips under one numbering, one twice as long: another capture.
    {
        std::vector<RigCandidate> f = {{"clip1", frames(0, 100)}, {"clip2", frames(0, 200)}};
        check(same(gui::guess_rigs(f), {-1, -1}), "a much longer folder is no lens");
    }
    // A lens that dropped a few frames still belongs.
    {
        std::vector<RigCandidate> f = {{"front", frames(0, 100)}, {"back", frames(3, 95)},
                                       {"notes", {}}};
        check(same(gui::guess_rigs(f), {0, 0, -1}), "a few dropped frames are tolerated");
    }
    return g_failures == 0 ? 0 : 1;
}
