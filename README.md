# OpenVPN client

The purpose of this image is to provide a vpn container, that can be used by others containers in a cluster, that requires a vpn connection.

## Requirements

- a vpn config that should be mounted to /openvpn.ovpn
- a docker secret named vpn_user
- a docker secret named vpn_password

## Usage

Use it straight from your compose file:

```
services:
  openvpn-client:
    cap_add:
      - net_admin
    container_name: openvpn-client
    devices:
      - /dev/net/tun:/dev/net/tun
    dns:
      - # Add your primary vpn dns server here
      - # Add your secondary vpn dns server here
    image: dotslashme/openvpn-client
    secrets:
      - vpn_user
      - vpn_password
    volumes:
      - type: bind
        source: ./config.ovpn
        target: /config.ovpn

secrets:
  vpn_user:
  vpn_password:
```

The other service that should use the vpn connection must have the following in its declaration:
`network_mode: service:openvpn-client`