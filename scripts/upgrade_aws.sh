#!/bin/bash

file="/usr/local/bin/aws"
folder="/usr/local/aws-cli"

# Check if the file exists and delete it if it does
if [ -e "$file" ]; then
  echo "Deleting $file..."
  sudo rm "$file"
  echo "Deleted aws file successfully."
else
  echo "AWS file does not exist."
fi

# Check if the folder exists and delete it if it does
if [ -d "$folder" ]; then
  echo "Deleting $folder..."
  sudo rm -rf "$folder"
  echo "Deleted aws folder successfully."
else
  echo "AWS folder does not exist."
fi

executable_temp_dir="/tmp"
aws_cli_installed="/usr/local/bin/aws"

# Download AWS CLI v2 installer
echo "Downloading AWS CLI v2 installer..."
wget -qO /tmp/awscli-exe-linux-x86_64.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

# Unarchive AWS CLI v2 installer
echo "Unarchiving AWS CLI v2 installer..."
unzip -qo /tmp/awscli-exe-linux-x86_64.zip -d "${executable_temp_dir:-/tmp}"

# Run AWS CLI v2 installer
echo "Running AWS CLI v2 installer..."
sudo "${executable_temp_dir:-/tmp}"/aws/install

# Check if AWS CLI installation was successful
if [ -e "$aws_cli_installed" ]; then
  echo "AWS CLI v2 installation completed successfully."
else
  echo "Error: AWS CLI v2 installation failed."
  exit 1
fi
