#!/bin/bash

echo " --- Updating Enshrouded Server..."
/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "$ENSHROUDED_PATH" +login anonymous +app_update 2278520 validate +quit

# Check that steamcmd was successful
if [ $? != 0 ]; then
    echo " --- ERROR: steamcmd was unable to successfully initialize and update Enshrouded..."
    exit 1
elif 
    echo " --- Update Done"
fi

# Check for proper save permissions
if [[ $(stat -c "%U %G" "${ENSHROUDED_PATH}/savegame") != "steam steam" ]]; then
    echo ""
    echo " ---- ERROR: The ownership of /home/steam/enshrouded/savegame is not correct and the server will not be able to save..."
    echo "             the directory that you are mounting into the container needs to be owned by 10000:10000"
    echo "             from your container host attempt the following command 'chown -R 10000:10000 /your/enshrouded/folder'"
    echo ""
    exit 1
fi

# Wine talks too much and it's annoying
export WINEDEBUG=-all

echo " --- Starting Server"
wine ${ENSHROUDED_PATH}/enshrouded_server.exe