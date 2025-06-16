#!/usr/bin/env python3

import logging
import time
from datetime import datetime
import RPi.GPIO as GPIO

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/sdgrabber.log'),
        logging.StreamHandler()
    ]
)

def setup_gpio():
    GPIO.setmode(GPIO.BCM)  # Use Broadcom pin numbering
    GPIO.setup(16, GPIO.OUT)  # Set GPIO16 as output
    logging.info("GPIO setup completed")

def cleanup_gpio():
    GPIO.cleanup()
    logging.info("GPIO cleanup completed")

def main():
    logging.info("Starting SDGrabber application")
    
    try:
        setup_gpio()
        while True:
            # Blink LED to show the script is active
            GPIO.output(16, GPIO.HIGH)  # Turn on LED
            time.sleep(0.5)
            GPIO.output(16, GPIO.LOW)   # Turn off LED
            time.sleep(0.5)
            
            # Your main application logic will go here
            current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            logging.info(f"Application running at {current_time}")
            
    except KeyboardInterrupt:
        logging.info("Application stopped by user")
    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")
        raise
    finally:
        cleanup_gpio()
    
if __name__ == "__main__":
    main()
