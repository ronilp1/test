#!/bin/bash
set -e

TARGET_ACCOUNT_ID=${1}

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
  local credentials=$(aws sts assume-role --role-arn "${role_arn}" --role-session-name "${ROLE_SESSION_NAME}")
  
  write_to_credentials "${profile_name}" "${credentials}"
}

# Check if the TARGET_ACCOUNT_ID variable is set
if [[ -z "${TARGET_ACCOUNT_ID}" ]]; then
  echo "TARGET_ACCOUNT_ID is not set. Please provide a target account ID as an argument when running this script."
  exit 1
fi

# Variables
AWS_PARTITION="aws"
ROLE_SESSION_NAME="AWSAFT-Session"
AFT_EXECUTION_ROLE="AWSAFTExecution"
AFT_EXECUTION_ROLE_ARN="arn:${AWS_PARTITION}:iam::${TARGET_ACCOUNT_ID}:role/${AFT_EXECUTION_ROLE}"

# Assume the AFT_EXECUTION_ROLE in the target account and write the credentials
assume_role_and_write_credentials "${AFT_EXECUTION_ROLE_ARN}" "aft-target"
