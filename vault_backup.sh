#!/bin/bash -
mkdir -p backups
vault operator raft snapshot save backups/vault-snapshot.$(date +%Y%m%d.%H%M%S).snap
