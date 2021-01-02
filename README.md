# PaperMC Server for Containers (WORK IN PROGRESS)
A Paper Minecraft server container with selectable garbage collectors.

This might not work yet. I'm just ironing out any problems and I should really be testing these locally instead of pushing to the repo
## Features
* Download and run any version of a Paper server .jar
* Choose to automatically/prompt update to the latest version of paper on launch.
* Pick between Aikar's G1 Flags, Andrew Steinborn's OpenJ9 tuned Gencon Flags or ShenandoahGC

## Which GC (tag) do I use?
Each one has benefits and drawbacks. If you still don't know, just use G1GC.

#### G1GC
Aikar's Optimised G1GC Flags. Its popular and effective at boosting performance over java defaults.
* Most servers use this. More of a standard that most servers use.
* Aikar's [Blog Post](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/) goes over how it works for transparency.
* Timings wont throw a fit for not using Aikar's Flags.

As I said before, If you aren't sure just use this.

#### OpenJ9 Gencon
Andrew Steinborn's tuned OpenJ9 flags. Takes inspiration from Aikar's Flags but its for OpenJ9.
* Smaller memory footprint.
* Similar performance to G1GC.

This is good in memory-limited situations. Otherwise it works similarly to Aikar's G1.

#### Shenandoah
A bit experimental. Designed for similar pause time regardless of allocated memory size.
* Concurrent Garbage Collection. Does its work while the server is running, instead of stopping (causing lag spikes)
* Low latency, regardless of heap size.
* Can release memory back to the OS. (Apparently the others can do this but its not recommended nor have I seen them do it.)
* A bit untested. The [flags used](https://www.reddit.com/r/admincraft/comments/bmn889/vanilla_minecraft_server_1141pre2_experiencing/emy79tk/) might not be very optimised yet.
* Some potential overhead. May not be worthwhile in some instances

While there may be large performance gains, I would not use this on live, critical servers without proper testing. Maybe try it if there are really severe lag problems and as a last effort. Some code (plugins etc.) may not play nice with Shenandoah.

## How to use this image
This image can be pulled from the [Docker Hub](https://hub.docker.com/repository/docker/epicbusta/papermc-openj9). The tag defines the GC used.

1. Run this image for the first time:
	* Mount /data to a directory where you want your server files on your drive (-v /serverfiles/go/here:/data)
2. Open the newly copied paper scripts (paperstart.sh and paperupdate.sh) in a text editor
3. Modify the variables UPDATE, VERSION and HEAP_SIZE to your liking (read below or comments inside file for values)
4. Save these files
5. Run the container again. It should start up your Minecraft server.
	* If you're not using host networking, remember to publish port 25565 (-p 25565) and any ports that you need (e.g. rcon, plugins etc.)
6. Now you have a working Minecraft Server, running in a Docker container.

Now you have a working Minecraft Server, running in a Docker container.

If you'd like to switch to a different garbage collector, just download the image using the desired tag and follow the instructions above. If you mount your volumes the same, you'll get the same server as before.

## Variables
Set inside paperupdate.sh and paperstart.sh. Put your setting **inside** the quotations. (e.g. "1.16.2", "YES")
### paperupdate.sh
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

### paperstart.sh
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
#### Aikar's Optimised G1GC Flags.
Researched and created an optimised set of flags for Minecraft servers using the G1 garbage collector. Used on most Minecraft servers out there.
Read his blog post about his flags [here](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/)
#### Andrew Steinborn's OpenJ9 Flags
Created the script and flags to launch the server. They've been slightly modified to use the virtualized flag and use 2048MB RAM instead of 4096MB (for Synology NAS users). I've also used the same format in his script for the other GCs for its simplicity.
His blog post on Minecraft and the OpenJ9 JVM can be found [here](https://steinborn.me/posts/tuning-minecraft-openj9/).
#### Shadowdane's Shenandoah flags from reddit
The [ONLY place](https://www.reddit.com/r/admincraft/comments/bmn889/vanilla_minecraft_server_1141pre2_experiencing/emy79tk/) I've seen any talk about Shenandoah actually being used on a server.
