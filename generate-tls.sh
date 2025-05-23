#!/bin/bash

mkdir -p certs
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/vault.key \
  -out certs/vault.crt \
  -subj "/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

chmod 640 certs/vault.key
sudo chown -R 1000:1000 certs

sudo cp ./certs/vault.crt /usr/local/share/ca-certificates/vault.crt
sudo update-ca-certificates
