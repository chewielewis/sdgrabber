#!/usr/bin/env python3

# test 


import RPi.GPIO as GPIO
import time
import logging
import signal
import sys
import os

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/sdgrabber.log'),
        logging.StreamHandler()
    ]
)

# GPIO setup
LED_PIN_1 = 16
LED_PIN_2 = 20
GPIO.setmode(GPIO.BCM)
GPIO.setup(LED_PIN_1, GPIO.OUT)
GPIO.setup(LED_PIN_2, GPIO.OUT)

# Mount points
SD_MOUNT_PATH = '/mnt/sdcard'

def check_sd_mounted():
    """Check if SD card is mounted"""
    return os.path.ismount(SD_MOUNT_PATH)

def cleanup(signum, frame):
    """Clean up GPIO on exit"""
    logging.info("Cleaning up GPIO...")
    GPIO.cleanup()
    sys.exit(0)

# Register signal handlers
signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

def main():
    logging.info("Starting SDGrabber service")
    
    try:
        while True:
            # Update LED pattern based on SD card presence
            if check_sd_mounted():
                # Rapid alternating pattern when SD card is present
                GPIO.output(LED_PIN_1, GPIO.HIGH)
                GPIO.output(LED_PIN_2, GPIO.LOW)
                time.sleep(0.2)
                GPIO.output(LED_PIN_1, GPIO.LOW)
                GPIO.output(LED_PIN_2, GPIO.HIGH)
                time.sleep(0.2)
            else:
                # Slower pattern when no SD card is present
                GPIO.output(LED_PIN_1, GPIO.HIGH)
                GPIO.output(LED_PIN_2, GPIO.LOW)
                time.sleep(0.5)
                GPIO.output(LED_PIN_1, GPIO.LOW)
                GPIO.output(LED_PIN_2, GPIO.HIGH)
                time.sleep(0.5)
    except Exception as e:
        logging.error(f"Error in main loop: {e}")
        cleanup(None, None)

if __name__ == "__main__":
    main()
