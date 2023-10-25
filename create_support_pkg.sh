#!/bin/bash
if [ -n "$1" ]; then
    archive_dir="$1"
else
    archive_dir="$(pwd)"
fi

# Define the timestamp for the archive filename
timestamp=$(date +'%Y%m%d%H%M%S')

# Create the archive filename
archive_filename="support-pkg-$timestamp.tar.gz"

# Create a temporary directory for collecting logs and version information
temp_dir="$archive_dir"
mkdir -p "$temp_dir"

# Set the device and baud rate
DEVICE="/dev/ttyEQ-JT103"
BAUD_RATE="9600"

# Run Minicom to connect to the device
sudo -S minicom -D $DEVICE -b $BAUD_RATE | tee minicom_output.txt &

# Wait for Minicom to finish or extract the IP address
sleep 5  # Adjust the sleep duration as needed

# Extract the IP address from the Minicom output
device_ip=$(grep 'inet ' minicom_output.txt | awk '{print $2}' | sed -n '1p')

# Use the device_ip variable for file transfers or other actions
echo "Device IP: $device_ip"

# Get and save version information in version.txt
uname -a > "version.txt"
echo "status" >> "version.txt"
ps -ef | grep gnb >> "version.txt"
echo "time sync" >> "version.txt"
timedatectl >> "version.txt"

# Remove the temporary output file
#rm minicom_output.txt

#After Minicom session ends, use scp to copy files from the device to the host
scp user@$device_ip:/tmp/evlog.txt $temp_dir
