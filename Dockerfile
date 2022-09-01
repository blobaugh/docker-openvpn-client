FROM ubuntu

RUN apt update && \
	apt install openvpn curl speedtest-cli -y

COPY services /services
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]