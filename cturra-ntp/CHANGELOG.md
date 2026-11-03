# Changelog

All notable changes to the Cturra Ntp app will be documented here.

---

## [0.2.0] - 2026-11-03

### Changed

- Use 192.168.0.2 as ntp so internal ntp's can sync better

---

## [0.1.0] - 2026-11-03

### Added

- Initial scaffold for the Cturra Ntp add-on
- `FROM cturra/ntp:latest` — uses the official upstream Docker image
  directly rather than building from source
- Ports: 123 (NTP)
- Multi-arch support: `amd64`, `aarch64`
