# PaperMC-Docker
A PaperMC minecraft server for docker. 

## Features
* Download and run any version of a PaperMC server .jar
* Configure max heap size
* Choose to automatically/prompt update to the latest version of paper on launch.
* Uses OpenJ9 JavaVM

## How to use this image
1. Run this image for the first time:
	* Mount /data to a directory where you want your server files on your drive
	* (-v /serverfiles/go/here:/data)
2. Open the newly copied paper scripts (paperstart.sh and paperupdate.sh) in a text editor
3. Modify the variables UPDATE, VERSION and HEAP_SIZE to your liking (read below or comments inside file for values)
4. Save these files
5. Run the docker container again. It should start up your minecraft server.
	* If you're not using docker host networking, remember to expose ports 25565 tcp/udp

THIS FILE IS WIP
