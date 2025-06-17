#!/bin/bash

# wait 1 second to ensure the device is ready
sleep 1

# Get the device name passed from udev
DEVICE="/dev/$1"

# Mount point
MOUNT_POINT="/mnt/sdcard"

# Log file
LOG_FILE="/var/log/sdgrabber.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Make sure mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
    mkdir -p "$MOUNT_POINT"
fi

# Mount the device
sudo mount "$DEVICE" "$MOUNT_POINT"

if [ $? -eq 0 ]; then
    log_message "Successfully mounted SD card at $MOUNT_POINT"
else
    log_message "Failed to mount SD card from $DEVICE"
fi