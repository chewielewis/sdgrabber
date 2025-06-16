#!/bin/bash

echo "Installing SDGrabber..."

# Install required system packages
sudo apt-get update
sudo apt-get install -y python3-rpi.gpio

# Create log file and set permissions
sudo touch /var/log/sdgrabber.log
sudo chown $USER:$USER /var/log/sdgrabber.log

# Copy service file to systemd
sudo cp sdgrabber.service /etc/systemd/system/

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable sdgrabber.service
sudo systemctl start sdgrabber.service

echo "Installation complete! Check status with: sudo systemctl status sdgrabber"
