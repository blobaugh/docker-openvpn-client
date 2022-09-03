# OpenVPN Client for Docker

This is a Docker image of an OpenVPN client that supports many common VPN service providers. 

## Why would I use this?

Running a vpn client as a Docker container provides a method of encrypting communication of other containers through the VPN. All that has to be done is to point the other containers network to the VPN container. For instance, in `docker-compose.yml` this would look like `network_mode: service:openvpn-client`.

## How do I use it?

### Getting the container image

It can be pulled from Docker Hub or built on your machine.

To pull it from Docker Hub, run

`docker pull blobaugh/openvpn-client`

To build yourself, run

`docker build -t blobaugh/openvpn-client https://github.com/blobaugh/docker-openvpn-client` 

### Running the container

This image requires the container to have `NET_ADMIN` capability, and `/dev/net/tun` accessibility. The following are simplified examples of running the container. In order for you to run it the environment variables for the VPN provides must be set.


#### `docker run`

`docker run --cap-add=NET_ADMIN --device=/dev/net/tun blobaugh/openvpn-client`

#### `docker-compose`

```yaml
services:
	openvpn-client:
		image: blobaugh/openvpn-client
		container_name: openvpn-client
		cap_add:
			- NET_ADMIN
		devices:
			- /dev/net/tun
		restart: unless-stopped
```

### Environment variables

| Variable | Description |
| --- | --- |
| VPN_SERVICE | VPN Service to connect to. Must match the folder in the `services` directory. E.G `tunnelbear` | 
| VPN_SERVER | Which VPN endpoint to connect to. Must match a `services/VPN_SERVICE` file, without the extension. E.G `United States` |
| VPN_USER | VPN service account user name |
| VPN_PASS | VPN service account password |


### The `.env` file

For convenience, a `.env` file can be utilized to pass in configuration. An example file exists in `.env.example`. Rename this file to `.env` and fill it in with your values. 

#### `docker run`

`docker run --env-file .env [fill in the rest]`

#### `docker-compose`

```yaml
services:
	openvpn-client:
		env_file: .env 
		[fill in the rest]
```

## What VPN services are supported?

The following is a list of currently supported VPN services. This image is designed to be easily expandable, and new VPN services can be easily added. 

List of services currently supported:

| Service | VPN_SERVICE value |
| --- | --- |
| [TunnelBear](https://www.tunnelbear.com) | tunnelbear |
| [Private Internet Access (PIA)](https://www.privateinternetaccess.com) | pia |

## How to add support for a new VPN service

Adding support for a new VPN service is generall accomplished by copying in the `*.ovpn` files to the service's folder.

Lets walk through an example of adding support for PIA.

* Under the `services` folder, create a new folder for the service. In this case, name it `pia`.
* Add the `*.ovpn` and supporting files from your VPN service.
* Edit the `*.ovpn` files to ensure file system paths point properly to other files, such as key files.
* E.G: `ca CACertificate.crt` becomes `/services/pia/ca CACertificate.crt`


## Contributing

Pull requests for new features and VPN services are welcome.

Issues questions and feature requests can be made via a [GitHub Issue](https://github.com/blobaugh/docker-openvpn-client/issues)

### Building the image

From the directory with the `Dockerfile` run:

`docker build -t blobaugh/openvpn-client .`

### Deploy to Docker Hub

```bash
docker login
docker tag blobaugh/openvpn-client blobaugh/openvpn-client:TAGVERSION
docker push blobaugh/openvpn-client:TAGVERSION
```

### Ben's dev & testing command

`dc down && dc stop && docker build -t blobaugh/openvpn-client . && dc up`

## Troubleshooting

### IPv6 issues

Add the following to the `*.ovpn` file:

```
pull-filter ignore "ifconfig-ipv6 "
pull-filter ignore "route-ipv6 "
```

### How to verify the VPN is connected (with docker exec)

Run an Ubuntu container with this container as its network stack:

`docker run -it --network="container:openvpn-client" ubuntu bash`

Check the public IP inside the Ubuntu container:

`apt update &&  apt install iproute2 curl -y && curl  https://ipinfo.io/ip`

# ToDo

* Do not allow traffic until VPN connection is running

