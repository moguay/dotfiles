#!/usr/bin/env sh


# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh


# regen color conf

if [ "$EnableWallDcol" -eq 1 ] ; then

    kvantummanager --set Wall-Dcol
    cp ${ConfDir}/qt5ct/colors/Wall-Dcol.conf ${ConfDir}/qt6ct/colors/Wall-Dcol.conf
    sed -i "/^color_scheme_path=/c\color_scheme_path=${ConfDir}/qt5ct/colors/Wall-Dcol.conf" ${ConfDir}/qt5ct/qt5ct.conf
    sed -i "/^color_scheme_path=/c\color_scheme_path=${ConfDir}/qt6ct/colors/Wall-Dcol.conf" ${ConfDir}/qt6ct/qt6ct.conf

    a_ws=$(hyprctl -j activeworkspace | jq '.id')
    dpid=$(hyprctl -j clients | jq --arg wid "$a_ws" '.[] | select(.workspace.id == ($wid | tonumber)) | select(.class == "org.kde.dolphin") | .pid')

    if [ ! -z ${dpid} ] ; then
        hyprctl dispatch closewindow pid:${dpid}
        dolphin &
    fi

else

    kvantummanager --set $gtkTheme

fi

# reload dolphin

a_ws=$(hyprctl -j activeworkspace | jq '.id')
if [ "$(hyprctl -j clients | jq --arg wid "$a_ws" '.[] | select(.workspace.id == ($wid | tonumber)) | select(.class == "org.kde.dolphin") | .mapped')" == "true" ] ; then
    pkill -x dolphin
    dolphin &
fi

