#!/bin/bash

echo " --- Updating Enshrouded Server..."
./steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/enshrouded +login anonymous +app_update 2278520 +quit
echo " --- Update Done"

xvfb-run --auto-servernum wine64 /home/steam/enshrouded/enshrouded_server.exe
echo " --- Server started."
/bin/bash