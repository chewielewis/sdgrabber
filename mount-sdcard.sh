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
log_message "Environment: $(env)"

# Sleep briefly to ensure device is ready
sleep 2

# Make sure mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
    /usr/bin/mkdir -p "$MOUNT_POINT"
    log_message "Created mount point: $MOUNT_POINT"
fi

# Get filesystem type
FS_TYPE=$(/usr/sbin/blkid -s TYPE -o value "$DEVICE")
log_message "Filesystem type detected: $FS_TYPE"

# Mount the device with appropriate options based on filesystem
case $FS_TYPE in
    vfat|fat32)
        /usr/bin/mount -t vfat -o uid=1000,gid=1000,umask=000 "$DEVICE" "$MOUNT_POINT"
        ;;
    exfat)
        /usr/bin/mount -t exfat "$DEVICE" "$MOUNT_POINT"
        ;;
    ntfs)
        /usr/bin/mount -t ntfs "$DEVICE" "$MOUNT_POINT"
        ;;
    *)
        /usr/bin/mount "$DEVICE" "$MOUNT_POINT"
        ;;
esac

MOUNT_STATUS=$?
if [ $MOUNT_STATUS -eq 0 ]; then
    log_message "Successfully mounted $DEVICE at $MOUNT_POINT"
else
    log_message "Failed to mount $DEVICE. Exit code: $MOUNT_STATUS"
fi