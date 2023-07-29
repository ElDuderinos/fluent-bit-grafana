# https://github.com/fluent/fluent-bit/issues/1499
FROM fluent/fluent-bit:latest as fluent-bit

FROM ubuntu:latest as lua-libs

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libpcre2-dev luarocks

RUN luarocks install lua-cjson \
    && luarocks install lrexlib-pcre2

# https://github.com/fluent/fluent-bit/blob/master/Dockerfile#L60
FROM ubuntu:latest

COPY --from=fluent-bit \
    /usr/lib/x86_64-linux-gnu/libsasl*.so* \
    /usr/lib/x86_64-linux-gnu/libssl.so* \
    /usr/lib/x86_64-linux-gnu/libcrypto.so* \
    /usr/lib/x86_64-linux-gnu/libyaml*.so* \
    /usr/lib/x86_64-linux-gnu/

COPY --from=fluent-bit \
    /usr/lib/x86_64-linux-gnu/libpq.so* \
    /usr/lib/x86_64-linux-gnu/libgssapi* \
    /usr/lib/x86_64-linux-gnu/libldap* \
    /usr/lib/x86_64-linux-gnu/libkrb* \
    /usr/lib/x86_64-linux-gnu/libk5crypto* \
    /usr/lib/x86_64-linux-gnu/liblber* \
    /lib/x86_64-linux-gnu/libkeyutils* \
    /lib/x86_64-linux-gnu/

COPY --from=fluent-bit /fluent-bit/bin/ /fluent-bit/bin/
COPY --from=lua-libs /usr/local/lib/lua/ /usr/local/lib/lua/
COPY *.conf *.lua /fluent-bit/etc/

RUN ldd /fluent-bit/bin/fluent-bit | sort \
    && /fluent-bit/bin/fluent-bit --version

ENTRYPOINT [ "/fluent-bit/bin/fluent-bit" ]
CMD [ "-c", "/fluent-bit/etc/fluent-bit.conf" ]