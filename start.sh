#!/bin/bash
cd /root/
# Check if HACKABLE is set, then execute the scripts from the /data/ directory instead.
if [ "$HACKABLE" = "YES" ] ; then
  cp -n paperstart.sh /data/paperstart.sh
  cp -n paperupdate.sh /data/paperupdate.sh
  cd /data/
fi
#execute the update script
echo executing update script...
exec ./paperupdate.sh
