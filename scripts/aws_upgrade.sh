#!/bin/bash

# Function to display the current version of AWS SAM CLI
function display_sam_version() {
  sam --version 2>/dev/null
}

# Function to display the current version of AWS CLI
function display_aws_version() {
  aws --version 2>/dev/null
}

# Function to install or update AWS SAM CLI
function manage_sam_cli() {
  if command -v sam &>/dev/null; then
    echo "AWS SAM CLI is already installed. Current version:"
    display_sam_version

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

  # Clean up SAM CLI files
  rm -rf aws-sam-cli-linux-x86_64.zip sam-installation/

  # Display the installed version of AWS SAM CLI
  echo "AWS SAM CLI installation or update completed. Installed version:"
  display_sam_version
}

# Function to install or update AWS CLI
function manage_aws_cli() {
  if command -v aws &>/dev/null; then
    echo "AWS CLI is already installed. Current version: $(display_aws_version)"
    echo "Updating to the latest version..."

    # Download the latest version of AWS CLI
    curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip

    # Update the existing AWS CLI
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
  else
    echo "AWS CLI is not installed. Installing the latest version..."

    # Download and install the latest version of AWS CLI
    curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip

    # Install AWS CLI
    sudo ./aws/install
  fi

  # Clean up AWS CLI files
  rm -rf awscliv2.zip aws/

  # Display the installed version of AWS CLI
  echo "AWS CLI installation or update completed."
  echo "Installed version: $(display_aws_version)"
}

# Main script execution
echo "Managing AWS SAM CLI..."
manage_sam_cli
echo
echo "Managing AWS CLI..."
manage_aws_cli

# Uninstallation instructions
echo
echo "To uninstall AWS SAM CLI:"
echo "  sudo rm /usr/local/bin/sam"
echo "  sudo rm -rf /usr/local/aws-sam-cli"
echo
echo "To uninstall AWS CLI:"
echo "  sudo rm /usr/local/bin/aws"
echo "  sudo rm -rf /usr/local/aws-cli"
