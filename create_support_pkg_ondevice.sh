#!/bin/bash
# Check if a destination directory parameter was provided
if [ -n "$1" ]; then
        archive_dir="$1"
else
        archive_dir="$(pwd)"
fi

#Define output filename with a timestamp
timestamp=$(date +'%Y%m%d%H%M%S')
archive_filename="support-pkg-$timestamp.tar.gz"

# Define the source directories and files to include in the archive
coredump_dir="/coredump/"
logdump_dir="/logdump/"
evlog_file="/tmp/evlog.txt"

# backeup config
# du and cu config

# Get and save version information in version.txt
uname -a > "$archive_dir/version.txt";
echo "">> "$archive_dir/version.txt";
timedatectl >> "$archive_dir/version.txt";

# Create the archive
tar -czvf "$archive_dir/$archive_filename" "$coredump_dir" "$logdump_dir" "$evlog_file" "$archive_dir/version.txt"

# Clean up the temporary directory
#rm -rf "$archive_dir/version.txt"

# Print a message indicating the archive creation
echo "Archive created: $archive_filename"
