#!/bin/bash
#Copy paper scripts over to volume, but do not overwrite an existing one.
cd /root/
cp -n paperstart.sh /data/paperstart.sh
cp -n paperupdate.sh /data/paperupdate.sh
#change the working directory to /data to run the scripts
cd /data/
#execute the update script
echo executing update script...
exec ./paperupdate.sh
