#!/bin/bash

app_id=2278520
install_dir="/home/steam/enshrouded"

echo " --- Updating Enshrouded Server..."
steamcmd +force_install_dir $install_dir +login anonymous +app_update $app_id validate +quit
echo " --- Update Done"

su steam -c "xvfb-run --auto-servernum wine64 /home/steam/enshrouded/enshrouded_server.exe"
echo "Server started."
/bin/bash