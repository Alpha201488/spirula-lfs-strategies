#pragma once
// Backend API module — GENERATED forwarder by
// tools/codegen/generate_backend_api.py. DO NOT EDIT.
//
// LFS-style densification strategy kernels (IGS+ / MRNF / MCMC port): prune masks, dual scores, weight algebra, far-field masks, slot-wise long-axis split, render-edge accumulation.
//
// Authoritative declarations live in the per-kernel headers included below
// (declaration sections generated from /*[AutoHeaderGeneratorExport]*/
// markers by generate_headers.py; CUDA-include-free via BackendTypes.h).
// Implementations: the .cu files next to each header (CUDA) and
// backend/vulkan/kernels/ (SPIR-V pipeline dispatch). See backend/README.md.

#include "kernels/strategy/StrategyOps.cuh"
