#!/usr/bin/env bash

set -e

###################
# START CONFIG
###################

# VPN service folder
VPN_SERVICE_FOLDER="/services/$VPN_SERVICE"
# VPN service configuration file
VPN_OVPN="$VPN_SERVICE_FOLDER/$VPN_SERVER.ovpn"

# VPN user/pass file
VPN_AUTH_FILE="/services/login.key"

# Extra params passed to openvpn client. See https://community.openvpn.net/openvpn/wiki/Openvpn23ManPage
VPN_EXTRAS="--ping 15"

# The following are from the .env file
# VPN_SERVICE
# VPN_SERVER
# VPN_USER
# VPN_PASS

###################
# END CONFIG
###################

# Setup the user/pass login file
rm -f $VPN_AUTH_FILE
touch $VPN_AUTH_FILE

echo $VPN_USER >> $VPN_AUTH_FILE
echo $VPN_PASS >> $VPN_AUTH_FILE

# Debugging
echo "
-- VPN Configuration ---
"

echo "oVPN configuration file: $VPN_OVPN"

echo "VPN auth file: $VPN_AUTH_FILE"

# Verify the vpn service file exists
if [ ! -d "$VPN_SERVICE_FOLDER" ]; then
	echo "Invalid VPN service: $VPN_SERVICE"
	exit
fi

# Verify the vpn config file exists
if [ ! -f "$VPN_OVPN" ]; then
	echo "Unable to find VPN server: $VPN_SERVER"
	exit
fi

# Hard update the local DNS nameserver
echo 'nameserver 1.1.1.1' > /etc/resolv.conf

# Kick off the connection
echo "
--- Starting VPN Client ---
"

# See https://community.openvpn.net/openvpn/wiki/Openvpn23ManPage
openvpn $VPN_EXTRAS --config "$VPN_OVPN" --auth-user-pass $VPN_AUTH_FILE


