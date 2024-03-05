#!/usr/bin/env sh

# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
dstDir="${XDG_CONFIG_HOME:-$HOME/.config}/dunst"

# Skip if dunst not installed
pgrep -x dunst >/dev/null || exit

# regen conf

cat "$dstDir/dunst.conf" "$dstDir/Wall-Dcol.conf" > "$dstDir/dunstrc"
killall dunst
dunst &

