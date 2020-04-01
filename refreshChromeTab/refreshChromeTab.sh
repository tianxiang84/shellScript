#!/bin/bash

## Define functions
exitHandle(){
  echo "Got exit signal."
  exitFlag=1
}


checkTimeSlotAvailable(){
  # Get the window id of the currently focus window so we can re-activate at the end
  CUR_WID=$(xdotool getwindowfocus)

  # Search for the browser
  WID=$(xdotool search --onlyvisible --class chrome|head -1)

  # Activate the browser
  xdotool windowactivate $WID
  sleep 1
  xdotool windowsize $WID 400 250
  sleep 1
  xdotool windowmove $WID 20 500
  sleep 1

  # Use key
  #xdotool key 'ctrl+r'
  echo "Activate the tab"
  xdotool key 'ctrl+8'
  sleep 0.1

  echo "Refresh the tab"
  xdotool key 'ctrl+r'
  sleep 5

  echo "Save file"
  rm ~/Desktop/*.html || true
  xdotool key 'ctrl+s'
  sleep 0.5
  echo "Confirm"
  xdotool key Return
  sleep 2

  echo "Minimizing the window"
  xdotool windowminimize $WID
  sleep 0.01

  rm ./*.html || true
  mv ~/Desktop/*.html ./saveHTML.html
  rm -r ~/Desktop/Target*
  if grep -q "Choose from the delivery windows below" "./saveHTML.html";
   then
     echo "yes there is delivery window" # SomeString was found
     paplay eventually.ogg

     # Play a Youtube video
     xdotool windowactivate $WID
     sleep 2
     echo "Activate the tab 2"
     xdotool key 'ctrl+2'
     sleep 2
     xdotool key 'ctrl+r'
     sleep 2
  fi
  if grep -q "No delivery windows available" "./saveHTML.html";
    then
      echo "no delivery"
      #paplay fail.mp3
  fi

  # Activate the original window
  echo "Back to original window"
  xdotool windowactivate $CUR_WID
}

# Catch exit signal to run the clean up (saving) tasks
exitFlag=1
trap exitHandle exit SIGTERM SIGKILL
while [ ${exitFlag} ]; do
  checkTimeSlotAvailable
  break
  #sleep 60
done
exit 0
