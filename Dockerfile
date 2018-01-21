FROM remcoperlee/base:0.1.0
MAINTAINER Remco Perlee <remco.perlee@gmail.com>

RUN apt-get update && apt-get install -y \
  imagemagick \
  lsof \
  wget \
  debconf-utils \
  openjdk-9-jdk

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs

RUN wget -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk

# add users & set directories
RUN useradd -M -s /bin/false --uid 1000 minecraft \
  && mkdir /data \
  && mkdir /config \
  && mkdir /mods \
  && mkdir /plugins \
  && chown minecraft:minecraft /data /config /mods /plugins
VOLUME ["/data", "/mods", "/config", "/plugins"]

# copy required files
COPY start-minecraft.sh /start-minecraft
COPY server.properties /tmp/server.properties

WORKDIR /data

EXPOSE 25565

CMD [ "/start-minecraft" ]




# Special marker ENV used by MCCY management tool
# ENV MC_IMAGE=YES
# ENV UID=1000 GID=1000
# ENV MOTD A Minecraft Server Powered by Docker
# ENV JVM_OPTS -Xmx1024M -Xms1024M
# ENV \
#   TYPE=VANILLA \
#   VERSION=LATEST \
#   FORGEVERSION=RECOMMENDED \
#   LEVEL=world \
#   PVP=true DIFFICULTY=easy \
#   LEVEL_TYPE=DEFAULT \
#   GENERATOR_SETTINGS= \
#   WORLD= \
#   MODPACK=
