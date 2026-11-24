# UniFi OS Server — Home Assistant add-on

Forked from [Claidiu's HA app](https://github.com/clllaur/unifi-os-server-HA)

Run [UniFi OS Server](https://blog.ui.com/article/introducing-unifi-os-server)
as a Home Assistant add-on.

This is an **experimental**, privileged add-on that runs UniFi's full
`systemd` service stack. See [DOCS.md](DOCS.md) for full installation,
configuration, networking and troubleshooting details.

## Quick start

1. Add the repository to Home Assistant:
   `https://github.com/clllaur/unifi-os-server-HA`
2. Install **UniFi OS Server** from the Add-on Store.
3. Set `UOS_SYSTEM_IP` to your host's LAN IP or hostname.
4. Start the add-on and open `https://<home-assistant-host>:443`.

> This fork switches from using **host networking** back to a docker network so its possible to change ports - Keep in mind this breaks L2 device discovery
