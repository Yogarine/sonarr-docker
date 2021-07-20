ARG DISTRIB_CODENAME="focal"

FROM ubuntu:${DISTRIB_CODENAME}
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get --yes --quiet update \
 && apt-get --yes --quiet install --no-install-recommends ca-certificates gnupg \
 && apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 2009837CBFFD68F45BC180471F4F90DE2A9B4BF8 \
 && apt-get --yes --quiet autoremove --purge gnupg \
 && apt-get --yes --quiet clean \
 && rm --recursive /var/lib/apt/lists/*

COPY etc/apt /etc/apt

RUN addgroup --gid 666 sonarr \
 && adduser --disabled-password --uid 666 --gid 666 sonarr \
 && apt-get --yes --quiet update \
 && apt-get --yes --quiet install sonarr \
 && apt-get --yes --quiet clean \
 && rm --recursive /var/lib/apt/lists/*

USER sonarr

VOLUME /var/lib/sonarr

CMD ["/usr/bin/mono", "/usr/lib/sonarr/bin/Sonarr.exe", "-nobrowser", "-data=/var/lib/sonarr"]
