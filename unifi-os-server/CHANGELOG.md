# Changelog

All notable changes to the UniFi OS Server Home Assistant app are documented here.

---

## [0.2.2] - 2026-11-25

### Changed

- Rebuilt against an updated UniFi OS Server base image.

---

## [0.2.1] - 2026-11-25

### Changed

- Fix long startup time by disabling tmpfs

---

## [0.2.0] - 2026-11-24

### Changed

- Added additional permissions to hopefully make it boot

---

## [0.1.5] - 2026-11-24

### Changed

- Additional logging

---

## [0.1.4] - 2026-11-24

### Changed

- Modified debugging

---

## [0.1.3] - 2026-11-24

### Added

- Add debugging

---

## [0.1.2] - 2026-11-24

### Added

- More fixes to get it working

---

## [0.1.1] - 2026-11-24

### Added

- Fixes to get the app working

---

## [0.1.0] - 2026-11-24

### Added

- Initial Home Assistant app wrapper for UniFi OS Server.
- Multi-architecture support for `amd64` and `aarch64`.
- Bridge networking with configurable host-side port mappings.
- Persistent storage of UniFi service data in the Home Assistant `/data` volume.
- Cold-backup configuration for database consistency.
- Documentation for manual device adoption and network limitations.
