#!/bin/bash

# Shared configuration variables
PROJECT_NAME="keycloak_project"
IMAGE_NAME="my-keycloak"
CERT_DIR="./certs"
KEY_FILE="$CERT_DIR/nginx-selfsigned.key"
CRT_FILE="$CERT_DIR/nginx-selfsigned.crt"