#!/bin/bash
#These are now set with container environment variables. Uncomment if you want to set within this shell file.
#Paper auto-update behavior: Sets whether to be to always auto-update , never auto-update, or to prompt to update or not to update on each launch
#valid entries: YES / NO / PROMPT
#You can manually update paper by setting UPDATE to NO and adding the jar yourself.
#This is set with container environment variables now. Uncomment if you want to use this instead.
# UPDATE=""

#Sets the version of PaperMC (Minecraft version) to download when updating. If its for a very new version, check PaperMC.io if a jar is availiable.
#This is set with container environment variables now. Uncomment if you want to use this instead.
# VERSION=""

#DON'T TOUCH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING!

echo UPDATE is set to "$UPDATE"
echo VERSION is set to "$VERSION"
#if [ "$VERSION" = '' ] && [ "$UPDATE" = '' ] ; then
#	echo 'You have not set a version or an update mode (VERSION and UPDATE variables are empty)'
#	echo ''
#	echo 'These files should be located in the directory mounted as a volume (/data inside the container)'
#	sleep 40
#	exit
#fi
case "$UPDATE" in
	YES)
		echo Downloading the latest Paper jar for version "$VERSION".
		curl -z paperclip.jar "https://papermc.io/api/v1/paper/$VERSION/latest/download"  -o /data/paperclip.jar
		exec ./paperstart.sh
		;;

	NO)
		echo 'Paper jar will not be updated.'
		exec ./paperstart.sh
		;;

	PROMPT)
		echo "Do you want to update papermc now? (Minecraft $VERSION)"
		select yn in "YES" "NO" "EXIT"
		do
			case $yn in
				YES)
					echo Downloading the latest papermc jar for version "$VERSION".
					curl -z paperclip.jar "https://papermc.io/api/v1/paper/$VERSION/latest/download" -o /data/paperclip.jar
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

	*)
		#Informs the user that they incorrectly set the UPDATE variable.
		echo You need to set a proper update mode. UPDATE="$UPDATE"
		if [ "$VERSION" = '' ]; then
			echo You need to set a version in paperupdate.sh. VERSION="$VERSION"
		fi
		sleep 5
		;;
esac
exit
