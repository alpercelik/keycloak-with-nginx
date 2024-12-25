#!/bin/bash

# Source the configuration file
source ./config.sh

# Check if the certificate directory exists, if not, create it
if [ ! -d "$CERT_DIR" ]; then
    echo "Creating certificate directory: $CERT_DIR"
    mkdir -p "$CERT_DIR"
fi

# Check if the certificate and key files already exist
if [ ! -f "$KEY_FILE" ] || [ ! -f "$CRT_FILE" ]; then
    echo "Generating self-signed certificate..."

    # Generate the self-signed certificate
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$KEY_FILE" -out "$CRT_FILE" \
        -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

    if [ $? -eq 0 ]; then
        echo "Self-signed certificate created successfully."
        # Set appropriate permissions
        chmod 600 "$KEY_FILE" "$CRT_FILE"
    else
        echo "Error generating self-signed certificate."
        exit 1
    fi
else
    echo "Certificate and key files already exist. No action taken."
fi