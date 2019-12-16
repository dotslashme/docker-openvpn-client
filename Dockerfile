FROM alpine

RUN apk update --no-cache \
    && apk add --no-cache openvpn

COPY openvpn /

ENTRYPOINT ["/openvpn"]