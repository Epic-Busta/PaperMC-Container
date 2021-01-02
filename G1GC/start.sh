#!/bin/bash
#Copy paper scripts over to volume, but do not overwrite an existing one.
cd /root/
cp -n paperstart.sh /data/paperstart.sh
cp -n paperupdate.sh /data/paperupdate.sh
#Set variable for which GC is being used.
printf "PaperGC=G1GC" >> ~/.bashrc
#change the working directory to /data to run the scripts
cd /data/
#execute the update script
echo executing update script...
exec ./paperupdate.sh
