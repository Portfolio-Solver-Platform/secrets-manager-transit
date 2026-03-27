FROM ghcr.io/openbao/openbao:2.5.1@sha256:87d715029a47328172774638cabfeb04d5b356678d660621b796b6a671f93581

RUN mkdir -p /openbao/data && chown -R openbao:openbao /openbao/data

COPY --chown=openbao:openbao config.hcl /openbao/config/config.hcl

EXPOSE 8200

ENTRYPOINT ["bao", "server", "-config=/openbao/config/config.hcl"]
