FROM alpine

RUN apk update --no-cache \
    && apk add --no-cache openvpn openresolv bash \ 
    && wget -O /etc/openvpn/update-resolv-conf https://raw.githubusercontent.com/alfredopalhares/openvpn-update-resolv-conf/master/update-resolv-conf.sh \
    && chmod +x /etc/openvpn/update-resolv-conf

COPY openvpn /

ENTRYPOINT ["/openvpn"]