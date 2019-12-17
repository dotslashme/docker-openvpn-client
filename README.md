# OpenVPN client

A simple username/password openvpn client that can provide vpn access to other docker containers.

## Requirements

- openvpn config that must be mounted to `/openvpn.ovpn`
- a docker secret for the username (must be named vpn_user in the container)
- a docker secret for the password (must be named vpn_password in the container)

## Extras

Use the `dns:` entry in your compose file to force docker to use the vpn dns servers, if this is a wanted behavior.

## Usage

Use it straight from your compose file:

```
version: '3.3'

services:
  openvpn-client:
    cap_add: # This will make the container able to control networks.
      - net_admin
    container_name: openvpn-client
    devices: # Make sure to mount the tun device on the host.
      - /dev/net/tun:/dev/net/tun
    dns: # You probably want your vpn client to do lookup through your vpn provider to prevent dns leaks.
      - 146.185.134.104
      - 192.241.172.159
    image: dotslashme/openvpn-client
    secrets:
      - vpn_user # Must be named vpn_user here since it's used for lookup in the container.
      - vpn_password # Must be named vpn_password here since it's used for lookup in the container.
    volumes: # Make sure to bind your vpn config to /openvpn.ovpn
      - type: bind
        source: ./config.ovpn
        target: /config.ovpn
  test:
    image: alpine:latest
    network_mode: service:openvpn-client # Make this container use the vpn network connection.
    command: /bin/sh -c "wget http://icanhazip.com/ && cat index.html && rm -f index.html"
    restart: unless-stopped

secrets:
  vpn_user:
    file: ./vpn_user
  vpn_password:
    file: ./vpn_password
```

The other service that should use the vpn connection must have the following in its declaration:
`network_mode: service:openvpn-client`