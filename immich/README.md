# Immich — Home Assistant app

Immich is a self-hosted photo and video management application. This Home
Assistant app packages the server together with PostgreSQL and Redis, while
leaving machine-learning inference to a separate host.

## Architecture

- **Immich Server, PostgreSQL and Redis:** run together in this Home Assistant app on the Raspberry Pi 5.
- **Machine learning:** runs on a separate machine. For this setup, use the Immich OpenVINO machine-learning container on the Intel LattePanda IOTA.
- **Media library:** stored by default at `/media/immich`.
- **Database:** stored in the app configuration directory at `/config/postgres`.

This app uses the community-maintained `fabioogaravini/hassio-immich-noml`
all-in-one image. The NoML variant does not start a local machine-learning
service, so the Raspberry Pi is not asked to run ML inference.

> **Upstream note:** Immich lists all-in-one as a community contribution and
> does not officially support it. Immich's official recommended deployment
> is Docker Compose. This single-container packaging is intended for Home
> Assistant OS, where one Supervisor-managed app is simpler to operate than
> unmanaged sibling containers. See the [Immich all-in-one documentation](https://docs.immich.app/install/all-in-one/)
> and [Docker Compose installation](https://docs.immich.app/install/docker-compose/).

## Installation

1. Add `https://github.com/killerbigpoint/ha-apps` to the Home Assistant App Store repositories.
2. Install **Immich**.
3. Review the app configuration before starting it.
4. Start the app and open its Web UI.
5. Complete Immich's first-run setup and create the administrator account.

The default Web UI port is **2283**. The app maps its internal web port 8080
to host port 2283. Change the port mapping in the Home Assistant app network
settings if 2283 is already in use.

## Configuration

| Option | Default | Description |
| --- | --- | --- |
| `TZ` | `Europe/Copenhagen` | Time zone used by Immich and its services. |
| `IMMICH_LOG_LEVEL` | `log` | Immich log verbosity: `verbose`, `debug`, `log`, `warn` or `error`. |
| `IMMICH_MEDIA_LOCATION` | `/media/immich` | Location of the Immich library. Use a subfolder under `/media` or `/share`. `/config/library` is also allowed, but makes app backups much larger. |
| `DB_STORAGE_TYPE` | `HDD` | Set to `SSD` if PostgreSQL's data directory is on an SSD/NVMe; leave `HDD` for slower media. |
| `IMMICH_TRUSTED_PROXIES` | `172.30.32.0/23` | Proxy subnet trusted by Immich. Adjust this to match the actual reverse-proxy source address or subnet. |
| `IMMICH_PROCESS_INVALID_IMAGES` | `false` | Whether Immich should attempt to process invalid images. |
| `ssl` | `false` | Enable HTTPS on the app's built-in web endpoint. Usually leave disabled when HTTPS is terminated by Nginx Proxy Manager. |
| `certfile` / `keyfile` | `fullchain.pem` / `privkey.pem` | Certificate and private-key filenames under Home Assistant's `/ssl` directory when built-in HTTPS is enabled. |
| `PUID` / `PGID` | `0` / `0` | User and group IDs used for file ownership. Leave at defaults unless you have a specific ownership requirement. |
| `APPLY_PERMISSIONS` | `false` | Apply ownership and permissions to the media location during startup. This can take a long time for large libraries. |

### Storage locations

| Container path | Home Assistant storage | Purpose |
| --- | --- | --- |
| `/media` | Media | Photo and video library (default: `/media/immich`). |
| `/config` | App configuration | PostgreSQL database and app-specific persistent files. |
| `/share` | Share | Optional alternative location for the library. |
| `/ssl` | SSL | Certificates for optional built-in HTTPS. |

Keep PostgreSQL's `/config/postgres` directory on local storage. Do not put
the database on an SMB, NFS or other network share. Prefer a local SSD/NVMe
for database storage where possible.

The default library path is under Home Assistant's `/media` directory.
Make sure the storage backing `/media` has enough capacity before importing
your photos and videos. You can use Home Assistant's storage settings to
mount supported external storage for the media directory.

### Backups

This app uses a **cold backup**: Home Assistant stops the app while making
the app backup, so PostgreSQL is not being copied while it is running. The
app's private configuration data includes the PostgreSQL data directory.

Treat the media library under `/media/immich` as separate from the app
backup and back it up separately to another disk or NAS. A database backup
without the matching media files is not a complete Immich backup, and vice
versa. Do not put the entire photo library under `/config/library` unless
you intentionally want it included in Home Assistant app backups; this can
make backups very large.

## Remote machine learning

This app uses the **NoML** build. It does not run a local ML service on the
Raspberry Pi. Configure your remote ML server after completing the first-run
setup:

1. Open Immich as an administrator.
2. Go to **Administration → Settings → Machine Learning**.
3. In the **URL** field, set the remote endpoint, for example
   `http://192.168.10.20:3003`.
4. Save the setting and verify that the remote server is available.

Use the actual static IP address or DNS name of the LattePanda. The address
above is only an example.

The remote ML container and Immich Server should normally use matching
Immich releases. There can be a short-lived tag lag when a server release
does not change the ML component: as of 26 November 2026, the server is at
v3.4.2 while the official `release-openvino` ML tag still points to v3.4.1.
Immich tracked this in [issue #33470](https://github.com/immich-app/immich/issues/33470);
the discussion notes that this particular combination is expected because
there were no ML-side changes. Keep using `release-openvino` rather than
forcing a non-existent `v3.4.2-openvino` image, and check the upstream tag
when updating.

The remote ML endpoint has no authentication. Restrict TCP port 3003 on the
LattePanda so that only the Raspberry Pi can reach it. Immich sends image
previews to the remote ML host for Smart Search and Face Detection. With
this NoML app, those jobs cannot fall back to local machine learning if the
LattePanda is unavailable.

## Reverse proxy

The app listens on host TCP port **2283** by default. For Nginx Proxy
Manager, use the Home Assistant host's LAN address and port 2283 as the
upstream. Keep the app's built-in `ssl` option disabled when TLS is
terminated by the reverse proxy.

If Immich is behind a reverse proxy, make sure `IMMICH_TRUSTED_PROXIES`
matches the proxy's actual source address/subnet. Do not trust a wider
network range than necessary.

## Updating

The app image is rebuilt when the upstream all-in-one NoML image changes.
Home Assistant then reports an app update through the version in this
repository. Update the remote ML container around the same time so both
ends stay on the same Immich release.

The image used here is community-maintained; report image-specific issues
to the [upstream all-in-one project](https://github.com/fabio-garavini/hassio-addons)
and Immich application issues to [Immich](https://github.com/immich-app/immich).

## References

- [Immich documentation](https://docs.immich.app/)
- [Immich remote machine learning](https://docs.immich.app/guides/remote-machine-learning/)
- [Immich database requirements](https://docs.immich.app/install/requirements/)
- [Community all-in-one contribution](https://docs.immich.app/install/all-in-one/)
- [NoML image on Docker Hub](https://hub.docker.com/r/fabioogaravini/hassio-immich-noml)
