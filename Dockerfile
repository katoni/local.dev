FROM alpine

LABEL maintainer="martin@katoni.dk"

ENV LOCALDEV_DOMAIN=local.dev
ENV LOCALDEV_NETWORK=local.dev
ENV LOCALDEV_CONSTRAINTS_LABEL_KEY=local.dev.enable
ENV LOCALDEV_CONSTRAINTS_LABEL_VALUE=true

ENV LEGO_CA_CERTIFICATES=/run/secrets/root_ca.crt

RUN apk add --update openssl supervisor && rm  -rf /tmp/* /var/cache/apk/*

COPY ca.json supervisord.conf traefik.yml /usr/local/etc/

COPY traefik /usr/local/etc/traefik

COPY docker-entrypoint /usr/local/bin/

COPY --from=traefik:2.9 /usr/local/bin/traefik /usr/local/bin/
COPY --from=smallstep/step-ca /usr/local/bin/step-ca /usr/local/bin
COPY --from=smallstep/step-cli /usr/local/bin/step /usr/local/bin

ENTRYPOINT ["docker-entrypoint"]

CMD ["supervisord", "--nodaemon", "--configuration", "/usr/local/etc/supervisord.conf"]

EXPOSE 80
EXPOSE 443

