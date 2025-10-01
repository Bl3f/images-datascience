#!/bin/bash

# Define the URL of the R package tar.gz file
PACKAGE_NAME="depp_0.1.4.tar.gz"
PACKAGE_URL="https://minio.idee-prod.depp.in.adc.education.fr/artifacts/$PACKAGE_NAME"

SCRIPT_GIT_NAME="install_git_0.1.0.sh"
SCRIPT_GIT_URL="https://minio.idee-prod.depp.in.adc.education.fr/artifacts/$SCRIPT_GIT_NAME"

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

curl -o "$DOWNLOAD_DIR/$SCRIPT_GIT_NAME" "$SCRIPT_GIT_URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the package from $SCRIPT_GIT_URL"
    exit 1
fi

cp $DOWNLOAD_DIR/$SCRIPT_GIT_NAME /home/rstudio/$SCRIPT_GIT_NAME
chown rstudio /home/rstudio/$SCRIPT_GIT_NAME
chmod 700 /home/rstudio/$SCRIPT_GIT_NAME

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

# On bloque github
iptables -A OUTPUT -p tcp -d 140.82.121.3 -j DROP
iptables -A OUTPUT -p tcp -d 140.82.121.5 -j DROP
iptables -A OUTPUT -p tcp -d 185.199.111.133 -j DROP
iptables -A OUTPUT -p tcp -d 185.199.110.133 -j DROP
iptables -A OUTPUT -p tcp -d 185.199.109.133 -j DROP
iptables -A OUTPUT -p tcp -d 185.199.108.133 -j DROP
iptables -A OUTPUT -p udp -d 140.82.121.3 -j DROP
iptables -A OUTPUT -p udp -d 140.82.121.5 -j DROP
iptables -A OUTPUT -p udp -d 185.199.111.133 -j DROP
iptables -A OUTPUT -p udp -d 185.199.110.133 -j DROP
iptables -A OUTPUT -p udp -d 185.199.109.133 -j DROP
iptables -A OUTPUT -p udp -d 185.199.108.133 -j DROP