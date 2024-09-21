#!/bin/bash

# Check if AWS CLI is installed
if command -v aws &>/dev/null; then
  echo "Current AWS CLI version: $(aws --version)"
  echo "Updating to the latest version..."

  # Download the latest version of AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip

  # Update the existing AWS CLI without deleting the old one
  sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
else
  echo "AWS CLI is not installed. Installing the latest version..."

  # Download and install the latest version of AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip

  # Install AWS CLI
  sudo ./aws/install
fi

# Clean up
rm -rf awscliv2.zip aws/
echo "AWS CLI installation or update completed."
echo
echo "Current AWS CLI version: $(aws --version)"
echo

# to uninstall
# sudo rm /usr/local/bin/aws
# sudo rm -rf /usr/local/aws-cli
