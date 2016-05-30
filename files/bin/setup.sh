#!/bin/sh

# Permissions
echo "1. Setting unRAID permissions for home directory..."
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home
echo ".. Done"

# SSH Settings
echo "2. Disabling SSH..."
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
echo ".. Done"

# Install XMLTV
echo "3. Installing XMLTV..."
apt-get update && apt-get install --no-install-recommends -y xmltv wget
echo ".. Done"

# Installing TV Grabber Script
echo "4. Installing JSON script..."
wget https://raw.githubusercontent.com/kgroeneveld/tv_grab_sd_json/master/tv_grab_sd_json -O /usr/local/bin/tv_grab_sd_json
rc=$?;
if [ $rc != 0 ]; then
  echo "Grabber failed to download. Aborting build..."
exit $rc;
fi
chmod +x /usr/local/bin/tv_grab_sd_json
echo ".. Done"

# Creating XMLTV symbolic link
echo "5. Creating XMLTV symbolic link"
ln -s /config /root/.xmlt
echo ".. Done"

# Clean up
echo "6. Clean up of files"
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
echo ".. Done"
