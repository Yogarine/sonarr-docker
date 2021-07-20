ARG DISTRIB_CODENAME="focal"

FROM ubuntu:${DISTRIB_CODENAME} AS base
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get --yes --quiet update \
 && apt-get --yes --quiet install --no-install-recommends ca-certificates curl libicu66 mediainfo sqlite3 \
 && apt-get --yes --quiet clean \
 && rm --recursive /var/lib/apt/lists/*


FROM ubuntu:${DISTRIB_CODENAME} AS build
ARG SONARR_VERSION

ADD ["https://sonarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64&version=${SONARR_VERSION}", "/root/Sonarr.linux-core-x64.tar.gz"]

RUN tar --extract --file '/root/Sonarr.linux-core-x64.tar.gz' --directory '/opt'


FROM base AS sonarr
COPY --from=build --chown=root:root /opt/Sonarr /opt/Sonarr

RUN addgroup --gid 666 sonarr \
 && adduser --disabled-password --uid 666 --gid 666 sonarr \
 && chown --verbose sonarr:sonarr /opt/Sonarr

USER sonarr

RUN mkdir --verbose --parents /home/sonarr/.config/Sonarr

VOLUME /home/sonarr/.config/Sonarr

WORKDIR /opt/Sonarr

CMD ["/opt/Sonarr/Sonarr", "-nobrowser", "-data=/home/sonarr/.config/Sonarr"]
