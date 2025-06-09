#!/bin/bash

# Read in global configurations
ENV_FILE="/etc/vault_seal_monitor.env"
[[ -f "$ENV_FILE" ]] && source "$ENV_FILE"

# Configuration overrides
#VAULT_ADDR="https://127.0.0.1:8200"
#NTFY_TOPIC="vault-status-alert"

NTFY_URL="https://ntfy.sh/$NTFY_TOPIC"
STATE_FILE="/var/tmp/vault_seal_state"

# Check seal status via Vault API
current_status=$(curl -s "$VAULT_ADDR/v1/sys/seal-status" | jq -r .sealed)

if [[ "$current_status" != "true" && "$current_status" != "false" ]]; then
  echo "[$(date)] Error: Failed to retrieve seal status." >&2
  exit 1
fi

# Initialize last known state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
  echo "$current_status" > "$STATE_FILE"
  echo "[$(date)] Initialized state file with: $current_status"
  exit 0
fi

last_status=$(cat "$STATE_FILE")

# Compare and send notification if changed
if [[ "$current_status" != "$last_status" ]]; then
  state_msg="Vault state changed: "
  if [[ "$current_status" == "true" ]]; then
    state_msg+="🔒 SEALED"
  else
    state_msg+="🔓 UNSEALED"
  fi

  curl -s -X POST "$NTFY_URL" \
    -H "X-Title: Vault Seal Status Changed" \
    -H "X-Notification-Priority: 5" \
    -d "$state_msg" \
    -o /dev/null

  echo "[$(date)] $state_msg"
  echo "$current_status" > "$STATE_FILE"
#else
#  echo "[$(date)] No change: Vault still ${current_status^^}"
fi

