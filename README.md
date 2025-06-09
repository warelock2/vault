# Hashicorp Vault deployed via Docker Compose

# Preparation

## Initial setup

```shell
sudo snap install vault
./generate_tls.sh
./create_vault_storage.sh
./setup_persistent_service.sh
. ./set_vault_addr.sh
vault status
```

## Initialize the Vault

Run this command and securely make a record of the five unseal keys and
the root token. This is a one-time command.

```shell
vault operator init
```

# Unseal the Vault and Enable Logging

Run the following command three times, giving it one of the five unseal
keys from the init step. You must supply a new unseal token each time.

```shell
. ./set_vault_addr.sh
vault operator unseal
vault operator unseal
vault operator unseal
vault login
vault status
./enable_vault_logging.sh
```

NOTE: This will have to be done after every reboot, in order for you
to be able to access secrets in the vault. The `vault login` step
requires the root token from the `vault operator init` step.

# Permanent VAULT_ADDR Setup

Add the following line to your "~/.profile" startup script, so you
don't have to run `. ./set_vault_addr.sh` before running the 
`vault` command. This will take effect the next time you log in.

```
export VAULT_ADDR=https://127.0.0.1:8200
```

# Backups

```shell
vault_backup.sh
```

NOTE: Backup archive files are timestamped and stored in the "backups/"
folder.

# Import Self-signed Cert From Your Remote Vault Server

Transfer the ".crt" file from the "certs/" directory to your local
machine, then do this:

```shell
sudo cp remote_vault_server.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

You can then point your VAULT_ADDR variable to your remote vault
server and see if you can access it remotely:

```shell
export VAULT_ADDR=https://remote_vault_server:8200
vault status
```

# Vault Seal Monitoring

```shell
./setup_vault_monitoring.sh
```

Provide a valid VAULT_ADDR variable compatible with Vault, if asked.
You will also be prompted to provide an "ntfy.sh"-style notification
topic string. To get Android-style push notifications about vault
seal/unseal operations, install the "ntfy.sh" Android app and set
the app to the same topic you define here. You will also need to 
manually add this to root's cron jobs, but instructions will be
provided from the monitoring setup script on how to do that. 

Event logging is recorded in `/var/log/vault_seal_monitor.log`, but
the logging should be quite minimal, so I wouldn't bother setting up
logrotate to manage the logs.
