#!/bin/bash

# Exit on any error
set -e

echo "Installing required system packages..."
# Update package list and install git
sudo apt-get update
sudo apt-get install -y git python3-pip python3-rpi.gpio

echo "Installing SDGrabber service..."

# Create log file and set permissions
sudo touch /var/log/sdgrabber.log
sudo chown $USER:$USER /var/log/sdgrabber.log

# Install Python dependencies
pip3 install -r requirements.txt

# Copy service file to systemd directory
sudo cp sdgrabber.service /etc/systemd/system/

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable sdgrabber.service
sudo systemctl start sdgrabber.service

echo "Installation complete! The service is now running."
echo "You can check its status with: sudo systemctl status sdgrabber"
