# ADR-0001: Use Rust as the Primary Implementation Language

- **Date:** 2026-02-26
- **Status:** Accepted

## Context

The Extremely Personal Marketplace requires two main software components:

1. **`epm` CLI** — installed on a user's machine; resolves, downloads, and manages EPS packages
2. **Registry server** — hosts the centralized package index and serves metadata/artifacts

We need to choose an implementation language. Key constraints:

- The CLI must ship as a single, self-contained binary with no runtime dependency (users should not need to install Node, Python, etc.)
- Performance and memory footprint matter for the CLI since it runs on user devices
- The registry server needs to be reliable, fast, and easy to deploy as a single binary
- The broader project philosophy encourages local-first, lean software — the tooling should embody those values
- The team has a preference for Rust

Alternatives considered:

| Language | Notes |
|----------|-------|
| Go       | Strong CLI ecosystem, single binary, but weaker type safety and less ergonomic error handling |
| Python   | Rapid prototyping, but requires a runtime; poor single-binary story |
| Node.js  | Large ecosystem, but heavy runtime; not aligned with local-first philosophy |
| Rust     | Single binary, zero runtime, best-in-class memory safety, excellent CLI crates (clap, indicatif), strong async story (tokio, axum) |

## Decision

Rust is the primary implementation language for all components of the Extremely Personal Marketplace, including:

- The `epm` CLI
- The registry server
- Any shared library crates (manifest parsing, version resolution, etc.)

Platform-native code (e.g., macOS Swift for UI in EPSs themselves) is explicitly out of scope — EPSs are built by their authors in whatever language makes sense. This ADR only governs the marketplace tooling.

## Consequences

**Positive:**
- Single-binary distribution for `epm` — no install prerequisites beyond the binary itself
- Memory safety guarantees reduce a class of bugs common in long-running servers
- Cargo makes dependency management and workspace organization straightforward
- Crates like `clap`, `tokio`, `axum`, `serde`, and `reqwest` cover virtually all needs
- Consistent language across CLI and server simplifies code sharing (e.g., manifest types)
- Aligns with the EPS ethos: lean, fast, reliable, no bloat

**Negative:**
- Longer compile times during development compared to Go or scripting languages
- Steeper onboarding curve for contributors unfamiliar with Rust's ownership model
- Some crates in the ecosystem are less mature than equivalents in Go or Node
