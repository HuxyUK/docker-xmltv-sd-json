#!/bin/bash
NORMAL_GRAB=0
STARTUP_GRAB=1

#format="+%y/%m/%d_%H:%M:%S::"
#format="+%d-%m-%Y @ %T::"
echo() {
    printf "`date`: $1\n"
}

#ENVIRONMENT SETUP
function setEnv() {
  ## DAYS
  if [ "$1" -eq "$STARTUP_GRAB" ]; then
    if [ -z "$STARTUPDAYS" ]; then
      echo "Using default number of days (1) for scan. This can be overriden with a STARTUPDAYS variable."
      DAYS=1
	else
	  DAYS=$STARTUPDAYS
	fi
  else
    if [ -z "$DAYS" ]; then
      echo "Using default number of days (1) for scan. This can be overriden with a DAYS variable."
      DAYS=1
	fi
  fi

  ## FILENAME
  if [ -z "$FILENAME" ]; then
    echo "Using default filename (epg.xml) for scan. This can be overriden with a FILENAME variable."
    FILENAME="epg.xml"
  fi

  ## GRABBER
  if [ -z "$GRABBER" ]; then
    echo "Using default grabber (tv_grab_sd_json) for scan. This can be overriden with a GRABBER variable."
    GRABBER="tv_grab_sd_json"
  fi

  ## OFFSET
  if [ -z "$OFFSET" ]; then
    echo "Using default offset duration (0) for scan. This can be overriden with a OFFSET variable."
    OFFSET="0"
  fi

  TMPFILE="/tmp/${GRABBER}.xml"
} #END


#STARTING GRAB
function startGrab(){
  case "$(pidof ${GRABBER} | wc -w)" in

  0)  echo "****************"
      echo "* RUNNING GRAB *"
      echo "****************"
      if [ ! -f "/usr/local/bin/${GRABBER}" ]; then
        echo "Looking in /usr/bin for ${GRABBER}"
        if [ -f "/usr/bin/${GRABBER}" ]; then
          echo "/usr/bin/${GRABBER} --days ${DAYS} --output ${FILENAME} --offset ${OFFSET}"
          /usr/bin/${GRABBER} --days ${DAYS} --output ${TMPFILE} --offset ${OFFSET}
        else
          echo "${GRABBER} not found. Exiting."
          exit 1;
        fi
      else
        echo "/usr/local/bin/${GRABBER} --days ${DAYS} --output ${FILENAME} --offset ${OFFSET}"
        /usr/local/bin/${GRABBER} --days ${DAYS} --output ${TMPFILE} --offset ${OFFSET}
      fi
      ;;
  1)  echo "Grabber already running"
      ;;
  esac

  rc=$?;
  if [ $rc != 0 ]; then
    echo "... Failed!!!"
    exit $rc;
  fi
} #END

#FIX TO STOP DATA LOSS
function moveTmp(){
  echo "Moving tmp file to /data/${FILENAME}"
  mv -f ${TMPFILE} /data/${FILENAME}
} #END

#PRINTS SCRIPT END
function finish() {
  echo "... Success \n"
} #END

#RUNS THE SCRIPT
function run() {
  echo "*** Launching Grabber Script! ***"
  setEnv $1  # set environment
  startGrab  # start grabbing listings
  moveTmp    # rename temp file
  finish     # exit gracefully
} #END

#ENTRY POINT
if [ $# -eq 0 ]
  then
    echo "No grab type specified, assuming NORMAL"
    run 0
  else
    if [ "$1" -eq 0 ]
      then
        echo "Running grab type: NORMAL"
      else
        echo "Running grab type: STARTUP"
    fi
    run $1
fi
#END


