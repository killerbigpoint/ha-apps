# UniFi OS Server — Home Assistant app documentation

## Overview

This app runs the UniFi OS Server image built by
[killerbigpoint/unifi-os-server](https://github.com/killerbigpoint/unifi-os-server).
The Home Assistant image is a thin wrapper that reads app options, relocates
selected state directories into the persistent `/data` volume, and delegates
startup to the original UniFi entrypoint.

The Home Assistant app version (`config.yaml` → `version`) is separate from
the UniFi OS Server base-image version (`build.yaml` → `build_from`).

## Requirements and privileges

- Home Assistant OS or a supported Supervised installation with the App Store.
- `amd64` or `aarch64` host architecture.
- Adequate memory and storage for UniFi OS Server and its databases.
- A trusted Home Assistant host. The app requires `full_access: true` and
  disables AppArmor because it runs a systemd-based service stack.

## Installation

1. In Home Assistant, open **Settings → Apps → App Store**.
2. Add `https://github.com/killerbigpoint/ha-apps`.
3. Install **UniFi OS Server**.
4. In the app Configuration tab, set `UOS_SYSTEM_IP` to the Home Assistant
   host LAN address or a DNS hostname that UniFi devices can reach.
5. Start the app and open its Web UI.

The default Web UI address is `https://<home-assistant-host>:11443`.
A browser certificate warning may appear if the server presents a self-signed
certificate.

## Configuration

### UOS_SYSTEM_IP

Set this to the Home Assistant host LAN IP or a DNS name that resolves to that
host from the UniFi devices. Do not use the app container IP. The upstream
entrypoint writes this value to UniFi's `system.properties` as `system_ip`.

### HARDWARE_PLATFORM

Optional. The only accepted override is `synology`. Leave it unset on normal
AMD64 or ARM64 hardware, including Raspberry Pi.

## Networking and ports

The app uses Docker bridge networking (`host_network: false`). In Home
Assistant's Network section, the left-hand port is the container port and the
right-hand value is the host port. Host-side values can be changed there.

| Container port | Protocol | Default host port | Purpose |
| --- | --- | ---: | --- |
| 443 | TCP | 11443 | UniFi OS Web UI and API |
| 8080 | TCP | 8080 | Device and application communication / inform |
| 3478 | UDP | 3478 | STUN |
| 10003 | UDP | 10003 | Device discovery during adoption |
| 5005 | TCP | Disabled | RTP control |
| 6789 | TCP | Disabled | Mobile speed test |
| 8444 | TCP | Disabled | Hotspot HTTPS portal |
| 8880–8882 | TCP | Disabled | Hotspot HTTP redirects |
| 9543 | TCP | Disabled | UniFi Identity Hub |
| 28082 | TCP | Disabled | Device support file downloads |
| 5671 | TCP | Disabled | AMQPS |
| 5514 | UDP | Disabled | Remote syslog |

The default Web UI mapping is container TCP 443 → host TCP 11443, leaving
host TCP 443 available for another service such as Nginx Proxy Manager.
The Home Assistant Web UI link uses the configured host-side port.

### Discovery and adoption limitation

Bridge networking does not forward Layer-2 broadcasts between the physical LAN
and the app container. Publishing UDP 10003 does not restore Layer-2 broadcast
discovery, so devices may not appear automatically in the adoption UI.

For adoption, ensure TCP 8080 on the Home Assistant host is reachable from the
device. SSH to the UniFi device and run:

```bash
set-inform http://<UOS_SYSTEM_IP>:8080/inform
```

If you change the host mapping for container port 8080, use that host port in
the inform URL as well. UDP 3478 should remain reachable for STUN and remote
management. Enable optional ports only when the corresponding UniFi feature
is used.

## Data persistence and backups

Home Assistant provides the persistent `/data` volume for the app. The startup
shim migrates the following directories into `/data` on first start and replaces
the original paths with symlinks:

| Original path | Persistent location |
| --- | --- |
| `/persistent` | `/data/persistent` |
| `/srv` | `/data/srv` |
| `/var/lib/unifi` | `/data/var-lib-unifi` |
| `/var/lib/mongodb` | `/data/var-lib-mongodb` |
| `/var/log` | `/data/var-log` |
| `/etc/rabbitmq/ssl` | `/data/etc-rabbitmq-ssl` |

UniFi's `/data/uos_uuid` is already stored directly on the persistent volume.
The app is configured for cold backups: Home Assistant stops the app while
creating the backup. The controller is unavailable during this operation, but
database files are not copied while services are actively writing to them.

Keep regular Home Assistant backups before upgrading the app or its UniFi
base image.

## Migration from the Network Application

1. Create and download a Network Application backup (`.unf`) from the old controller.
2. Record the device SSH credentials and existing controller inform address.
3. Stop the old Network Application after the backup is safely stored.
4. Install and start this app, then restore the `.unf` backup using the migration
   or restore flow supported by the installed UniFi OS Server version.
5. Confirm that devices reconnect. If necessary, update their inform address
   using `set-inform` as shown above.

Do not delete the old controller data until the new controller and all adopted
devices have been verified.

## Updates and versioning

- `config.yaml` `version` is the Home Assistant app version.
- `build.yaml` pins the architecture-specific base image for the custom build.
- The base image is published by
  [killerbigpoint/unifi-os-server](https://github.com/killerbigpoint/unifi-os-server).

When updating UniFi OS Server, publish the new base image for both architectures
first. Then update both `build_from` entries and test the app image build before
releasing a new Home Assistant app version.

## Troubleshooting

### The app does not start

- Check the app logs for errors from `ha-entrypoint.sh` or `/root/uos-entrypoint.sh`.
- Confirm the base image exists for the required architecture.
- Confirm the app is installed on a supported Home Assistant installation.
- The image starts systemd and needs the privileged app configuration.

### Devices do not appear automatically

This is expected with bridge networking because Layer-2 broadcasts do not cross
the bridge. Use SSH and `set-inform` to point devices at the Home Assistant host.

### Devices cannot connect

- Confirm `UOS_SYSTEM_IP` resolves to the Home Assistant host from the device.
- Confirm TCP 8080 and UDP 3478 are allowed through firewall rules.
- If you changed the host-side port mapping, use that port in the inform URL.

### The Web UI does not open

- Use `https://<home-assistant-host>:11443` by default.
- Check the Home Assistant app Network tab for the actual host-side mapping.
- Check that the host-side port is not already used by another service.

## Upstream projects

- [Home Assistant app source](https://github.com/killerbigpoint/ha-apps/tree/main/unifi-os-server)
- [UniFi OS Server image fork](https://github.com/killerbigpoint/unifi-os-server)
- [Ubiquiti self-hosting documentation](https://help.ui.com/hc/en-us/articles/34210126298775-Self-Hosting-UniFi)
