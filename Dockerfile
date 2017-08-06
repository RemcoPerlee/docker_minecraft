FROM remcoperlee/base:0.1.0
MAINTAINER Remco Perlee <remco.perlee@gmail.com>

# ENV APT_GET_UPDATE 2015-10-03
RUN apt-get update && apt-get install -y \
  libmozjs-24-bin \
  imagemagick \
  lsof \
  wget \
  software-properties-common \
  python-software-properties \
  && apt-get clean
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

RUN wget -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk

# Java 1.8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
# Auto accept license agreement
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get install -y oracle-java8-installer

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
