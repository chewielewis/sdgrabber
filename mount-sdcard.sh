#!/bin/bash

# Set PATH explicitly for udev environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Get the device name passed from udev
DEVICE="/dev/$1"

# Mount point
MOUNT_POINT="/mnt/sdcard"

# Log file
LOG_FILE="/var/log/sdgrabber.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Debug info
log_message "Starting mount script for device: $DEVICE"
log_message "Current user: $(whoami)"
log_message "Mount point permissions: $(ls -ld $MOUNT_POINT)"

# Check if device exists
if [ ! -b "$DEVICE" ]; then
    log_message "Error: Device $DEVICE does not exist"
    exit 1
fi

# Get filesystem type
FS_TYPE=$(/usr/sbin/blkid -s TYPE -o value "$DEVICE")
log_message "Filesystem type detected: $FS_TYPE"

# Try mounting with different options
if /bin/mount -o rw,users,umask=000 "$DEVICE" "$MOUNT_POINT"; then
    log_message "Successfully mounted $DEVICE at $MOUNT_POINT"
    /bin/chmod 777 "$MOUNT_POINT"
    log_message "Updated mount point permissions: $(ls -ld $MOUNT_POINT)"
else
    log_message "Failed to mount. Trying alternative mount options..."
    if /bin/mount "$DEVICE" "$MOUNT_POINT"; then
        log_message "Basic mount successful"
    else
        MOUNT_ERROR=$(/bin/mount "$DEVICE" "$MOUNT_POINT" 2>&1)
        log_message "Mount failed with error: $MOUNT_ERROR"
        log_message "Device info: $(/usr/sbin/blkid "$DEVICE")"
        exit 1
    fi
fi