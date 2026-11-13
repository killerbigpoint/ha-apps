# Changelog

All notable changes to the Arcane app will be documented here.

---

## [1.0.1] - 2026-11-13

### Changed

- Fix connection to docker socket

---

## [1.0.0] - 2026-11-13

### Changed

- Mark addon as stable

---

## [0.1.0] - 2026-11-04

### Added

- Initial scaffold for the Arcane App add-on
- `FROM getarcaneapp/manager:latest` — uses the official upstream Docker image
  directly rather than building from source
- Ports: 3552 (Admin Interface)
- Multi-arch support: `amd64`, `aarch64`