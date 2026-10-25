#pragma once

// A seed cloud drawn at random around the cameras, for a dataset that came
// without one (`--random-init`). The shape of the cloud is the cameras' own
// spread about a centre; docs/datasets.md, "Seed points".

#include "data/DatasetParser.h"

#include <array>
#include <cstdint>
#include <string>

struct RandomPointsConfig {
    int64_t count = 0;
    // The `random_init_*` choices of config/TrainConfig.h.
    std::string distribution = "isotropic-gaussian";
    std::string center = "camera-median";
    std::string spread = "median";
    double std_scale = 1.0;
    uint64_t seed = 42;
};

// What was drawn: the centre, and the standard deviation along each principal
// axis of the camera spread, largest first (all three equal when isotropic).
struct RandomPointsFit {
    std::array<double, 3> center{};
    std::array<double, 3> sigma{};
};

// `cfg.count` points with uniform random 8-bit colours, in the frame of
// c2w [N,3,4]. Throws when the cameras do not spread about the centre.
ColmapPoints3D random_seed_points(const float* c2w, int64_t n,
                                  const RandomPointsConfig& cfg,
                                  RandomPointsFit* fit = nullptr);
