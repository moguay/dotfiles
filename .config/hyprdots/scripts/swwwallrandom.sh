#!/usr/bin/env sh

# set variables
export ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themeselect.rasi"

ctlLine=$(grep '^1|' "$ThemeCtl")
if [ $(echo $ctlLine | wc -l) -ne "1" ]; then
	echo "ERROR : $ThemeCtl Unable to fetch theme..."
	exit 1
fi

fullPath=$(echo "$ctlLine" | awk -F '|' '{print $NF}' | sed "s+~+$HOME+")
wallPath=$(dirname "$fullPath")
if [ ! -d "${wallPath}" ] && [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/swww/${gtkTheme}" ] && [ ! -z "${gtkTheme}" ]; then
	wallPath="${XDG_CONFIG_HOME:-$HOME/.config}/swww/${gtkTheme}"
fi

# Create cache dir if not exists
if [ ! -d "${cacheDir}/${gtkTheme}" ]; then
	mkdir -p "${cacheDir}/${gtkTheme}"
fi

# Convert images in directory and save to cache dir
for images in "$wallPath"/*.{gif,jpg,jpeg,png,webp}; do
	if [ -f "$images" ]; then
		rfile=$(basename "$images")
		if [ ! -f "${cacheDir}/${gtkTheme}/${rfile}" ]; then
			echo "Converting $images to ${cacheDir}/${gtkTheme}/${rfile}"
			convert -strip "$images" -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${gtkTheme}/${rfile}"
		fi
	fi
done

RANDOM_IMAGE=$(fd --base-directory "$wallPath" --type f . | shuf -n 1)

# apply wallpaper
if [ ! -z "${RANDOM_IMAGE}" ]; then
	"${ScrDir}/swwwallpaper.sh" -s "${wallPath}/${RANDOM_IMAGE}"
	pgrep -x dunst >/dev/null && dunstify "t1" -a " ${RANDOM_IMAGE}" -i "${cacheDir}/${gtkTheme}/${RANDOM_IMAGE}" -r 91190 -t 2200
	command -v notify-send >/dev/null && notify-send "Wallpaper Changed" -i "${cacheDir}/${gtkTheme}/${RANDOM_IMAGE}"
fi