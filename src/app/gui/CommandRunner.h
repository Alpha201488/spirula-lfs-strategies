#pragma once

// CommandRunner -- one external command the user asked for, run in the
// background because the GUI cannot block on it and what it prints is worth
// showing. Same drain_log() shape as the other runners, but it knows nothing
// about what it runs: the caller hands it an argv, which Subprocess.h builds
// from a command line the user typed.

#include <atomic>
#include <climits>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

namespace gui {

class CommandRunner {
public:
    // What take_exit_code() says when no command has finished since the last
    // time it was asked.
    static constexpr int kNoResult = INT_MIN;

    ~CommandRunner();

    // Runs argv[0] with the rest as its arguments. False when one is already
    // running (the caller decides what to say about that) or argv is empty.
    bool start(const std::vector<std::string>& argv);
    void cancel();

    bool busy() const { return _busy.load(); }
    // argv[0] of the last command started, for the message about it.
    std::string program() const;
    // The exit status of a command that has just finished, reported ONCE.
    // kSpawnFailed / kCancelled from Subprocess.h mean what they do there.
    int take_exit_code();
    // Whatever it has printed since the last call, stdout and stderr merged.
    std::vector<std::string> drain_log();

private:
    void run(std::vector<std::string> argv);

    std::thread _worker;
    std::atomic<bool> _busy{false};
    std::atomic<bool> _cancel{false};
    std::atomic<int> _result{kNoResult};
    mutable std::mutex _mu;
    std::string _program;
    std::vector<std::string> _log;
};

}  // namespace gui
