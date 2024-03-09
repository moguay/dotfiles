#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
swaync="${ConfDir}/swaync/themes"

#Override kitty config
if [ "${EnableWallDcol}" -ne 1 ] ; then
    ln -fs ${swaync}/${gtkTheme}.conf ${swaync}/theme.conf
else
    ln -fs ${swaync}/Wall-Dcol.conf ${swaync}/theme.conf
fi