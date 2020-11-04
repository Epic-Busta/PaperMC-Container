#!/bin/bash
#Papermc auto-update behavior: Sets whether to be to always auto-update , never auto-update, or to prompt to update or not to update on each launch
#valid entries: YES / NO / PROMPT
#invalid entries will terminate the docker container. Default value is PROMPT
#When auto-updating, it will ALWAYS download the latest papermc jar, regardless of the current version.
#You can manually update paper by setting UPDATE to NO and adding the jar yourself.

UPDATE="PROMPT"

#Sets the version of papermc to download when updating.
VERSION="1.16.3"

#DON'T TOUCH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING!

case "$UPDATE" in
	YES)
		echo UPDATE is set to YES.
		echo Downloading the latest papermc jar for version $version.
		curl "https://papermc.io/api/v1/paper/$VERSION/latest/download" > "paperclip.jar"
		exec ./paperstart.sh
		;;
		
	NO)
		echo UPDATE is set to NO. Papermc will not be updated.
		exec ./paperstart.sh
		;;
	
	PROMPT)
		echo "Do you want to update papermc now?"
		select yn in "YES" "NO" "EXIT"
		do
			case $yn in
				YES)
					echo Downloading the latest papermc jar for version $VERSION.
					curl "https://papermc.io/api/v1/paper/$VERSION/latest/download" > "paperclip.jar"
					exec ./paperstart.sh
					;;
				NO) 
					exec ./paperstart.sh
					;;
				EXIT)
					exit
			esac
		done
		;;
esac
#echo "Something went wrong. Either UPDATE was set incorrectly, or paperupdate.sh was modified and broke the script"
exit