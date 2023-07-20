import os
import subprocess

account_ids = [
    # Replace these with your list of account IDs
    "719797195793", "939115282395", "530397177630", "502771900580"
]

# Split the account IDs into groups of 2
account_id_groups = [account_ids[i:i + 2] for i in range(0, len(account_ids), 2)]

print(f"Account ID Groups: {account_id_groups}")

for index, group in enumerate(account_id_groups):
    target_account_ids = " ".join(group)
    command = f"aws codebuild start-build --project-name create-build-project --environment-variables-override name=TARGET_ACCOUNT_IDS,value=\"{target_account_ids}\",type=PLAINTEXT"
    
    # Call the AWS CLI command
    print(f"Running Command for Group {index + 1}: {command}")
    exit_status = subprocess.call(command, shell=True)
    print(f"Command exit status: {exit_status}")

    # Let's add a pause here for debugging
    input("Press Enter to continue to the next group...")
