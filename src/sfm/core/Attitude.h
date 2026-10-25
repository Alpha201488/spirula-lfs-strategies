// The attitude a drone records with each photo -- where the camera pointed,
// against north and the horizon -- and the rotation it names. Read from the XMP
// packet; DJI's `drone-dji:Gimbal{Yaw,Pitch,Roll}Degree` is the writer
// understood. map/AttitudeGauge.h consumes it.
#pragma once

#include <cctype>
#include <cmath>
#include <cstdlib>
#include <string>

#include "sfm/core/Exif.h"
#include "sfm/geometry/LinAlg.h"

namespace sfm {

// Z-Y-X Euler angles of the camera body (forward, right, down) in
// north-east-down, degrees: yaw clockwise from north seen from above, pitch up
// from the horizon, roll clockwise about the forward axis.
struct CameraAttitude {
    bool valid = false;
    double yaw_deg = 0, pitch_deg = 0, roll_deg = 0;
};

namespace detail {

// One numeric XMP property, as an attribute (`ns:Name="+1.5"`) or as an
// element (`<ns:Name>+1.5</ns:Name>`).
inline bool xmpNumber(const std::string& xmp, const std::string& name, double& out) {
    auto space = [&](size_t i) { return std::isspace((unsigned char)xmp[i]) != 0; };
    for (size_t at = xmp.find(name); at != std::string::npos; at = xmp.find(name, at + 1)) {
        const char prev = at > 0 ? xmp[at - 1] : ' ';
        size_t p = at + name.size();
        while (p < xmp.size() && space(p)) p++;
        if (p >= xmp.size()) return false;
        if (xmp[p] == '=' && std::isspace((unsigned char)prev)) {
            for (p++; p < xmp.size() && space(p); p++) {}
            if (p >= xmp.size() || (xmp[p] != '"' && xmp[p] != '\'')) continue;
        } else if (!(xmp[p] == '>' && prev == '<')) {
            continue;
        }
        const char* s = xmp.c_str() + p + 1;
        char* end = nullptr;
        const double v = std::strtod(s, &end);
        if (end == s || !std::isfinite(v)) return false;
        out = v;
        return true;
    }
    return false;
}

}  // namespace detail

inline CameraAttitude parseCameraAttitude(const std::string& xmp) {
    CameraAttitude a;
    a.valid = detail::xmpNumber(xmp, "drone-dji:GimbalYawDegree", a.yaw_deg) &&
              detail::xmpNumber(xmp, "drone-dji:GimbalPitchDegree", a.pitch_deg) &&
              detail::xmpNumber(xmp, "drone-dji:GimbalRollDegree", a.roll_deg);
    return a;
}

inline CameraAttitude readCameraAttitude(const std::string& path) {
    return parseCameraAttitude(readXmpPacket(path));
}

// Camera -> world, the world east-north-up and the camera x right, y down,
// z forward, as a model's poses are.
inline Mat3 attitudeWorldFromCamera(const CameraAttitude& a) {
    const double d = M_PI / 180.0;
    const double cy = std::cos(a.yaw_deg * d), sy = std::sin(a.yaw_deg * d);
    const double cp = std::cos(a.pitch_deg * d), sp = std::sin(a.pitch_deg * d);
    const double cr = std::cos(a.roll_deg * d), sr = std::sin(a.roll_deg * d);
    const Mat3 yaw{cy, -sy, 0, sy, cy, 0, 0, 0, 1};
    const Mat3 pitch{cp, 0, sp, 0, 1, 0, -sp, 0, cp};
    const Mat3 roll{1, 0, 0, 0, cr, -sr, 0, sr, cr};
    const Mat3 enu_from_ned{0, 1, 0, 1, 0, 0, 0, 0, -1};
    const Mat3 body_from_camera{0, 0, 1, 1, 0, 0, 0, 1, 0};
    return mul(enu_from_ned, mul(yaw, mul(pitch, mul(roll, body_from_camera))));
}

}  // namespace sfm
