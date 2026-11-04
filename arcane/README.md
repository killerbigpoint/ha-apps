# Arcane App

![Version][version-shield]
![Project Stage][project-stage-shield]
![Maintained][maintenance-shield]

Modern Docker Management, Designed for Everyone
This app runs the **latest upstream** ([getarcaneapp/arcane](https://github.com/getarcaneapp/arcane)) image.

## Features

- Administrate Docker

## Ports

| Port | Protocol  | Description                        |
| ---- | --------- | ---------------------------------- |
| 3552 | TCP       | Admin Interface                    |

## Upgrading

Update the app through the Home Assistant UI when a new version is published.

After upgrading, verify that:

1. The app starts successfully.
2. You can access the admin interface

## Notes

- Ports 3552 must be free on the host
- This add-on does **not** use a HA base image; it uses the official getarcaneapp Docker image directly.

[version-shield]: https://img.shields.io/badge/version-0.1.0-blue.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io
