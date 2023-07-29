# https://github.com/fluent/fluent-bit/issues/1499
FROM fluent/fluent-bit:latest as fluent-bit

FROM ubuntu:latest as lua-libs

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libpcre2-dev luarocks

RUN luarocks install lua-cjson \
    && luarocks install lrexlib-pcre2

# https://github.com/fluent/fluent-bit/blob/master/Dockerfile#L60
FROM fluent-bit

COPY --from=lua-libs /usr/local/lib/lua/ /usr/local/lib/lua/
COPY *.conf *.lua /fluent-bit/etc/

ENTRYPOINT [ "/fluent-bit/bin/fluent-bit" ]
CMD [ "-c", "/fluent-bit/etc/fluent-bit.conf" ]