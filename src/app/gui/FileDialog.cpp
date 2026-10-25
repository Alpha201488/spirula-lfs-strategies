// FileDialog.cpp -- see FileDialog.h.

#include "app/gui/FileDialog.h"

#include "app/gui/Layout.h"
#include "app/gui/Ui.h"

#include "i18n/catalog/Gui.h"

#include "imgui.h"
#include "imgui_stdlib.h"

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <filesystem>

namespace fs = std::filesystem;

namespace msg = spirula::i18n::msg::gui;

namespace gui {

namespace {

std::string home_dir() {
#ifdef _WIN32
    if (const char* p = std::getenv("USERPROFILE")) return p;
    return "C:\\";
#else
    if (const char* p = std::getenv("HOME")) return p;
    return "/";
#endif
}

std::string lower(std::string s) {
    for (auto& c : s) c = (char)std::tolower((unsigned char)c);
    return s;
}

}  // namespace

// Appends the first extension when the name carries none of the accepted
// ones. True when it changed the path.
bool FileDialog::with_extension(std::string& path) const {
    if (_extensions.empty() || path.empty()) return false;
    const std::string have = lower(fs::path(path).extension().string());
    for (const std::string& e : _extensions)
        if (have == lower(e)) return false;
    path += _extensions[0];
    return true;
}

void FileDialog::open(const std::string& title, Mode mode,
                      const std::vector<std::string>& extensions,
                      const std::string& start_dir, bool multi_select,
                      const std::string& suggested_name) {
    _title = title;
    _mode = mode;
    _multi = multi_select && mode == Mode::File;
    _save_name = suggested_name;
    _extensions = extensions;
    std::error_code ec;
    if (!start_dir.empty() && fs::is_directory(start_dir, ec))
        _cwd = fs::absolute(start_dir, ec).string();
    else if (_cwd.empty() || !fs::is_directory(_cwd, ec))
        _cwd = home_dir();
    _selected.clear();
    _result.clear();
    _results.clear();
    const NativeDialog::Mode nm = mode == Mode::Folder
                                      ? NativeDialog::Mode::Folder
                                  : mode == Mode::Save
                                      ? NativeDialog::Mode::Save
                                  : mode == Mode::FileOrFolder
                                      ? NativeDialog::Mode::FileOrFolder
                                      : NativeDialog::Mode::File;
    if (_use_native && NativeDialog::available()) {
        // A second request while one is up is a repeated click, not a reason
        // to put the fallback browser on top of the system picker.
        if (_native.busy()) return;
        if (_native.open(title, nm, extensions, _cwd, _multi, _save_name))
            return;
    }
    _want_open = true;
    refresh();
}

bool FileDialog::is_selected(const std::string& name) const {
    return std::find(_selected.begin(), _selected.end(), name) != _selected.end();
}

// Multi-select toggles, because a modifier key is not discoverable and the
// listing is the only place the selection is visible. Single-select replaces.
void FileDialog::toggle(const std::string& name) {
    if (!_multi) {
        _selected.assign(1, name);
        return;
    }
    auto it = std::find(_selected.begin(), _selected.end(), name);
    if (it == _selected.end()) _selected.push_back(name);
    else _selected.erase(it);
}

void FileDialog::refresh() {
    _entries.clear();
    _path_edit = _cwd;
    std::error_code ec;
    for (fs::directory_iterator it(_cwd, fs::directory_options::skip_permission_denied, ec), end;
         !ec && it != end; it.increment(ec)) {
        Entry e;
        e.name = it->path().filename().string();
        if (e.name.empty() || e.name[0] == '.') continue;   // hide dotfiles
        e.is_dir = it->is_directory(ec);
        if (!e.is_dir) {
            if (_mode == Mode::Folder) continue;
            if (!_extensions.empty()) {
                std::string ext = lower(it->path().extension().string());
                if (std::find(_extensions.begin(), _extensions.end(), ext) ==
                    _extensions.end()) continue;
            }
        }
        _entries.push_back(std::move(e));
    }
    std::sort(_entries.begin(), _entries.end(), [](const Entry& a, const Entry& b) {
        if (a.is_dir != b.is_dir) return a.is_dir;
        return lower(a.name) < lower(b.name);
    });
}

bool FileDialog::draw() {
    if (_native.busy()) {
        if (!_native.poll()) return false;
        _results = _native.results();
        if (_results.empty()) return false;    // cancelled
        // The system picker hands back the name as typed. "chair" and
        // "chair.ply" mean the same thing to everyone but the file system --
        // and the picker only asked about replacing the name it was given.
        if (_mode == Mode::Save && with_extension(_results[0])) {
            std::error_code exists_ec;
            if (fs::exists(_results[0], exists_ec)) {
                _replace_path = _results[0];
                _results.clear();
                _ask_replace = true;
                return false;
            }
        }
        _result = _results[0];
        // Where the next pick starts from, so the two browsers share one
        // notion of "last used".
        std::error_code ec;
        const fs::path p(_results[0]);
        _cwd = (fs::is_directory(p, ec) ? p : p.parent_path()).string();
        return true;
    }
    if (_ask_replace) {
        ui::OpenPopup(msg::fd_replace_title);
        _ask_replace = false;
    }
    const ImGuiViewport* replace_vp = ImGui::GetMainViewport();
    ImGui::SetNextWindowPos(replace_vp->GetCenter(), ImGuiCond_Appearing,
                            ImVec2(0.5f, 0.5f));
    ImGui::SetNextWindowSize(ImVec2(px(460.0f), 0.0f), ImGuiCond_Always);
    if (ui::BeginPopupModal(msg::fd_replace_title, nullptr,
                            ImGuiWindowFlags_NoResize)) {
        ui::TextWrapped(msg::fd_replace_body, {_replace_path});
        bool yes = false;
        if (ui::Button(msg::fd_replace_yes)) yes = true;
        ImGui::SameLine();
        const bool no = ui::Button(msg::cancel);
        if (yes || no) ImGui::CloseCurrentPopup();
        ImGui::EndPopup();
        if (yes) {
            _results.assign(1, _replace_path);
            _result = _replace_path;
            _cwd = fs::path(_replace_path).parent_path().string();
        }
        if (yes || no) _replace_path.clear();
        if (yes) return true;
    }
    if (_want_open) {
        ImGui::OpenPopup(_title.c_str());
        _want_open = false;
        _is_open = true;
    }
    if (!_is_open) return false;

    bool confirmed = false;
    const ImVec2 screen = ImGui::GetMainViewport()->WorkSize;
    ImGui::SetNextWindowSize(ImVec2(std::min(px(680.0f), screen.x * 0.95f),
                                    std::min(px(480.0f), screen.y * 0.9f)),
                             ImGuiCond_Appearing);
    if (ui::BeginPopupModalRaw(_title.c_str(), &_is_open)) {
        std::error_code ec;

        // ---- top bar: up / home / drives / editable path ----
        if (ui::Button(msg::fd_up)) {
            fs::path p(_cwd);
            if (p.has_parent_path() && p.parent_path() != p) {
                _cwd = p.parent_path().string();
                _selected.clear();
                refresh();
            }
        }
        ImGui::SameLine();
        if (ui::Button(msg::fd_home)) {
            _cwd = home_dir();
            _selected.clear();
            refresh();
        }
#ifdef _WIN32
        ImGui::SameLine();
        ImGui::SetNextItemWidth(px(70.0f));
        if (ui::BeginComboRaw("##drives", msg::fd_drive.get())) {
            for (char d = 'A'; d <= 'Z'; d++) {
                std::string root = std::string(1, d) + ":\\";
                if (fs::exists(root, ec) && ui::SelectableRaw(root)) {
                    _cwd = root;
                    _selected.clear();
                    refresh();
                }
            }
            ImGui::EndCombo();
        }
#endif
        ImGui::SameLine();
        ImGui::SetNextItemWidth(-1);
        if (ui::InputTextRaw("##path", &_path_edit,
                             ImGuiInputTextFlags_EnterReturnsTrue)) {
            if (fs::is_directory(_path_edit, ec)) {
                _cwd = fs::absolute(_path_edit, ec).string();
                _selected.clear();
                refresh();
            } else if (_mode != Mode::Save && _mode != Mode::Folder &&
                       fs::is_regular_file(_path_edit, ec)) {
                _results.assign(1, fs::absolute(_path_edit, ec).string());
                confirmed = true;
            } else if (_mode == Mode::Save) {
                const fs::path p = fs::absolute(_path_edit, ec);
                if (fs::is_directory(p.parent_path(), ec)) {
                    _cwd = p.parent_path().string();
                    _save_name = p.filename().string();
                    _selected.clear();
                    refresh();
                }
            }
        }

        // ---- listing ----
        float footer = ImGui::GetFrameHeightWithSpacing() + px(8.0f);
        if (_mode == Mode::Save) footer += ImGui::GetFrameHeightWithSpacing();
        if (ImGui::BeginChild("##list", ImVec2(0, -footer), ImGuiChildFlags_Borders)) {
            for (const auto& e : _entries) {
                const bool sel = is_selected(e.name);
                std::string label = e.is_dir ? "[+] " : (_multi && sel ? "[x] " : "     ");
                label += e.name;
                // File and folder names, exactly as they are on disk.
                if (ui::SelectableRaw(label.c_str(), sel,
                                      ImGuiSelectableFlags_AllowDoubleClick)) {
                    if (e.is_dir) _selected.assign(1, e.name);
                    else if (_mode == Mode::Save) _save_name = e.name;
                    else toggle(e.name);
                    if (ImGui::IsMouseDoubleClicked(0)) {
                        fs::path full = fs::path(_cwd) / e.name;
                        if (e.is_dir) {
                            _cwd = full.string();
                            _selected.clear();
                            refresh();
                            break;   // _entries invalidated
                        }
                        if (_mode == Mode::File || _mode == Mode::FileOrFolder) {
                            _results.assign(1, full.string());
                            confirmed = true;
                        }
                    }
                }
            }
        }
        ImGui::EndChild();

        // ---- footer ----
        bool have_sel = !_selected.empty();
        if (_mode == Mode::Save) {
            // The name a save writes under, appended with the first extension
            // when one was not typed -- "chair" and "chair.ply" mean the same
            // thing to everyone but the file system.
            std::string name = _save_name;
            if (!name.empty()) with_extension(name);
            const bool exists = !name.empty() &&
                                fs::exists(fs::path(_cwd) / name, ec);
            ImGui::SetNextItemWidth(px(280.0f));
            if (ui::InputTextRaw("##savename", &_save_name,
                                 ImGuiInputTextFlags_EnterReturnsTrue) &&
                !name.empty()) {
                _results.assign(1, (fs::path(_cwd) / name).string());
                confirmed = true;
            }
            ImGui::SameLine();
            ui::TextDisabled(msg::fd_file_name);
            ImGui::SameLine();
            ImGui::BeginDisabled(name.empty());
            if (ui::Button(msg::fd_save_here) && !name.empty()) {
                _results.assign(1, (fs::path(_cwd) / name).string());
                confirmed = true;
            }
            ImGui::EndDisabled();
            if (exists) {
                ImGui::SameLine();
                ui::TextColored(ImVec4(1.0f, 0.78f, 0.35f, 1.0f),
                                msg::fd_will_replace);
            }
        } else if (_mode == Mode::Folder || _mode == Mode::FileOrFolder) {
            if (have_sel) {
                if (ui::Button(msg::fd_select_highlighted)) {
                    _results.assign(1, (fs::path(_cwd) / _selected[0]).string());
                    confirmed = true;
                }
                ImGui::SameLine();
            }
            if (ui::Button(msg::fd_use_this_folder)) {
                _results.assign(1, _cwd);
                confirmed = true;
            }
        } else {
            const bool many = _multi && _selected.size() > 1;
            ImGui::BeginDisabled(!have_sel);
            const bool go = many
                ? ui::Button(msg::fd_select_files, {(int)_selected.size()})
                : ui::Button(msg::fd_select_file);
            if (go && have_sel) {
                _results.clear();
                for (const std::string& name : _selected)
                    _results.push_back((fs::path(_cwd) / name).string());
                confirmed = true;
            }
            ImGui::EndDisabled();
            if (_multi) {
                ImGui::SameLine();
                ui::TextDisabled(msg::fd_multi_hint);
            }
        }
        ImGui::SameLine();
        if (ui::Button(msg::cancel)) _is_open = false;

        if (confirmed) {
            _result = _results.empty() ? "" : _results[0];
            _is_open = false;
        }
        if (!_is_open) ImGui::CloseCurrentPopup();
        ImGui::EndPopup();
    }
    return confirmed;
}

}  // namespace gui
