# Changelog

## [0.1.3] - 2026-11-27

### Changed

- Rebuilt against updated upstream NoML image (sha256:da759ce48571e88bca6588597676a69ff9072c064c14fcc7e464c0dbcc1dd0b3).


---

## [0.1.2] - 2026-11-26

### Fixed

- Explicitly disable database restore by default.
- Add optional database backup restoration configuration.

---

## [0.1.1] - 2026-11-26

### Changed

- Rebuilt against updated upstream NoML image (sha256:8bad7faa53923755653a9292f5058594b1e7d9d8df2e2f71859c5644db202a84).

---

## [0.1.0] - 2026-11-26

### Added

- Initial Home Assistant app packaging for Immich.
- Bundled PostgreSQL and Redis through the community all-in-one NoML image.
- No local machine-learning service; supports a remote Immich ML endpoint.
- Persistent app configuration/database and media storage mappings.
