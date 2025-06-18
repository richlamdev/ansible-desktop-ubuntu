#!/bin/bash

# Unset AWS CLI environment variables
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_DEFAULT_REGION

echo "AWS CLI environment credentials have been unset."

echo
aws sts get-caller-identity
