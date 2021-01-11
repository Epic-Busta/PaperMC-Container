#!/bin/bash
# Uses java arguments found here: https://www.reddit.com/r/admincraft/comments/bmn889/vanilla_minecraft_server_1141pre2_experiencing/emy79tk/
# Script format adapted from Andrew Steinborn's tuned OpenJ9 server script. https://steinborn.me/posts/tuning-minecraft-openj9/
#

## BEGIN CONFIGURATION
# HEAP_SIZE: Maximum size of the heap. The maximum amount of memory you want to allocate.
#            Note: Unused heap will be uncommitted and released back to the OS.
#            By default, this is set to 2048MB, or 2GB.
#            These are now set with container environment variables. Uncomment if you want to use this instead.

# HEAP_SIZE=2048

# JAR_NAME:  The name of your server's JAR file. The default is
#            "paperclip.jar".
#
#            Side note: if you're not using Paper (http://papermc.io),
#            then you should really switch.
#            This is now set with container environment variables. Uncomment if you want to use this instead.
# JAR_NAME=paperclip.jar

## END CONFIGURATION -- DON'T TOUCH ANYTHING BELOW THIS LINE!
cd /data/
if [ -z "$HEAP_SIZE" ] ; then
  echo 'HEAP_SIZE not set. Terminating.'
  sleep 1
  exit
fi
# OpenJ9 Nursury configuration
# Compute the nursery size.
NURSERY_MINIMUM=$(($HEAP_SIZE / 2))
NURSERY_MAXIMUM=$(($HEAP_SIZE * 4 / 5))

# Launch the server.
case "$PaperGC" in
  G1GC)
    CMD="java -Xms${HEAP_SIZE}M -Xmx${HEAP_SIZE}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar nogui"
    ;;

  Gencon)
    CMD="java -Xms${HEAP_SIZE}M -Xmx${HEAP_SIZE}M -Xmns${NURSERY_MINIMUM}M -Xmnx${NURSERY_MAXIMUM}M -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc -Xtune:virtualized -jar ${JAR_NAME}"
    ;;

  Shenandoah)
    CMD="java -server -Xmx${HEAP_SIZE}M -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:+AlwaysPreTouch -XX:MaxGCPauseMillis=100 -XX:+ExplicitGCInvokesConcurrent -XX:+ParallelRefProcEnabled -XX:ShenandoahUncommitDelay=10000 -XX:ShenandoahGuaranteedGCInterval=60000"
    ;;
esac
echo "launching server with command line: ${CMD}"
exec ${CMD}

## END SCRIPT
