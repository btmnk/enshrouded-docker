# derived from https://github.com/PR3SIDENT/enshrouded-server/tree/main

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND "noninteractive"
ENV WINEPREFIX "/home/steam/.enshrouded_prefix"
ENV WINEARCH "win64"
ENV WINEDEBUG "-all"

# Install base packages
RUN set -x \
&& apt update \
&& apt install -y \
    wget \
    software-properties-common

# Install steamCMD with prerequisites
RUN add-apt-repository -y multiverse \
&& dpkg --add-architecture i386 \
&& apt update \
&& echo steam steam/question select "I AGREE" | debconf-set-selections && echo steam steam/license note '' | debconf-set-selections \
&& apt install -y \
    lib32z1 \
    lib32gcc-s1 \
    lib32stdc++6 \
    steamcmd \
&& groupadd steam \
&& useradd -m steam -g steam \
&& chown -R steam:steam /usr/games \
&& ln -s /usr/games/steamcmd /home/steam/steamcmd

# Install wine, winetricks and prerequisites
RUN dpkg --add-architecture amd64 \
&& mkdir -pm755 /etc/apt/keyrings \
&& wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
&& wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
&& apt update \
&& apt install -y --install-recommends \
    winehq-stable \
&& apt install -y --allow-unauthenticated \
    cabextract \
    winbind \
    screen \
    xvfb \
&& wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
&& chmod +x /usr/local/bin/winetricks

# Prepare directories
RUN mkdir /home/steam/.enshrouded_prefix \
&& mkdir /home/steam/enshrouded \
&& mkdir /home/steam/enshrouded/savegame \
&& mkdir /home/steam/enshrouded/logs \
&& chown -R steam:steam /home/steam

# Add scripts
ADD ./winetricks.sh /home/steam/winetricks.sh
RUN chmod +x /home/steam/winetricks.sh
ADD ./entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

# Build environment
USER steam
RUN /home/steam/steamcmd +quit \
    /home/steam/winetricks.sh

WORKDIR /home/steam

# Map volume
VOLUME /home/steam/enshrouded

# Expose ports
EXPOSE 15636 15637

# Use entrypoint or CMD
ENTRYPOINT [ "/home/steam/entrypoint.sh" ]