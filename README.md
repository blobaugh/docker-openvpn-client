curl https://ipinfo.io/ip


apt update && apt install curl && curl  https://ipinfo.io/ip

apt update &&  apt install iproute2 curl -y && curl  https://ipinfo.io/ip

docker run -it --network="container:openvpn-client" ubuntu bash

docker build -t blobaugh/openvpn-client . && dc up && dc down && dc stop

# OpenVPN Client for Docker

This is a Docker image of an OpenVPN client that supports many common VPN service providers. 

## Why would I use this?

Running a vpn client as a Docker container provides a method of encrypting communication of other containers through the VPN. All that has to be done is to point the other containers network to the VPN container. For instance, in `docker-compose.yml` this would look like `network_mode: service:openvpn-client`.

## What VPN services are supported?

The following is a list of currently supported VPN services. This image is designed to be easily expandable, and new VPN services can be easily added. 

List of services currently supported:

* [TunnelBear](https://www.tunnelbear.com)
* [Private Internet Access (PIA)](https://www.privateinternetaccess.com)

## How to add support for a new VPN service

Adding support for a new VPN service is generall accomplished by copying in the *.ovpn files to the service's folder.

Lets walk through an example of adding support for PIA.

* Under the `services` folder, create a new folder for the service. In this case, name it `pia`.
* Add the `*.ovpn` and supporting files from your VPN service.
* Edit the `*.ovpn` files to ensure file system paths point properly to other files, such as key files.
* E.G: `ca CACertificate.crt` becomes `/services/pia/ca CACertificate.crt`


# Sections still to add

* Quick Start
* Config options
* Using the `.env` file
* Contributing
** How to
** Building the image
** Deploy to dockerhub
* Troubleshooting
** IPv6 issues (get pull example from tunnelbear ovpn files)
* How to verify the VPN is connected (with docker exec)
* Running with `docker run`
* Running with `docker-compose`

# ToDo

* Do not allow traffic until VPN connection is running

