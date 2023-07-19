#!/bin/bash
set -e

# Function to write credentials
function write_to_credentials {
  local profile=${1}
  local credentials=${2}
  local aws_access_key_id
  local aws_secret_access_key
  local aws_session_token

  aws_access_key_id="$(echo "${credentials}" | jq --raw-output ".Credentials[\"AccessKeyId\"]")"
  aws_secret_access_key="$(echo "${credentials}" | jq --raw-output ".Credentials[\"SecretAccessKey\"]")"
  aws_session_token="$(echo "${credentials}" | jq --raw-output ".Credentials[\"SessionToken\"]")"

  aws configure set aws_access_key_id "${aws_access_key_id}" --profile "${profile}"
  aws configure set aws_secret_access_key "${aws_secret_access_key}" --profile "${profile}"
  aws configure set aws_session_token "${aws_session_token}" --profile "${profile}"
}

# Function to assume roles and write credentials
function assume_role_and_write_credentials {
  local role_arn="${1}"
  local profile_name="${2}"
  
  echo "Assuming role: ${role_arn}"
  local credentials=$(aws sts assume-role --role-arn "${role_arn}" --role-session-name "CodeBuild-Session")
  
  write_to_credentials "${profile_name}" "${credentials}"
}

# Variables
AWS_PARTITION="aws"
ROLE_SESSION_NAME="CodeBuild-Session"
TARGET_ROLE_NAME="allow-code-commit-account" # Name of the role created in target account

TARGET_ACCOUNT_IDS=$(echo $TARGET_ACCOUNT_IDS | tr "," "\n")

for ACCOUNT_ID in $TARGET_ACCOUNT_IDS
do
  TARGET_ROLE_ARN="arn:${AWS_PARTITION}:iam::${ACCOUNT_ID}:role/${TARGET_ROLE_NAME}"

  # Assume the role in the target account and write the credentials
  assume_role_and_write_credentials "${TARGET_ROLE_ARN}" "codebuild-target-${ACCOUNT_ID}"
done
