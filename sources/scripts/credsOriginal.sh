#!/bin/bash
set -e

# Function to write credentials
# ... (No change to this function)

# Function to assume roles and write credentials
# ... (No change to this function)

# Variables
AWS_PARTITION="aws"
TARGET_ACCOUNT_IDS=$1 # Receive the target account IDs as an argument
ROLE_SESSION_NAME="CodeBuild-Session"
TARGET_ROLE_NAME="allow-code-commit-account" # Name of the role created in target account

IFS=',' read -ra ACCOUNTS <<< "$TARGET_ACCOUNT_IDS"

for ACCOUNT_ID in "${ACCOUNTS[@]}"; do
    echo "Processing account: $ACCOUNT_ID"
    TARGET_ROLE_ARN="arn:${AWS_PARTITION}:iam::${ACCOUNT_ID}:role/${TARGET_ROLE_NAME}"
    # Assume the role in the target account and write the credentials
    assume_role_and_write_credentials "${TARGET_ROLE_ARN}" "codebuild-target-$ACCOUNT_ID"
done
