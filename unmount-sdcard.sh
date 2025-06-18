#!/bin/bash

# Set full paths
UMOUNT="/bin/umount"

# Mount point
MOUNT_POINT="/mnt/sdcard"

# Log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/sdgrabber.log
}

log_message "Starting unmount script"

# Check if mounted and unmount
if mountpoint -q "$MOUNT_POINT"; then
    log_message "Unmounting device from $MOUNT_POINT"
    $UMOUNT "$MOUNT_POINT"
    if [ $? -eq 0 ]; then
        log_message "Successfully unmounted device"
    else
        log_message "Failed to unmount device"
    fi
else
    log_message "No device mounted at $MOUNT_POINT"
fi