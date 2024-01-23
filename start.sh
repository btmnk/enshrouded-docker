#!/bin/bash

session="enshrouded"
runfile="/srv/enshrouded/server/run.sh"

echo "Starting $session via screen ..."

if ! screen -list | fgrep -q ".$session"; then
  cd server
  screen -dmS $session $runfile -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS
  echo -e "\E[0;32mServer started."
        tput sgr0

  if ! screen -list | fgrep -q ".$session"; then
    echo -e "\E[0;31mServer couldn't be started.."
    tput sgr0
  fi
else
  echo -e "\E[0;31mServer is already running."
  tput sgr0
fi
