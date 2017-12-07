FROM ubuntu  
MAINTAINER reguang jiao  "rg.jiao@gmail.com"
RUN apt-get -qq update && apt-get -y install wget lynx && rm -rf /var/lib/apt/lists/*
COPY gfsgo.sh  /home/
VOLUME /data
# COPY luoboken.nodel  /data
WORKDIR /home
CMD ./gfsgo.sh
