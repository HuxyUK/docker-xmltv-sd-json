#!/bin/bash

# create .xmltv dir if it doesn't already exist
echo "Checking for XMLTV directory"
if [ ! -d /root/.xmltv ]; then
  echo "Creating XMLTV dir..."
  ln -s /config /root/.xmltv
fi
echo "Done"

# create data dir if it doesn't already exist
echo "Checking for data directory"
if [ ! -d /data ]; then
  echo "Creating data dir..."
  mkdir /data
fi
echo "Done"

