# Changelog

All notable changes to the Arcane app will be documented here.

---

## [1.1.5] - 2026-11-20

### Changed

- Updated to v3.1.1

---

## [1.1.4] - 2026-11-18

### Changed

- Updated to v3.1.0

---

## [1.1.3] - 2026-11-17

### Changed

- Additional fixes for app not starting

---

## [1.1.2] - 2026-11-17

### Changed

- Small cleanup

---

## [1.1.1] - 2026-11-17

### Changed

- Updated Arcane image from manager to Agent
- Updated configuration options

---

## [1.1.0] - 2026-11-17

### Changed

- Updated Arcane to 3.0.1

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
