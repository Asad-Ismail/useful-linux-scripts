#!/bin/bash

# Update system and install required dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y ffmpeg v4l2loopback-dkms curl wget unzip

# Install OBS Studio
sudo apt install -y obs-studio

# Install DroidCam Client
echo "Downloading DroidCam client..."
wget -O droidcam_latest.zip https://files.dev47apps.net/linux/droidcam_latest.zip
unzip droidcam_latest.zip -d droidcam
cd droidcam
sudo ./install-client
cd ..
rm -rf droidcam droidcam_latest.zip

# Load the DroidCam video loopback module
sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2

# Display message for phone app
echo -e "\nInstallation complete!"
echo "1. Install the DroidCam app on your phone (Android/iOS)."
echo "   - Android: https://play.google.com/store/apps/details?id=com.dev47apps.droidcam"
echo "   - iOS: https://apps.apple.com/app/id1510258102"
echo "2. Connect your phone and computer to the same Wi-Fi network (or use USB)."
echo "3. Open the DroidCam app on your phone and note the IP address."
echo "4. Run 'droidcam-cli [IP] [port]' to connect. Example:"
echo "   droidcam-cli 192.168.1.100 4747"
echo "5. Use the virtual camera in OBS Studio by selecting 'Video Capture Device'."
