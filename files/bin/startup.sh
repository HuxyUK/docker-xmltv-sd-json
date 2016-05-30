#!/bin/bash
CRONTAB="/config/cronjobs.txt"
source /usr/local/bin/grabber 1

## importing custom cron tab if file exists
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

## update environment for cron jobs
env >> /etc/environment

## all done
echo "********************"
echo "* STARTUP COMPLETE *"
echo "********************"
