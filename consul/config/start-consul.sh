#!/bin/sh

# Cause the script to terminate immediately if any command exits with a non-zero status
set -e

# Read the encryption key from the file
ENCRYPT_KEY=$(cat /consul/config/encrypt.key)

# Start Consul agent with the encryption key
exec consul agent \
  -config-file=/consul/config/consul.hcl \
  -encrypt="$ENCRYPT_KEY"

