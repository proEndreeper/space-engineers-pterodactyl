FROM mmmaxwwwell/wine6:latest

RUN apt --allow-releaseinfo-change update &&\
    apt install curl ca-certificates openssl git tar bash sqlite fontconfig lib32gcc1 -y &&\
    apt autoclean &&\
    apt autoremove -y &&\
    adduser --disabled-password --home /home/container container

WORKDIR /home/container

# Setup wine script
COPY install-winetricks /scripts/
RUN \
  mkdir /wineprefix &&\
  chown -R container:container /wineprefix &&\
  chmod +x /scripts/install-winetricks
# Setup steamcmd
RUN \
  mkdir /Steam &&\
  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /Steam &&\
  chown -R container:container /Steam &&\
  chmod +x /Steam/steamcmd.sh
# Entrypoint install
COPY entrypoint.bash /entrypoint.bash
COPY entrypoint-space_engineers.bash /entrypoint-space_engineers.bash
RUN chmod +x /entrypoint.bash && chmod +x /entrypoint-space_engineers.bash
# Initial configuration
RUN \
  mkdir -p /home/container/SpaceEngineersDedicated
COPY star-system.zip /star-system.zip
RUN unzip /star-system.zip -d /home/container/
RUN mv /home/container/SpaceEngineers-Dedicated.cfg /home/container/SpaceEngineersDedicated/

# Wine install
USER container
ENV USER=container HOME=/home/container

RUN bash -c /scripts/install-winetricks

CMD /entrypoint.bash