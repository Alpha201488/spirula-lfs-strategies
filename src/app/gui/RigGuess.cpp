#include "app/gui/RigGuess.h"

#include <algorithm>
#include <cctype>
#include <map>
#include <tuple>

namespace gui {

namespace {

// "Walk1_frontLeft/cam0" -> walk 1 front left cam 0
std::vector<std::string> tokenize(const std::string& name) {
    std::vector<std::string> out;
    std::string cur;
    auto flush = [&] {
        if (!cur.empty()) out.push_back(cur);
        cur.clear();
    };
    for (size_t i = 0; i < name.size(); i++) {
        const unsigned char c = (unsigned char)name[i];
        if (!std::isalnum(c)) { flush(); continue; }
        if (!cur.empty()) {
            const unsigned char prev = (unsigned char)name[i - 1];
            const bool kind_change = (bool)std::isdigit(c) != (bool)std::isdigit(prev);
            const bool camel = std::isupper(c) && std::islower(prev);
            if (kind_change || camel) flush();
        }
        cur += (char)std::tolower(c);
    }
    flush();
    return out;
}

bool camera_word(const std::string& t) {
    static const char* const kWords[] = {
        "left", "right", "front", "back", "rear", "top", "bottom", "up", "down",
        "l", "r", "f", "b", "cam", "camera", "lens", "fisheye", "sensor", "view",
    };
    for (const char* w : kWords)
        if (t == w) return true;
    return false;
}

// Rig members are matched by file name, so a rig whose folders share few
// names is no rig. The larger folder is the denominator: a clip twice as long
// under the same frame numbering is another capture, not a lens.
bool same_frames(const std::vector<std::string>& a, const std::vector<std::string>& b) {
    size_t common = 0;
    for (size_t i = 0, j = 0; i < a.size() && j < b.size();) {
        if (a[i] < b[j]) i++;
        else if (b[j] < a[i]) j++;
        else { common++; i++; j++; }
    }
    return common > 0 && common * 5 >= std::max(a.size(), b.size()) * 4;
}

struct Split {
    std::vector<std::vector<int>> rigs;
    // Ranked in this order: folders covered, lens-like names at the varying
    // token, rigs whose lenses hold exactly as many images, a later token.
    std::tuple<size_t, int, int, size_t> score{0, 0, 0, 0};
};

Split split_at(const std::vector<RigCandidate>& folders,
               const std::vector<std::vector<std::string>>& tokens,
               const std::vector<int>& members, size_t p) {
    std::map<std::string, std::vector<int>> buckets;
    for (int i : members) {
        std::string key;
        for (size_t k = 0; k < tokens[(size_t)i].size(); k++)
            if (k != p) key += tokens[(size_t)i][k] + '\x1f';
        buckets[key].push_back(i);
    }
    Split s;
    size_t covered = 0;
    int hint = 0, even = 0;
    for (auto& [key, b] : buckets) {
        std::vector<int> rig;
        for (int i : b) {
            const auto& t = tokens[(size_t)i];
            bool fits = rig.empty() || same_frames(folders[(size_t)rig[0]].images,
                                                   folders[(size_t)i].images);
            for (int j : rig) fits = fits && tokens[(size_t)j][p] != t[p];
            if (fits) rig.push_back(i);
        }
        if (rig.size() < 2) continue;
        covered += rig.size();
        bool same_size = true;
        for (int i : rig) {
            const auto& t = tokens[(size_t)i];
            if (camera_word(t[p]) || (p > 0 && camera_word(t[p - 1]))) hint++;
            same_size = same_size && folders[(size_t)i].images.size() ==
                                         folders[(size_t)rig[0]].images.size();
        }
        even += same_size;
        s.rigs.push_back(std::move(rig));
    }
    s.score = {covered, hint, even, p};
    return s;
}

}  // namespace

std::vector<int> guess_rigs(const std::vector<RigCandidate>& folders) {
    std::vector<std::vector<std::string>> tokens;
    std::map<size_t, std::vector<int>> by_length;
    for (size_t i = 0; i < folders.size(); i++) {
        tokens.push_back(tokenize(folders[i].name));
        if (!folders[i].images.empty() && !tokens.back().empty())
            by_length[tokens.back().size()].push_back((int)i);
    }

    std::vector<std::vector<int>> rigs;
    for (const auto& [len, members] : by_length) {
        if (members.size() < 2) continue;
        Split best;
        for (size_t p = 0; p < len; p++) {
            Split s = split_at(folders, tokens, members, p);
            if (s.score > best.score) best = std::move(s);
        }
        for (auto& r : best.rigs) rigs.push_back(std::move(r));
    }

    std::sort(rigs.begin(), rigs.end(),
              [](const std::vector<int>& a, const std::vector<int>& b) {
                  return *std::min_element(a.begin(), a.end()) <
                         *std::min_element(b.begin(), b.end());
              });
    std::vector<int> out(folders.size(), -1);
    for (size_t r = 0; r < rigs.size(); r++)
        for (int i : rigs[r]) out[(size_t)i] = (int)r;
    return out;
}

}  // namespace gui
