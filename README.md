# PaperMC-OpenJ9
A Paper Minecraft server for Docker, using the OpenJ9 JVM.

## Features
* Download and run any version of a Paper server .jar
* Choose to automatically/prompt update to the latest version of paper on launch.
* Uses OpenJ9 JVM for better container performance. [Here's why.](https://steinborn.me/posts/tuning-minecraft-openj9/)

## How to use this image
This image can be pulled from the [Docker Hub](https://hub.docker.com/repository/docker/epicbusta/papermc-openj9).

1. Run this image for the first time:
	* Mount /data to a directory where you want your server files on your drive (-v /serverfiles/go/here:/data)
2. Open the newly copied paper scripts (paperstart.sh and paperupdate.sh) in a text editor
3. Modify the variables UPDATE, VERSION and HEAP_SIZE to your liking (read below or comments inside file for values)
4. Save these files
5. Run the container again. It should start up your Minecraft server.
	* If you're not using host networking, remember to publish port 25565 (-p 25565)
6. Now you have a working Minecraft Server, running in a Docker container. Connect to it via the device's IP.

## Variables
Set inside paperupdate.sh and paperstart.sh. Put your setting **inside** the quotations. (e.g. "1.16.2", "YES")
#### UPDATE
##### Auto-Update behavior
`YES` `PROMPT` `NO`

Changes how the Paper jar will be updated when the container is launched.

`YES` will check and update the Paper jar on every container launch. *Potentially* risky. A (*incredibly rare*) bad PR to Paper may put your files at risk. This option is good for maximum performance.

`NO` will never update the Paper jar.

`PROMPT` will prompt the user of what they wish to do. A good compromise between `YES` and `NO`, but requires user input.

1. `YES` will update the jar.
2. `NO` will not update the jar
3. `EXIT` will not do anything, terminating the container.


#### VERSION
##### Set the Minecraft version.
The Minecraft server you want to run (e.g. 1.16.2)

Not sure if there is a Paper jar for this version? Just copy the URL below into your address bar, replacing VERSION with your version. It should start downloading the latest jar for that particular version.

https://papermc.io/api/v1/paper/VERSION/latest/download


#### HEAP_SIZE
##### Configure max RAM consumption
An integer in megabytes (MB). By default this value is 2048MB, meant for small SMP servers.
This value is limited by the total RAM in your system.

# Acknowledgements
#### Andrew Steinborn's OpenJ9 Flags
Created the script and flags to launch the server. They've been slightly modified to use the virtualized flag and use 2048MB RAM instead of 4096MB (for Synology NAS users).
His blog post on Minecraft and the OpenJ9 JVM can be found [here](https://steinborn.me/posts/tuning-minecraft-openj9/).
