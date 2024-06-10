#!/bin/bash

# Define the URL of the R package tar.gz file
PACKAGE_NAME="depp_0.1.4.tar.gz"
PACKAGE_URL="https://minio.idee-prod.depp.in.adc.education.fr/$PACKAGE_NAME"

# Define the temporary download directory
DOWNLOAD_DIR="/tmp/r_package_download"

# Create the download directory if it does not exist
mkdir -p "$DOWNLOAD_DIR"

# Download the package tar.gz file
curl -o "$DOWNLOAD_DIR/$PACKAGE_NAME" "$PACKAGE_URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the package from $PACKAGE_URL"
    exit 1
fi

# Install the downloaded R package
R CMD INSTALL "$DOWNLOAD_DIR/$PACKAGE_NAME"

# Check if the installation was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to install the R package"
    exit 1
fi

# Clean up the temporary download directory
rm -rf "$DOWNLOAD_DIR"

echo "R package installed successfully"
