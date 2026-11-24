# UniFi OS Server — Home Assistant app

Run [UniFi OS Server](https://help.ui.com/hc/en-us/articles/34210126298775-Self-Hosting-UniFi)
as a Home Assistant app using the multi-architecture image built from
[our UniFi OS Server fork](https://github.com/killerbigpoint/unifi-os-server).

This app is experimental. It runs UniFi's native `systemd` service stack and
requires extensive container privileges with AppArmor disabled. Install it
only on a Home Assistant host you control and trust.

## Quick start

1. Add `https://github.com/killerbigpoint/ha-apps` to the Home Assistant App Store.
2. Install **UniFi OS Server**.
3. In the app Configuration tab, set `UOS_SYSTEM_IP` to the Home Assistant
   host's LAN IP address or a DNS name reachable by your UniFi devices.
4. Start the app and open the Web UI. The default URL is
   `https://<home-assistant-host>:11443`.

The app uses bridge networking so host ports can be remapped and it does not
take over host TCP port 443. Bridge networking does not carry Layer-2 broadcast
discovery; use the manual adoption instructions in [DOCS.md](DOCS.md).

See [DOCS.md](DOCS.md) for networking, port mappings, persistence, backups,
updates and troubleshooting.
