#!/bin/bash
# LGSM fix_csgo.sh function
# Author: Daniel Gibbs
# Website: http://gameservermanagers.com
lgsm_version="271215"

# Description: Resolves various issues with csgo.

# Fixed server not always creating steam_appid.txt file.
fn_csgoappfix(){
if [ ! -f "${filesdir}/steam_appid.txt" ]; then
	fn_printdots "Applying 730 steam_appid.txt Fix."
	sleep 1
	fn_printinfo "Applying 730 steam_appid.txt Fix."
	fn_scriptlog "Applying 730 steam_appid.txt Fix"
	sleep 1
	echo -en "\n"
	echo -n "730" >> "${filesdir}/steam_appid.txt"
fi
}

fn_csgofixes(){
# Fixes the following error:
# Error parsing BotProfile.db - unknown attribute 'Rank".
if ! grep -q "//Rank" "${systemdir}/botprofile.db" > /dev/null 2>&1; then
	echo "Applying botprofile.db fix."
	sleep 1
	echo ""
	echo "botprofile.db fix removes the following error from appearing on the console:"
	echo "	Error parsing BotProfile.db - unknown attribute 'Rank"
	sleep 1
	sed -i 's/\tRank/\t\/\/Rank/g' "${systemdir}/botprofile.db" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		fn_printfailure "Applying botprofile.db fix."
	else
		fn_printcomplete "Applying botprofile.db fix."
	fi
	echo -en "\n"
	echo ""
fi

# Fixes errors simular to the following:
# Unknown command "cl_bobamt_vert".
if ! grep -q "//exec default" "${servercfgdir}/valve.rc" > /dev/null 2>&1 || ! grep -q "//exec joystick" "${servercfgdir}/valve.rc" > /dev/null 2>&1; then
	echo "Applying valve.rc fix."
	sleep 1
	echo ""	
	echo "valve.rc fix removes the following error from appearing on the console:"
	echo "	Unknown command \"cl_bobamt_vert\""
	sleep 1
	sed -i 's/exec default.cfg/\/\/exec default.cfg/g' "${servercfgdir}/valve.rc" > /dev/null 2>&1
	sed -i 's/exec joystick.cfg/\/\/exec joystick.cfg/g' "${servercfgdir}/valve.rc" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		fn_printfailure "Applying valve.rc fix."
	else
		fn_printcomplete "Applying valve.rc fix."
	fi
	echo -en "\n"
	echo ""
fi

# Fixes errors simular to the following:
# http://forums.steampowered.com/forums/showthread.php?t=3170366.
if [ -f "${systemdir}/subscribed_collection_ids.txt" ]||[ -f "${systemdir}/subscribed_file_ids.txt" ]||[ -f "${systemdir}/ugc_collection_cache.txt" ]; then
	echo "workshopmapfix fixes the following error:"
	echo "	http://forums.steampowered.com/forums/showthread.php?t=3170366"
	sleep 1
	echo ""
	echo "Applying workshopmap fix."
	sleep 1
	rm -f "${systemdir}/subscribed_collection_ids.txt"
	rm -f "${systemdir}/subscribed_file_ids.txt"
	rm -f "${systemdir}/ugc_collection_cache.txt"
	if [ $? -ne 0 ]; then
		fn_printfailure "Applying workshopmap fix."
	else
		fn_printcomplete "Applying workshopmap fix."
	fi
	echo -en "\n"
	echo ""
fi
}

if [ ! -z "${startfix}" ]; then
	fn_csgoappfix
else
	fn_csgofixes
fi