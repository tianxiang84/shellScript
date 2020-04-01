#!/bin/bash

###
# This is a script to activate the nomachine client window every now and then.
# Usage: ./activateWindow -s 60 -n "nomachine"
###

## Define functions
exitHandle(){
  # Define how we exit the script
  echo -e "\nGot exit signal. Exit script now."
  exitFlag=1
  #echo "In exit func: $exitFlag"
}


activateWindow(){
  # Define how to activate a window

  # Get the window id of the currently focus window so we can re-activate it at the end
  CUR_WID=$(xdotool getwindowfocus)

  # Search for the browser
  WID=$(xdotool search --onlyvisible --name $searchName | tail -1)

  # Activate the window
  xdotool windowactivate $WID
  #sleep 0.01

  # Press a key
  #xdotool key Escape
  #sleep 0.1

  # Move the mouse (polar coordinate clockwise, first number is angle in degree (0=up, 90=left), second number is distance)
  xdotool mousemove --window $WID --polar 0 200
  #sleep 2
  xdotool mousemove --window $WID --polar 90 200
  #sleep 2
  #xdotool mousemove --window $WID --polar 180 200
  #sleep 2
  #xdotool mousemove --window $WID --polar 270 200
  #sleep 2

  # Minimize the window
  xdotool windowminimize $WID

  # Activate the original window
  xdotool windowactivate $CUR_WID
}



usage(){
  echo "Example usage: ./activateWindow.sh -s 300 -n nomachine"
}



## Main
# Catch exit signal to run the clean up (saving) tasks
exitFlag=0
trap exitHandle exit SIGTERM
#trap "exit" INT

sleepTime=300 #         Default to activate the window every 300 seconds (5 mins)
searchName="nomachine" # Default name to search for the window to activate
while [ "$1" != "" ]; do
  #echo -e ' '$1''
  case $1 in
    -s | --sleep )          shift # shift to next argument input
                            sleepTime=$1
                            ;;
    -n | --name )           shift
                            searchName=$1
                            ;;
    -h | --help )           usage
                            exit
                            ;;
    * )                     echo -e "\n[ERROR] Arguments to the script not recognized.\n"
                            usage
                            exit 1
  esac   # end of case
  shift  # shift to next argument input
done


while [ ${exitFlag} -eq 0 ]; do
  #echo "In while loop: $exitFlag"

  activateWindow

  if [ $sleepTime -lt 10 ]; then
    sleepTime=10 # If sleep time is too short, it may make the system too busy and you cannot control your keyboard and mouse anymore.
  fi

  sleep $sleepTime
done

exit 0
