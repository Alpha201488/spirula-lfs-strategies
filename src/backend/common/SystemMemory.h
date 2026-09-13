// SystemMemory.h -- host RAM usage for the GUI status strip.
//
// Reuses the MemoryUsage shape (process / used / total) so the status readout
// painter can treat RAM and VRAM identically. Header-only: the queries are
// plain OS calls with no backend dependency.
#pragma once
#include "backend/api/BackendRuntime.h"

#if defined(_WIN32)
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <psapi.h>
#elif defined(__APPLE__)
#include <mach/mach.h>
#include <sys/resource.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <unistd.h>
#else
#include <cstdio>
#include <cstdint>
#include <sys/sysinfo.h>
#include <unistd.h>
#endif

namespace backend {

// Host RAM usage with the same shape as MemoryUsage:
//   process_bytes = this process's resident set size
//   used_bytes    = system-wide physical RAM in use
//   total_bytes   = physical RAM capacity
inline MemoryUsage host_memory_usage() {
    MemoryUsage m;
#if defined(_WIN32)
    MEMORYSTATUSEX ms;
    ms.dwLength = sizeof(ms);
    if (GlobalMemoryStatusEx(&ms)) {
        m.total_bytes = (uint64_t)ms.ullTotalPhys;
        m.used_bytes = (uint64_t)(ms.ullTotalPhys - ms.ullAvailPhys);
        m.has_total = true;
        m.has_used = true;
    }
    PROCESS_MEMORY_COUNTERS pmc;
    if (GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc))) {
        m.process_bytes = (uint64_t)pmc.WorkingSetSize;
        m.has_process = true;
    }
#elif defined(__APPLE__)
    int64_t memsize = 0;
    size_t len = sizeof(memsize);
    if (sysctlbyname("hw.memsize", &memsize, &len, nullptr, 0) == 0 &&
        memsize > 0) {
        m.total_bytes = (uint64_t)memsize;
        m.has_total = true;
    }
    mach_port_t host = mach_host_self();
    vm_statistics64_data_t vs;
    mach_msg_type_number_t cnt = HOST_VM_INFO64_COUNT;
    if (host_statistics64(host, HOST_VM_INFO64,
                          (host_info64_t)&vs, &cnt) == KERN_SUCCESS) {
        const uint64_t page = (uint64_t)vm_kernel_page_size;
        const uint64_t used =
            ((uint64_t)vs.active_count + (uint64_t)vs.wire_count) * page;
        m.used_bytes = used;
        m.has_used = true;
    }
    mach_port_deallocate(mach_task_self(), host);
    // macOS has no cheap current-RSS call; report max RSS as a lower bound.
    struct rusage ru;
    if (getrusage(RUSAGE_SELF, &ru) == 0) {
        m.process_bytes = (uint64_t)ru.ru_maxrss;  // bytes on macOS
        m.has_process = true;
    }
#else
    struct sysinfo si;
    if (sysinfo(&si) == 0 && si.mem_unit > 0) {
        m.total_bytes = (uint64_t)si.totalram * (uint64_t)si.mem_unit;
        m.used_bytes =
            (uint64_t)(si.totalram - si.freeram) * (uint64_t)si.mem_unit;
        m.has_total = true;
        m.has_used = true;
    }
    // /proc/self/statm: "size resident" in pages -- current RSS.
    unsigned long statm_size = 0, rss_pages = 0;
    FILE* f = std::fopen("/proc/self/statm", "r");
    if (f != nullptr) {
        if (std::fscanf(f, "%lu %lu", &statm_size, &rss_pages) == 2) {
            const long page = sysconf(_SC_PAGESIZE);
            if (page > 0) {
                m.process_bytes = (uint64_t)rss_pages * (uint64_t)page;
                m.has_process = true;
            }
        }
        std::fclose(f);
    }
#endif
    return m;
}

}  // namespace backend
