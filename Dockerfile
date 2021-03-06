ARG BASE_IMAGE_PREFIX

FROM multiarch/qemu-user-static as qemu

FROM ${BASE_IMAGE_PREFIX}alpine

ARG OMBI_URL
ARG OMBI_RELEASE

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/

ENV PUID=0
ENV PGID=0
ENV HOME="/config"

COPY scripts/start.sh /

RUN apk -U --no-cache upgrade
RUN apk add --no-cache icu-dev libunwind curl-dev gcompat libc6-compat
RUN apk add --no-cache --virtual=.build-dependencies ca-certificates curl

RUN mkdir -p /opt/ombi /config
RUN curl -o - -L "${OMBI_URL}" | tar xz -C /opt/ombi/
RUN chmod -R 777 /start.sh /config /opt/ombi

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /usr/bin/qemu-*-static

# ports and volumes
EXPOSE 5000
VOLUME /config

CMD ["/start.sh"]