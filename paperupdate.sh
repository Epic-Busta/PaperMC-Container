#!/bin/bash
#Paper auto-update behavior: Sets whether to be to always auto-update , never auto-update, or to prompt to update or not to update on each launch
#valid entries: YES / NO / PROMPT
#You can manually update paper by setting UPDATE to NO and adding the jar yourself.
UPDATE=""

#Sets the version of PaperMC (Minecraft version) to download when updating. If its for a very new version, check PaperMC.io if a jar is availiable.
VERSION=""

#DON'T TOUCH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING!

echo UPDATE is set to "$UPDATE"
echo VERSION is set to "$VERSION"
if [ "$VERSION" = '' ] && [ "$UPDATE" = '' ] ; then
	echo 'This is probably the first time running this image. (UPDATE and VERSION are empty)'
	echo 'Open paperupdate.sh and set the auto-update behaviour (UPDATE) and the Minecraft version to download (VERSION)'
	echo 'Also open paperstart.sh and set dedicated RAM (HEAP_SIZE) which is default set to 2048M'
	echo 'These files should be located in the directory mounted as a volume (/data inside the container)'
	echo 'Waiting 40 seconds before terminating the container...'
	sleep 40
	exit
fi
case "$UPDATE" in
	YES)
		echo Downloading the latest Paper jar for version "$VERSION".
		curl -o "paperclip.jar" -z "paperclip.jar" "https://papermc.io/api/v1/paper/$VERSION/latest/download"
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
					curl -o "paperclip.jar" -z "paperclip.jar" "https://papermc.io/api/v1/paper/$VERSION/latest/download"
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
		echo You need to set a proper update mode in paperupdate.sh. UPDATE="$UPDATE"
		if [ "$VERSION" = '' ]; then
			echo You need to set a version in paperupdate.sh. VERSION="$VERSION"
		fi
		sleep 5
		;;
esac
exit
