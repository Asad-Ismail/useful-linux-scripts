#!/bin/bash

echo "======================================="
echo "          System Specifications"
echo "======================================="

# System Overview
echo -e "\n--- System Overview ---"
hostnamectl

# CPU Information
echo -e "\n--- CPU Information ---"
lscpu

# Memory Information
echo -e "\n--- Memory Information ---"
free -h

# Disk Information
echo -e "\n--- Disk Information ---"
lsblk -f

# GPU Information
echo -e "\n--- GPU Information ---"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
else
    echo "NVIDIA GPU not detected. Checking general GPU information..."
    lspci | grep -i vga
    glxinfo | grep "OpenGL" 2>/dev/null || echo "OpenGL details unavailable (install mesa-utils for more info)."
fi

# Motherboard Information
echo -e "\n--- Motherboard Information ---"
if command -v dmidecode &> /dev/null; then
    sudo dmidecode -t baseboard | grep -E "Manufacturer|Product|Version|Serial"
else
    echo "dmidecode not installed. Install it using: sudo apt install dmidecode"
fi

# Network Information
echo -e "\n--- Network Information ---"
ip a

# Installed Kernel
echo -e "\n--- Kernel Information ---"
uname -a

# USB and Peripheral Devices
echo -e "\n--- USB and Peripheral Devices ---"
lsusb

# Detailed System Information (Optional)
if command -v inxi &> /dev/null; then
    echo -e "\n--- Detailed System Information (inxi) ---"
    inxi -Fxz
else
    echo -e "\n--- inxi not installed. Skipping detailed system information. ---"
fi

echo -e "\n--- End of System Report ---"

