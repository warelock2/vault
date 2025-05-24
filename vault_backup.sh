#!/bin/bash -
mkdir -p backups
echo "WARNING: Vault backup files are unencrypted"
vault operator raft snapshot save backups/vault-snapshot.$(date +%Y%m%d.%H%M%S).snap
