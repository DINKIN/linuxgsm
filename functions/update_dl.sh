#!/bin/bash
# LGSM update_dl.sh function
# Author: Daniel Gibbs
# Website: http://gameservermanagers.com
lgsm_version="271215"

# Description: Runs a server update.

local modulename="Update"

fn_steamcmd_dl(){
check.sh
info_config.sh
fn_printdots "Updating ${servername}"
sleep 1
fn_printoknl "Updating ${servername}"
fn_scriptlog "Updating ${servername}"
sleep 1
cd "${rootdir}"
cd "steamcmd"

# Detects if unbuffer command is available.
if [ $(command -v unbuffer) ]; then
	unbuffer=unbuffer
fi

if [ "${engine}" == "goldsource" ]; then
	${unbuffer} ./steamcmd.sh +login "${steamuser}" "${steampass}" +force_install_dir "${filesdir}" +app_set_config 90 mod ${appidmod} +app_update "${appid}" +quit|tee -a "${scriptlog}"
else
	${unbuffer} ./steamcmd.sh +login "${steamuser}" "${steampass}" +force_install_dir "${filesdir}" +app_update "${appid}" +quit|tee -a "${scriptlog}"
fi


if [ "${gamename}" == "Counter Strike: Global Offensive" ]; then
	echo -e '\n'
	fix_csgo.sh
fi
}

fn_teamspeak3_dl(){
check.sh
info_config.sh
fn_printdots "Updating ${servername}"
sleep 1
fn_printoknl "Updating ${servername}"
fn_scriptlog "Updating ${servername}"
sleep 1
cd "${rootdir}"
echo -e "downloading teamspeak3-server_linux-${ts3arch}-${availablebuild}.tar.gz...\c"
fn_scriptlog "Downloading teamspeak3-server_linux-${ts3arch}-${availablebuild}.tar.gz"
wget -N /dev/null http://dl.4players.de/ts/releases/${ts3_version_number}/teamspeak3-server_linux-${ts3arch}-${ts3_version_number}.tar.gz 2>&1 | grep -F HTTP | cut -c45-| uniq
sleep 1
echo -e "extracting teamspeak3-server_linux-${ts3arch}-${availablebuild}.tar.gz...\c"
fn_scriptlog "Extracting teamspeak3-server_linux-${ts3arch}-${availablebuild}.tar.gz"
tar -xf "teamspeak3-server_linux-${ts3arch}-${availablebuild}.tar.gz" 2> "${scriptlogdir}/.${servicename}-tar-error.tmp"
local status=$?
if [ ${status} -eq 0 ]; then
	echo "OK"
else
	echo "FAIL - Exit status ${status}"
	fn_scriptlog "Failed to extract - Exit status ${status}"
	sleep 1
	cat "${scriptlogdir}/.${servicename}-tar-error.tmp"
	cat "${scriptlogdir}/.${servicename}-tar-error.tmp" >> "${scriptlog}"
	rm "${scriptlogdir}/.${servicename}-tar-error.tmp"
	fn_scriptlog "Failure! Unable to update"
	exit ${status}
fi
echo -e "copying to ${filesdir}...\c"
fn_scriptlog "Copying to ${filesdir}"
cp -R "${rootdir}/teamspeak3-server_linux-${ts3arch}/"* "${filesdir}" 2> "${scriptlogdir}/.${servicename}-cp-error.tmp"
local status=$?
if [ ${status} -eq 0 ]; then
	echo "OK"
else
	echo "FAIL - Exit status ${status}"
	fn_scriptlog "Failed to copy - Exit status ${status}"
	sleep 1
	cat "${scriptlogdir}/.${servicename}-cp-error.tmp"
	cat "${scriptlogdir}/.${servicename}-cp-error.tmp" >> "${scriptlog}"
	rm "${scriptlogdir}/.${servicename}-cp-error.tmp"
	fn_scriptlog "Failure! Unable to update"
	exit ${status}
fi
rm -f teamspeak3-server_linux-${ts3arch}-${availablebuild}.tar.gz
rm -rf "${rootdir}/teamspeak3-server_linux-${ts3arch}"
}

if [ "${gamename}" == "Teamspeak 3" ]; then
	fn_teamspeak3_dl
else
	fn_steamcmd_dl
fi