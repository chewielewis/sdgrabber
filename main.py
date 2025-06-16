#!/usr/bin/env python3

# test 


import RPi.GPIO as GPIO
import time
import logging
import signal
import sys

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
LED_PIN_1 = 16    # First LED
LED_PIN_2 = 20    # Second LED (using GPIO 20)
GPIO.setmode(GPIO.BCM)
GPIO.setup(LED_PIN_1, GPIO.OUT)
GPIO.setup(LED_PIN_2, GPIO.OUT)

def cleanup(signum, frame):
    """Clean up GPIO on exit"""
    logging.info("Cleaning up GPIO...")
    GPIO.cleanup()
    sys.exit(0)

# Register signal handlers
signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

def main():
    logging.info("Starting SDGrabber service with alternating LEDs")
    try:
        while True:
            # First LED on, Second LED off
            GPIO.output(LED_PIN_1, GPIO.HIGH)
            GPIO.output(LED_PIN_2, GPIO.LOW)
            time.sleep(0.5)
            # First LED off, Second LED on
            GPIO.output(LED_PIN_1, GPIO.LOW)
            GPIO.output(LED_PIN_2, GPIO.HIGH)
            time.sleep(0.5)
    except Exception as e:
        logging.error(f"Error in main loop: {e}")
        cleanup(None, None)

if __name__ == "__main__":
    main()
