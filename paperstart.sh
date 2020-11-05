#!/bin/bash

#
# Tuned OpenJ9 Minecraft Server Script created by Andrew Steinborn (steinborn.me/posts/tuning-minecraft-openj9/)
# Slightly modified to run (by default) using 2GB instead of 4GB for use in small docker containers, and to end the docker container when the server is stopped..
#
# Properly tunes a Minecraft server to run efficiently under the
# OpenJ9 (https://www.eclipse.org/openj9) JVM.
#
# Licensed under the MIT license.
#

## BEGIN CONFIGURATION

# HEAP_SIZE: This is how much heap (in MB) you plan to allocate
#            to your server. By default, this is set to 2048MB,
#            or 2GB.
HEAP_SIZE=2048

# JAR_NAME:  The name of your server's JAR file. The default is
#            "paperclip.jar".
#
#            Side note: if you're not using Paper (http://papermc.io),
#            then you should really switch.
JAR_NAME=paperclip.jar

## END CONFIGURATION -- DON'T TOUCH ANYTHING BELOW THIS LINE!

## BEGIN SCRIPT

# Compute the nursery size.
NURSERY_MINIMUM=$(($HEAP_SIZE / 2))
NURSERY_MAXIMUM=$(($HEAP_SIZE * 4 / 5))

# Launch the server.
CMD="java -Xms${HEAP_SIZE}M -Xmx${HEAP_SIZE}M -Xmns${NURSERY_MINIMUM}M -Xmnx${NURSERY_MAXIMUM}M -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc -Xtune:virtualized -jar ${JAR_NAME}"
echo "launching server with command line: ${CMD}"
exec ${CMD}

## END SCRIPT
