# STDOUT="/dev/stdout"
# LOG_FILE="$STDOUT"
# LOG_MESSAGE="is the date, should log to $STDOUT"

# # log with timestamp
# log_message() {
#     echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
# }

# log_message "$LOG_MESSAGE"


#!/bin/bash

echo "Hello, World!"
brew install kubectl
brew install terraform
