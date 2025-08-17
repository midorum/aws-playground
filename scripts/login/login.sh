#!/bin/bash

# === Exit on unset variables only ===
set -u
set -o pipefail

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "❌ This script must be run with 'source' or '.' so it can modify your current shell environment."
    echo "Example: source $0"
    return 1 2>/dev/null || exit 1
fi

# === Source files ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPG_FILE="$SCRIPT_DIR/keys.gpg"
ROLES_FILE="$SCRIPT_DIR/roles"
LOG_FILE="$SCRIPT_DIR/script_errors.log"

# Save original prompt to restore later
ORIGINAL_PS1="$PS1"

cleanup_shell() {
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_ROLE_NAME ACCOUNT_ID IAM_USERNAME AWS_SESSION_EXPIRATION
}

# Cleanup function on exit
aws_logout() {
    cleanup_shell
    export PS1="$ORIGINAL_PS1"
    echo "AWS credentials cleared. Prompt restored."
    read -p "Press Enter to exit..."
}
trap aws_logout EXIT

# === Handle errors ===
trap '{
    ERR_CODE=$?
    echo "❌ Error (code $ERR_CODE) in line $LINENO while executing: $BASH_COMMAND"
    echo "[ $(date "+%Y-%m-%d %H:%M:%S") ] Error (code $ERR_CODE) in line $LINENO: $BASH_COMMAND" >> "$LOG_FILE"
    echo "See $LOG_FILE"
}' ERR

# === Clean the current shell state ===
cleanup_shell

# === Decrypt GPG file with credentials and sensitive data ===
#eval $(gpg --quiet --decrypt "$GPG_FILE")
# === Decrypt GPG file with credentials and sensitive data ===
if ! eval $(gpg --quiet --decrypt "$GPG_FILE"); then
    echo "Failed to decrypt $GPG_FILE"
    return 1
fi

# Ensure all variables are present
: "${AWS_ACCESS_KEY_ID:?Missing AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY:?Missing AWS_SECRET_ACCESS_KEY}"
: "${ACCOUNT_ID:?Missing ACCOUNT_ID}"
: "${IAM_USERNAME:?Missing IAM_USERNAME}"

# === Ask for session duration ===
read -p "Enter session duration in seconds [3600]: " SESSION_DURATION
SESSION_DURATION=${SESSION_DURATION:-3600}

# === Ask for MFA code ===
read -p "Enter MFA code for $IAM_USERNAME@$ACCOUNT_ID: " MFA_CODE
MFA_SERIAL="arn:aws:iam::$ACCOUNT_ID:mfa/$IAM_USERNAME"

# === Get temporary user credentials ===
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
CREDS=$(aws sts get-session-token \
    --serial-number "$MFA_SERIAL" \
    --token-code "$MFA_CODE" \
    --duration-seconds "$SESSION_DURATION") || return 1
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

export AWS_ACCESS_KEY_ID=$(echo "$CREDS" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "$CREDS" | jq -r '.Credentials.SessionToken')
export AWS_SESSION_EXPIRATION=$(echo "$CREDS" | jq -r '.Credentials.Expiration')

echo "Temporary user credentials acquired."

# === Role selection ===
if [[ -f "$ROLES_FILE" ]]; then
    echo "Select a role to assume:"
    echo "0) Work as main account (${IAM_USERNAME})"
    i=1
    declare -a ROLE_LIST
    while IFS= read -r role; do
        ROLE_LIST[$i]="$role"
        echo "$i) $role"
        ((i++))
    done < "$ROLES_FILE"

    read -p "Enter choice: " CHOICE
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [[ "$CHOICE" -gt 0 ]]; then
        SELECTED_ROLE="${ROLE_LIST[$CHOICE]}"
        echo "Assuming role: $SELECTED_ROLE"

        ROLE_CREDS=$(aws sts assume-role \
            --role-arn "$SELECTED_ROLE" \
            --role-session-name "CLI-Session" \
            --duration-seconds "$SESSION_DURATION") || return 1

        export AWS_ACCESS_KEY_ID=$(echo "$ROLE_CREDS" | jq -r '.Credentials.AccessKeyId')
        export AWS_SECRET_ACCESS_KEY=$(echo "$ROLE_CREDS" | jq -r '.Credentials.SecretAccessKey')
        export AWS_SESSION_TOKEN=$(echo "$ROLE_CREDS" | jq -r '.Credentials.SessionToken')
        export AWS_ROLE_NAME=$(basename "$SELECTED_ROLE")
        echo "Role $SELECTED_ROLE assumed successfully"
    else
        echo "Continuing with main account."
        export AWS_ROLE_NAME="$IAM_USERNAME"
    fi
else
    echo "Roles file not found, continuing with main account."
    export AWS_ROLE_NAME="$IAM_USERNAME"
fi

# === Set session duration variable ===
#export AWS_SESSION_EXPIRATION="$SESSION_DURATION"

# === Update shell prompt to show role ===
export PS1="[\$AWS_ROLE_NAME]:\[\033[01;34m\]\w\[\033[00m\]\$ "


echo "Session valid for $((SESSION_DURATION / 60)) minutes until $AWS_SESSION_EXPIRATION."
echo "AWS temporary credentials will be automatically cleared when you exit this terminal."