#!/bin/bash

# Set full paths
UMOUNT="/bin/umount"
MOUNT_POINT="/mnt/sdcard"

# Log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/sdgrabber.log
}

log_message "Starting unmount process"

# Force unmount if device is busy
if mountpoint -q "$MOUNT_POINT"; then
    log_message "Unmounting device from $MOUNT_POINT"
    $UMOUNT -f "$MOUNT_POINT"
    if [ $? -eq 0 ]; then
        log_message "Successfully unmounted device"
    else
        log_message "Failed to unmount device, trying lazy unmount"
        $UMOUNT -l "$MOUNT_POINT"
        if [ $? -eq 0 ]; then
            log_message "Lazy unmount successful"
        else
            log_message "All unmount attempts failed"
        fi
    fi
fi