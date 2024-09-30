#!/bin/bash

# Function to display the current version of AWS SAM CLI
function display_current_version() {
  sam --version 2>/dev/null
}

# Check if AWS SAM CLI is installed
if command -v sam &>/dev/null; then
  echo "AWS SAM CLI is already installed. Current version:"
  display_current_version

  echo "Updating to the latest version..."
  # Download the latest version of AWS SAM CLI
  curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip"
  unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation

  # Update the existing AWS SAM CLI
  sudo ./sam-installation/install --update
else
  echo "AWS SAM CLI is not installed. Installing the latest version..."

  # Download and install the latest version of AWS SAM CLI
  curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip"
  unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation

  # Install AWS SAM CLI
  sudo ./sam-installation/install
fi

# Clean up
rm -rf aws-sam-cli-linux-x86_64.zip sam-installation/

# Display the installed version of AWS SAM CLI
echo "AWS SAM CLI installation or update completed. Installed version:"
display_current_version

# to uninstall:
# sudo rm -rf /usr/local/aws-sam-cli
# sudo rm /usr/local/bin/sam
