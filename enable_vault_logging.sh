#!/bin/bash -
vault audit enable file file_path=/vault/logs/vault_audit.log
sed -i "s|^.*vault_audit.log|$(pwd)/vault-node1/logs/vault_audit.log|" vault_audit
sudo cp vault_audit /etc/logrotate.d/vault_audit
