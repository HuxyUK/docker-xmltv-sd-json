#!/bin/bash
# Installing TV Grabber Script
echo "Downloading newest JSON script."
wget https://raw.githubusercontent.com/kgroeneveld/tv_grab_sd_json/master/tv_grab_sd_json -O /tmp/tv_grab_sd_json
rc=$?;
if [ $rc != 0 ]; then
  echo "Grabber failed to download. Aborting download..."
exit $rc;
fi
mv /tmp/tv_grab_sd_json /usr/local/bin/tv_grab_sd_json
chmod +x /usr/local/bin/tv_grab_sd_json
echo ".. Done"

## update environment for cron
env > /etc/environment

## run startup grab
source /usr/local/bin/grabber 1

## importing custom cron tab if file exists
CRONTAB="/config/cronjobs.txt"
echo "Checking for crontab"
if [ -s $CRONTAB ]; then
  echo "Located custom crontab..."
  echo "      Installing crontab..."
  echo $CRONTAB

  crontab ${CRONTAB}

  rc=$?;
  if [ $rc != 0 ]; then
    echo "Failed!!! Check your crontab configuration."
    exit $rc;
  fi
else
  echo "Creating default crontab..."
cat <<'EOF' > ${CRONTAB}
30 */12 * * * /usr/local/bin/grabber >> /var/log/cron.log 2>&1
# LEAVE THIS LINE BLANK
EOF
  chown -R nobody:users ${CRONTAB}
  chmod +rw ${CRONTAB}
  crontab ${CRONTAB}
  echo "Done"
fi

## all done
echo "********************"
echo "* STARTUP COMPLETE *"
echo "********************"
