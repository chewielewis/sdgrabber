#!/bin/bash

echo "Installing SDGrabber..."

# Install required system packages
sudo apt-get update
sudo apt-get install -y python3-rpi.gpio cifs-utils

# Create samba credentials directory and file
sudo mkdir -p /etc/samba
sudo touch /etc/samba/credentials
sudo chmod 600 /etc/samba/credentials

# Create mount points
sudo mkdir -p /mnt/sdcard
sudo mkdir -p /mnt/backup_server

# Setup SD card mounting
sudo cp mount-sdcard.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/mount-sdcard.sh
sudo cp 99-sdgrabber.rules /etc/udev/rules.d/

# Create log file and set permissions
sudo touch /var/log/sdgrabber.log
sudo chown $USER:$USER /var/log/sdgrabber.log

# Copy service files to systemd
sudo cp sdgrabber.service /etc/systemd/system/
sudo cp smb-mount.service /etc/systemd/system/

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Reload systemd and enable services
sudo systemctl daemon-reload
sudo systemctl enable smb-mount.service
sudo systemctl enable sdgrabber.service
sudo systemctl start smb-mount.service
sudo systemctl start sdgrabber.service

echo "Installation complete! Check status with: sudo systemctl status sdgrabber"
