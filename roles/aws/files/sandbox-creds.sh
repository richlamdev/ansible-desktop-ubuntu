#!/usr/bin/env bash

# Prompt the user for their AWS credentials
read -p "Enter AWS Access Key ID: " ACCESS_KEY_ID
read -p "Enter AWS Secret Access Key: " SECRET_ACCESS_KEY
echo
# read -p "Enter AWS Session Token (if any, leave blank if none): " SESSION_TOKEN
# read -p "Enter AWS Region (default: us-east-1): " REGION

# Use default region if none is provided
REGION=${REGION:-us-east-1}

# Export the credentials into the environment
export AWS_ACCESS_KEY_ID="$ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET_ACCESS_KEY"
# export AWS_SESSION_TOKEN="$SESSION_TOKEN"
export AWS_DEFAULT_REGION="us-east-1"

echo "✅ AWS credentials have been set in your environment."
