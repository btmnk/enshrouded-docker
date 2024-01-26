# derived from https://github.com/jsknnr/enshrouded-server

FROM debian:12

ENV DEBIAN_FRONTEND "noninteractive"

ENV ENSHROUDED_PATH "/home/steam/enshrouded"
ENV ENSHROUDED_CONFIG "${ENSHROUDED_PATH}/enshrouded_server.json"

ENV WINEPREFIX "/home/steam/.enshrouded_prefix"
ENV WINEARCH "win64"

RUN groupadd -g 10000 steam \
    && useradd -g 10000 -u 10000 -m steam \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        wget \
        jq \
        lib32gcc-s1 \
        cabextract \
        winbind \
        xvfb \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-stable \
    && wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/local/bin/winetricks

USER steam

RUN mkdir "$ENSHROUDED_PATH" \
    && mkdir "$ENSHROUDED_PATH"/savegame \
    && mkdir "$WINEPREFIX" \
    && mkdir /home/steam/steamcmd \
    && curl -sqL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxvf - -C /home/steam/steamcmd \
    && chmod +x /home/steam/steamcmd/steamcmd.sh \
    && /home/steam/winetricks.sh

# Add scripts
ADD ./winetricks.sh /home/steam/winetricks.sh
RUN chmod +x /home/steam/winetricks.sh
ADD ./entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

WORKDIR /home/steamcdn

# Use entrypoint or CMD
ENTRYPOINT [ "/home/steam/entrypoint.sh" ]
