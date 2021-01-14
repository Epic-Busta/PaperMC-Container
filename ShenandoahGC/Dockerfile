FROM adoptopenjdk:hotspot

SHELL ["/bin/bash", "-c"]
#Copy server auto-update script and server configuration scripts.
COPY *.sh /root/

# Volumes for the external data (Server, World, Config...)
VOLUME /data

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

#Set Environment Variable for which GC to use
ENV PaperGC=Shenandoah
ENV JAR_NAME=paperclip.jar

WORKDIR /root
#set permissions for the scripts to run without elevation.
RUN ["chmod", "a+x", "start.sh"]
RUN ["chmod", "a+x", "paperstart.sh"]
RUN ["chmod", "a+x", "paperupdate.sh"]

# Run script to copy update and start scripts to volume
ENTRYPOINT ./start.sh
