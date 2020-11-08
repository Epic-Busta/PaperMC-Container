FROM adoptopenjdk:14-jre-openj9

SHELL ["/bin/bash", "-c"]
#Copy server auto-update script and server configuration scripts.
COPY *.sh /root/

# Volumes for the external data (Server, World, Config...)
VOLUME /data

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

WORKDIR /root
#set permissions for the scripts to run without elevation.
RUN ["chmod" "a+x" "*.sh"]

# Run script to copy update and start scripts to volume
ENTRYPOINT ./start.sh
