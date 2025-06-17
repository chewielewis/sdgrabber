#!/bin/bash

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

# Debug info
log_message "Device detected: $DEVICE"
log_message "Running mount script as user: $(whoami)"

# Make sure mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
    log_message "Created mount point: $MOUNT_POINT"
fi

# Get filesystem type
FS_TYPE=$(sudo blkid -s TYPE -o value "$DEVICE")
log_message "Filesystem type detected: $FS_TYPE"

# Mount the device with appropriate options based on filesystem
case $FS_TYPE in
    vfat|fat32)
        sudo mount -t vfat -o uid=pi,gid=pi,umask=000 "$DEVICE" "$MOUNT_POINT"
        ;;
    exfat)
        sudo mount -t exfat "$DEVICE" "$MOUNT_POINT"
        ;;
    ntfs)
        sudo mount -t ntfs "$DEVICE" "$MOUNT_POINT"
        ;;
    *)
        sudo mount "$DEVICE" "$MOUNT_POINT"
        ;;
esac

if [ $? -eq 0 ]; then
    log_message "Successfully mounted $DEVICE at $MOUNT_POINT"
else
    log_message "Failed to mount $DEVICE. Exit code: $?"
fi