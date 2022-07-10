# PaperMC Server for Containers
A Paper Minecraft server container with selectable garbage collectors.


## Features
* Download and run any version of a Paper server .jar
* Choose to automatically/prompt update to the latest version of paper on launch.
* Pick between Aikar's G1 Flags, Andrew Steinborn's OpenJ9 tuned Gencon Flags or Shenandoah GC

## How to use this image
This image can be pulled from the [Docker Hub](https://hub.docker.com/repository/docker/epicbusta/papermc-openj9). The tag defines the GC used.

1. Mount /data to a directory where you want your server files on your drive (-v /serverfiles/go/here:/data)
2. Set your variables (via -e). See the Variables section.
3. Run the container, the container will terminate. Go to the volume and accept the Mojang EULA (eula.txt).
4. Run the container again.

Now you have a working Minecraft Server, running in a container.

If you'd like to switch to a different garbage collector, just download the image using the desired tag and follow the instructions above. If you mount your volumes the same, you'll get the same server (map, plugins etc.) as before.

You must configure the volume, or else you wont be able to accept the Mojang EULA. It is a good check since you won't have access to your world files forever (without some weird trickery) or any of the config files if you don't do it.

## Which GC (tag) do I use?
Each one has benefits and drawbacks. If you're not sure, just use G1GC.

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

This is good in memory-limited situations. Otherwise it performs similarly to Aikar's G1GC.

#### ZGC
Experimental, concurrent, low latency garbage collector. Likely a potential successor to G1GC.
* Concurrent Garbage Collection. Does its work while the server is running, instead of stopping (causing lag spikes)
* Low latency, even as the heap size gets bigger
* Can release memory back to the OS if needed. (Apparently the others can do this but its not recommended nor have I seen them do it.)
* Some potential overhead. May not be worthwhile in some instances.


#### Shenandoah
Experimental. Designed for similar pause time regardless of allocated memory size.
* Similar goals to ZGC.
* A bit untested. The [flags used](https://www.reddit.com/r/admincraft/comments/bmn889/vanilla_minecraft_server_1141pre2_experiencing/emy79tk/) might not be very optimised yet.
* Some potential overhead. May not be worthwhile in some instances

### Potential performance impacts of Concurrent and Stop-the-World GC's
Concurrent garbage collectors (ZGC/Shenandoah) remove the lag spikes made by "stop-the-world" garbage collectors (G1/Gencon), however result in a general increase in CPU usage. Most server hosts will use Aikar's G1GC, because of its proven repuation and its low performance hit to increase the amount of Minecraft servers that can be run off one machine.

Concurrent garbage collecters will suffer in situations where memory allocation pressure is high (e.g. high player-count survival) and G1GC is recommended here due to its higher throughput. Where allocation pressure is low (e.g low player-count survival, minigames etc.) ZGC and Shenandoah will perform better.
See [this](https://krusic22.com/2020/03/25/higher-performance-crafting-using-jdk11-and-zgc/) article from krusic22 if you're insterested.



## Variables
Set via ENV variables. In docker, use -e, followed by any variables in double quotations. e.g. -e "UPDATE=YES" "VERSION=1.16.4" "HEAP_SIZE=2048"

`UPDATE` `VERSION` and `HEAP_SIZE` must be set, The container will terminate if not done.

#### **UPDATE**
##### Auto-Update behaviour
`YES` `PROMPT` `NO`

Changes how the Paper jar will be updated when the container is launched.

`YES` will check and update the Paper jar on every container launch. *Potentially* risky. A (*incredibly rare*) bad PR to Paper may put your files at risk. This option is good for maximum performance.

`NO` will never update the Paper jar.

`PROMPT` will prompt the user of what they wish to do. A good compromise between `YES` and `NO`, but *requires user input.*

1. `YES` will update the jar.
2. `NO` will not update the jar
3. `EXIT` will not do anything, terminating the container.

#### **VERSION**
##### Set the Minecraft version.
The Minecraft server you want to run (e.g. 1.16.2)

Not sure if there is a Paper jar for this version? Just copy the URL below into your address bar, replacing VERSION with your version. It should start downloading the latest jar for that particular version.

https://papermc.io/api/v1/paper/VERSION/latest/download

If you get an error when running the server, check that you've put the correct version as the variable and there is actually a downloadable jar using the test URL above.

#### **HEAP_SIZE**
##### Configure max RAM consumption
An integer in megabytes (MB). By default this value is 2048MB, meant for small SMP servers.
This value is limited by the total RAM in your system.

#### PaperGC
##### Change the GC from the image to something else, with limitations.
If *for whatever reason* you need or want to switch GC, you can do so here. Its recommended to leave this alone, since its already set from the image. Also there aren't many GCs available in this image so there isn't much point.

You can't use Hotspot GCs in OpenJ9 and vice versa.

Hotspot:

`G1GC` `Shenandoah` `ZGC`

OpenJ9:

`Gencon`

#### JAR_NAME
##### Sets what the server .jar file to run.
By default it is paperclip.jar. This is mainly if you want to run a custom server (Forge, Sponge etc.)other than paper.

If this is set, a paperclip jar will not be downloaded.

#### HACKABLE
##### Puts the shell files in the volume directory, so you can change stuff.
When set to `YES`, copies the two shell scripts into /data/, where your volume should be mounted and uses them instead. All the variables above can be set there. You can also make any edits.

If you make a mistake and can't go back, just delete the bad shell file and turn the container on and off to copy a fresh shell file into the volume. If you remove the `HACKABLE` variable, the container will ignore the scripts in the volume. Keep `HACKABLE=YES` to use your changes.

PLEASE don't go into /root/ to change the original scripts. If you mess up, you can't go back!

# Acknowledgements
#### Aikar's Optimised G1GC Flags.
Researched and created an optimised set of flags for Minecraft servers using the G1 garbage collector. Used on most Minecraft servers out there.
Read his blog post about his flags [here](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/)
#### Andrew Steinborn's OpenJ9 Flags
Created the script and flags to launch the server. They've been slightly modified to use the virtualized flag since its being used in a container (might not be needed? may change in the future). I've also used the same format in his script for the other GCs for its simplicity.
His blog post on Minecraft and the OpenJ9 JVM can be found [here](https://steinborn.me/posts/tuning-minecraft-openj9/).
#### Shadowdane's Shenandoah flags from reddit
The [ONLY place](https://www.reddit.com/r/admincraft/comments/bmn889/vanilla_minecraft_server_1141pre2_experiencing/emy79tk/) I've seen any talk about Shenandoah actually being used on a server.
#### Kursic22's blog post on ZGC and Minecraft
Wrote a detailed [blog post](https://krusic22.com/2020/03/25/higher-performance-crafting-using-jdk11-and-zgc/) on the pros and cons of using ZGC for a Minecraft server. Consider having a deeper read into this if you're interested in using ZGC for your Minecraft server.
