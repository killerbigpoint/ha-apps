# Cturra Ntp

![Version][version-shield]
![Project Stage][project-stage-shield]
![Maintained][maintenance-shield]

Lightweight docker container that runs a Chrony Network Time Protocol (NTPv4) server
This app runs the **latest upstream** ([cturra/ntp](https://github.com/cturra/docker-ntp)) image.

## Features

- NTP server to syncronize all your home devices with correct time

## Ports

| Port | Protocol  | Description                        |
| ---- | --------- | ---------------------------------- |
| 123  | UDP       | Network Time Protocol              |

## Upgrading

Update the app through the Home Assistant UI when a new version is published.

After upgrading, verify that:

1. The app starts successfully.
2. You can update time correctly

## Notes

- Ports 123 must be free on the host
- This add-on does **not** use a HA base image; it uses the official cturra-ntp Docker image directly.

[version-shield]: https://img.shields.io/badge/version-0.2.0-blue.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io
