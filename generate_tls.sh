#!/bin/bash

host_name=$(hostname -s)
host_ip=$(hostname -I | awk '{print $1}')

[ "$(sudo ls -1 /var/lib/tor/hidden_services/vault/hostname 2>/dev/null)" ] && onion_alt=",DNS:$(sudo cat /var/lib/tor/hidden_services/vault/hostname)"

mkdir -p certs
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/vault.key \
  -out certs/vault.crt \
  -subj "/CN=$host_name" \
  -addext "subjectAltName=DNS:$host_name,IP:${host_ip}${onion_alt}"

chmod 640 certs/vault.key
sudo chown -R 100:1000 certs

sudo cp ./certs/vault.crt /usr/local/share/ca-certificates/vault.crt
sudo update-ca-certificates
