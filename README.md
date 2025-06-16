# SDGrabber

A Python application designed to run continuously on a Raspberry Pi.

## Installation

1. Clone this repository to your Raspberry Pi:
   ```bash
   git clone <your-repo-url> /home/pi/sdgrabber
   cd /home/pi/sdgrabber
   ```

2. Make the install script executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the installation script:
   ```bash
   ./install.sh
   ```

The script will:
- Create necessary log files
- Install Python dependencies
- Set up a systemd service to run the application on boot
- Start the service

## Service Management

You can manage the service using these commands:

- Check status: `sudo systemctl status sdgrabber`
- Stop service: `sudo systemctl stop sdgrabber`
- Start service: `sudo systemctl start sdgrabber`
- View logs: `tail -f /var/log/sdgrabber.log`

## Development

The main application code is in `main.py`. Add your application logic in the main loop.

To add Python package dependencies:
1. Add them to `requirements.txt`
2. Run `pip3 install -r requirements.txt`

## Logs

Logs are written to `/var/log/sdgrabber.log` and also output to the console when running manually.
