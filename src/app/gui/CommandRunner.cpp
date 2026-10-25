// CommandRunner.cpp -- see CommandRunner.h.

#include "app/gui/CommandRunner.h"

#include "app/gui/Subprocess.h"

namespace gui {

CommandRunner::~CommandRunner() {
    _cancel = true;
    if (_worker.joinable()) _worker.join();
}

bool CommandRunner::start(const std::vector<std::string>& argv) {
    if (argv.empty() || _busy.load()) return false;
    if (_worker.joinable()) _worker.join();   // the last one, already over
    {
        std::lock_guard<std::mutex> lk(_mu);
        _log.clear();
        _program = argv.front();
    }
    _cancel = false;
    _result = kNoResult;
    _busy = true;
    _worker = std::thread([this, argv] { run(argv); });
    return true;
}

void CommandRunner::cancel() { _cancel = true; }

std::string CommandRunner::program() const {
    std::lock_guard<std::mutex> lk(_mu);
    return _program;
}

int CommandRunner::take_exit_code() { return _result.exchange(kNoResult); }

std::vector<std::string> CommandRunner::drain_log() {
    std::lock_guard<std::mutex> lk(_mu);
    std::vector<std::string> out;
    out.swap(_log);
    return out;
}

void CommandRunner::run(std::vector<std::string> argv) {
    const int code = run_process(
        argv, "",
        [this](const std::string& line) {
            std::lock_guard<std::mutex> lk(_mu);
            _log.push_back(line);
        },
        _cancel);
    // Before the busy flag: a caller that sees it go idle can then ask.
    _result = code;
    _busy = false;
}

}  // namespace gui
