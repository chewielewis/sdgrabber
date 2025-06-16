#!/bin/bash

echo "Installing SDGrabber..."

# Install required system packages
sudo apt-get update
sudo apt-get install -y python3-rpi.gpio cifs-utils

# Create samba credentials directory and file
sudo mkdir -p /etc/samba
sudo touch /etc/samba/credentials
sudo chmod 600 /etc/samba/credentials

# Create mount point for SMB share
sudo mkdir -p /mnt/backup_server

# Create log file and set permissions
sudo touch /var/log/sdgrabber.log
sudo chown $USER:$USER /var/log/sdgrabber.log

# Copy service file to systemd
sudo cp sdgrabber.service /etc/systemd/system/

# Copy mount service file
sudo cp smb-mount.service /etc/systemd/system/

# Reload systemd and enable services
sudo systemctl daemon-reload
sudo systemctl enable smb-mount.service
sudo systemctl enable sdgrabber.service
sudo systemctl start smb-mount.service
sudo systemctl start sdgrabber.service

echo "Installation complete! Check status with: sudo systemctl status sdgrabber"
