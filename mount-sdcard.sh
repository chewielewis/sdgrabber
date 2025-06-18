#!/bin/bash

# Wait for device to be fully available
sleep 2

# Set full paths
MOUNT="/bin/mount"
UMOUNT="/bin/umount"
MKDIR="/bin/mkdir"
CHMOD="/bin/chmod"
BLKID="/sbin/blkid"

# Device and mount point
DEVICE="/dev/$1"
MOUNT_POINT="/mnt/sdcard"

# Log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/sdgrabber.log
}

log_message "Starting mount script with device: $DEVICE"

# Check if something is already mounted
if mountpoint -q "$MOUNT_POINT"; then
    log_message "Unmounting existing device from $MOUNT_POINT"
    $UMOUNT "$MOUNT_POINT"
fi

# Ensure mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
    $MKDIR -p "$MOUNT_POINT"
fi

# Set mount point permissions
$CHMOD 777 "$MOUNT_POINT"

# Get filesystem type
FS_TYPE=$($BLKID -s TYPE -o value "$DEVICE")
log_message "Detected filesystem: $FS_TYPE"

# Attempt mount
$MOUNT -o rw,users "$DEVICE" "$MOUNT_POINT"
MOUNT_STATUS=$?

if [ $MOUNT_STATUS -eq 0 ]; then
    log_message "Successfully mounted $DEVICE"
    $CHMOD 777 "$MOUNT_POINT"
else
    log_message "Mount failed with status $MOUNT_STATUS"
fi

exit $MOUNT_STATUS