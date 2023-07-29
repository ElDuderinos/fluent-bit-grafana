# https://github.com/fluent/fluent-bit/issues/1499
FROM fluent/fluent-bit:latest

COPY *.conf *.lua /fluent-bit/etc/

ENTRYPOINT [ "/fluent-bit/bin/fluent-bit" ]
CMD [ "-c", "/fluent-bit/etc/fluent-bit.conf" ]