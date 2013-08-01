#!/bin/zsh -f
# Purpose: Save screenshots every minute to remind me what I was doing earlier, and also show me how I spent my day
#
# From:	Tj Luoma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2013-07-10
NAME="$0:t:r"

	##############################################################################################
	# If you are NOT using Keyboard Maestro and ARE using `beengone` (see
	# below), how many MINUTES before the user is considered IDLE ? Default
	# is 5 minutes:
	#
	# 	BEENGONE='5'
BEENGONE='5'

	# How many days screenshots do you want to keep? This is intended to
	# keep your folder from getting filled up with screenshots that you
	# will probably never look at again. Note that folders older than this
	# number of days will be moved to your ~/.Trash/ not deleted, because
	# recursively deleting folders in an automated script scares me. Not
	# unduly. Just the right amount. Call it a healthy respect.
DAYS_TO_KEEP='7'

DIR="$HOME/Pictures/$NAME/"



####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#		You should not HAVE to change anything below this line but you are
#		encouraged to read the rest of the comments to understand how it
#		works. Or how I think it is supposed to work :-)
#



zmodload zsh/datetime 	# needed for strftime



		## 	FILEPATH becomes something like:
		##  "~/Pictures/screenshot-journal/2013-06-23/20.58.52."
		## 	which gives us a foundation to build on for filenames.
		##
		## 	Each day's pictures are stored in a folder YYYY-MM-DD and the
		## 	individual files are timestamps HH:MM:SS using 24-hour time because
		## 	it sorts cleaner in the Finder


	# Note that this adds a sub-folder based on date (i.e. 2012-12-25) and then a filename based on H:M:S (where H=0-23)
FILEPATH=$(strftime "$DIR/%Y-%m-%d/%H.%M.%S" "$EPOCHSECONDS")

	# If the necessary folder is not available, it will be created automatically. MAGIC. Ok, not magic.
if [[ ! -d "$FILEPATH:h" ]]
then
		mkdir -p "$FILEPATH:h" || echo "$NAME: Failed to create"

		# now, if we're making a new directory, it (most likely) means that
		# this is a new day, so this is a good time to do some housekeeping

			# look for a 'today' link, and remove it if it exists (only if it matches name 'Today' and is a link)
		find -H "$DIR" -type l -iname Today -maxdepth 1 -mindepth 0 -print -delete

			# make a new link for 'today' which links to (wait for it) today's folder
		ln -s "$FILEPATH:h" "$DIR/Today"

		# look for old folders, and move them to the Trash if they exceed DAYS_TO_KEEP

		OLD_FOLDERS=$(find "${DIR}" -ctime +${DAYS_TO_KEEP}d -type d -maxdepth 1 -mindepth 1 -exec mv -vf {} "$HOME/.Trash/" \; | wc -l | tr -dc '[0-9]')

		if [ "$OLD_FOLDERS" != "0" ]
		then
				if [ "$OLD_FOLDERS" = "1" ]
				then
						echo "$NAME: Moved one folder from $DIR to Trash"
				else
						echo "$NAME: moved $OLD_FOLDERS folders from $DIR to Trash"
				fi
		fi
fi

	# initialize variable… we don't know what our STATUS is unless we're told or we calculate it using `beengone`
STATUS="Unknown"

case "$1" in
	--sleep)
						# for use with SleepWatcher http://www.bernhard-baehr.de/
					touch "$FILEPATH.sleep.txt"
					exit 0
	;;

	--wake)
						# for use with SleepWatcher http://www.bernhard-baehr.de/
					touch "$FILEPATH.wake.txt"
					exit 0
	;;

	--idle)
						# Keyboard Maestro will use that flag for when the screensaver is on OR when the display is turned off.
						# Might not need a screenshot then.
					shift
					STATUS='idle'
	;;

	--timed)
						# Keyboard Maestro will use that flag for when the screensaver is OFF AND when the display is turned ON
						# Might not need a screenshot then.
					STATUS='active'
					REASON='timed'
					shift
	;;

	--switch)
						# Keyboard Maestro will use that flag for whenever a new app has become active
					STATUS='active'
					REASON='switch'
					shift
	;;
esac

if [ "$#" -gt "0" ]
then

	WHICH_APP="$1"

	shift
fi


WHICH_WINDOW="$@"

####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#		Are we being called from launchd?
#
#		If we are being called from launchd (instead of Keyboard Maestro) then we will use `beengone` to tell us if we are idle or not
#		Note that we don't use this section if the script has been called with --active or --idle

if [[ "$STATUS" == "Unknown" ]]
then

	PARENT=$(/bin/ps -p $PPID)

	case "$PARENT" in
		*/sbin/launchd)
								# IF we are in launchd (and, therefore, not being called via Keyboard Maestro),
								# then we will use the `beengone` command, if available, to check our status against the
								# user defined $BEENGONE
							if (( $+commands[beengone] ))
							then
									# if the beengone command exists AND we have met the criteria for it, set STATUS='idle'
									beengone $BEENGONE >/dev/null && STATUS='idle'
							fi
			;;

		*)
						# this is something else (not launchd)
						# Not sure what this might be useful for in the
						# future, but might as well leave it here in case
						# something comes to mind.
						:
		;;
	esac
fi # If status is NOT idle
###############################################


		# Only take a screenshot when NOT idle (either Active or Unknown)
if [ "$STATUS" != "idle" ]
then

		# gif screenshots will take the least about of diskspace and they're fine for our purposes
	SCREENCAPTURE_FORMAT='gif'

		# -x = no sound, -t = format (gif, jpg, etc), -C = include cursor
	/usr/sbin/screencapture -x -t "$SCREENCAPTURE_FORMAT" -C "${FILEPATH}	 [${WHICH_APP}]	 {$WHICH_WINDOW}	 ${REASON}.${SCREENCAPTURE_FORMAT}"
fi


###############################################
## BEGIN IMAGESNAP
if (( $+commands[imagesnap] ))
then
			# We don't need high res, we just want a reminder
		IMAGESNAP_FORMAT='gif'

		[[ "$STATUS" == "idle" ]] && imagesnap -q "${FILEPATH}.isight.${STATUS}.${IMAGESNAP_FORMAT}"

			# if 'imagesnap' is found in your $PATH then an iSight picture
			# will be taken whenever the computer is considered 'idle'
			#
			# The intent here is that I might be able to see if I was on
			# the phone, talking with someone, reading mail, etc. If the
			# computer is not idle there's no reason to take a picture of
			# me staring at the screen.
			#
			# If you don't have `imagesnap` installed, this section will be
			# skipped.
			#
			# If you have `imagesnap` installed and don't want this
			# functionality, just remove this section This will cause the
			# iSight light to come on momentarily.
			#
			# You can find imagesnap at
			# http://iharder.sourceforge.net/current/macosx/imagesnap/
			# or `brew install imagesnap`
fi
## END IMAGESNAP
###############################################

###############################################
## BEGIN SETFILE
if (( $+commands[SetFile] ))
then

		# For some reason the screencapture command doesn't like to show
		# file extensions. This will force them to be visible. If you don't
		# care about that, feel free to delete this section.
		#
		# SetFile is only installed if you have the developer tools installed, IIRC.

	SetFile -a e "$FILEPATH:h"/*

fi
## END SETFILE
###############################################


exit
#
#EOF

