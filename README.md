# Hashicorp Vault deployed via Docker Compose

# Preparation

## Initial setup

```shell
./generate-tls.sh
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

# Unseal the vault

Run the following command three times, giving it one of the five unseal
keys from the init step. You must supply a new unseal token each time.

```shell
. ./set_vault_addr.sh
vault operator unseal
vault operator unseal
vault operator unseal
vault status
```

NOTE: This will have to be done after every reboot, in order for you
to be able to access secrets in the vault.

# Permanent VAULT_ADDR setup

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
