app_id=2394010
install_dir="/srv/enshrouded/server"

echo "Updating Enshrouded Server..."
steamcmd +force_install_dir $install_dir +login anonymous +app_update $app_id validate +quit
echo "DONE"
