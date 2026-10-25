#pragma once

// A camera move flown by hand, turned into keyframes: still ends trimmed,
// timed anew between as flown and one steady pace, and the fewest keys kept
// that follow it within a tolerance. docs/notes/render-video.md.

#include "app/gui/render/RenderProject.h"

#include <vector>

namespace gui::render {

struct FlightSample {
    double t = 0.0;                     // seconds since the recording began
    double pos[3] = {0, 0, 0};
    double rot[4] = {1, 0, 0, 0};       // camera-to-world, (w, x, y, z)
};

struct FlightFit {
    // 1 keeps the pace as flown, stops and all; 0 is one steady pace, which
    // rushes a cramped stretch. Between, stops drop out and the slow parts
    // stay somewhat slow.
    double timing = 0.5;
    double detail = 0.5;                // 0 few keys, loose; 1 many, close
    double length = 0.0;                // seconds; 0 for the flight's own
};

// The length the flight takes at `fit.timing`, stops and still ends out.
double flight_length(const std::vector<FlightSample>& flight, const FlightFit& fit, double unit);

// The flight's keys into `p`, and a motion that plays them as fitted: a
// spline, no easing. `unit` is what a radian of turn weighs, world units --
// the scene's size. The number of keys; 0 when nothing moved.
int fit_flight(const std::vector<FlightSample>& flight, const FlightFit& fit, double unit,
               const Lens& lens, RenderProject& p);

}  // namespace gui::render
