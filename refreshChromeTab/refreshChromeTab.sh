#!/bin/bash

## Define functions
exitHandle(){
  echo "Got exit signal."
  exitFlag=1
}


checkTimeSlotAvailable(){
  chomeID=1

  # Get the window id of the currently focus window so we can re-activate at the end
  CUR_WID=$(xdotool getwindowfocus)


  # Search for the browser
  WID=$(xdotool search --onlyvisible --class chrome|head -${chomeID})
  echo $WID

  # Activate the browser
  xdotool windowactivate $WID
  #xdotool windowsize --usehints $WID 100 100
  #xdotool getactivewindow windowmove 100 100

  # Use key
  #xdotool key 'ctrl+r'
  echo "Activate the tab"
  xdotool key 'ctrl+8'
  sleep 0.2

  echo "Refresh the tab"
  xdotool key 'ctrl+r'
  sleep 5

  #echo "View source code"
  #xdotool key 'ctrl+u'
  #sleep 0.2

  echo "Save file"
  rm ~/Desktop/*.html || true
  xdotool key 'ctrl+s'
  sleep 0.5
  echo "Confirm"
  xdotool key Return
  sleep 0.5
  #xdotool key Return
  #sleep 2
  #xdotool key 'ctrl+w'
  #sleep 0.1

  xdotool key 'alt+space'
  sleep 0.2
  xdotool key Return
  sleep 0.1

  rm ./*.html || true
  mv ~/Desktop/*.html ./saveHTML.html
  rm -r ~/Desktop/Target*
  if grep -q "Choose from the delivery windows below" "./saveHTML.html";
   then
     echo "yes there is delivery window" # SomeString was found
     paplay eventually.ogg
   else
     if grep -q "No delivery windows available" "./saveHTML.html";
     then
       echo "no delivery"
       #paplay fail.mp3
     fi
  fi

  # Activate the original window
  xdotool windowactivate $CUR_WID
}

# Catch exit signal to run the clean up (saving) tasks
exitFlag=1
trap exitHandle exit SIGTERM SIGKILL
while [ ${exitFlag} ]; do
  checkTimeSlotAvailable
  sleep 60
  #exit 0
done
