#!/bin/bash

SCRIPT_GIT_NAME="install_git_python_0.1.0.sh"
SCRIPT_GIT_URL="https://minio.idee-prod.depp.in.adc.education.fr/artifacts/$SCRIPT_GIT_NAME"

SCRIPT_TOKEN_NAME="get_token.py"
SCRIPT_TOKEN_URL="https://minio.idee-prod.depp.in.adc.education.fr/artifacts/$SCRIPT_TOKEN_NAME"

# Define the temporary download directory
DOWNLOAD_DIR="/tmp/package_download"

# Create the download directory if it does not exist
mkdir -p "$DOWNLOAD_DIR"

# Download the SCRIPT_GIT_NAME file
curl -o "$DOWNLOAD_DIR/$SCRIPT_GIT_NAME" "$SCRIPT_GIT_URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the package from $SCRIPT_GIT_URL"
    exit 1
fi

# Download the SCRIPT_GIT_NAME file
curl -o "$DOWNLOAD_DIR/$SCRIPT_TOKEN_NAME" "$SCRIPT_TOKEN_URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the package from $SCRIPT_TOKEN_URL"
    exit 1
fi

chown onyxia $DOWNLOAD_DIR/$SCRIPT_GIT_NAME
chmod 700 $DOWNLOAD_DIR/$SCRIPT_GIT_NAME

/bin/bash $DOWNLOAD_DIR/$SCRIPT_GIT_NAME

# Clean up the temporary download directory
rm -rf "$DOWNLOAD_DIR"