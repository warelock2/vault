#!/bin/bash -
MONITOR_NAME="vault_seal_monitor"
ENV_FILE="/etc/$MONITOR_NAME.env"
MONITOR_SCRIPT="$MONITOR_NAME.sh"
MONITOR_LOG="$MONITOR_NAME.log"
DEST_FOLDER="/usr/local/bin"
LOGGING_FOLDER="/var/log"

if [ -z "$VAULT_ADDR" ]; then
  printf "VAULT_ADDR (ie. \"http://127.0.0.1:8200\"): "; read VAULT_ADDR
  if [ -z "$VAULT_ADDR" ]; then
    echo "error: VAULT_ADDR value is required."
    exit 1
  fi
fi

printf "NTFY_TOPIC: "; read NTFY_TOPIC
if [ -z "$NTFY_TOPIC" ]; then
  echo "error: NTFY_TOPIC value is required."
  exit 1
fi

sudo tee "$ENV_FILE" > /dev/null << EOL
VAULT_ADDR="$VAULT_ADDR"
NTFY_TOPIC="$NTFY_TOPIC"
EOL
sudo chmod 700 $ENV_FILE

sudo cp $MONITOR_SCRIPT $DEST_FOLDER
sudo chown $USER:$USER $MONITOR_SCRIPT
sudo chmod 700 $DEST_FOLDER/$MONITOR_SCRIPT

echo ""
echo "Run the \"sudo crontab -e\" command and add this line to the cron job list:"
echo ""
echo "*/5 * * * * $DEST_FOLDER/$MONITOR_SCRIPT >> $LOGGING_FOLDER/$MONITOR_LOG 2>&1"
echo ""
echo "This will check the seal status of the vault every five minutes"
echo "and only notify you of changes when they occur via the Android ntfy.sh"
echo "push notification service at this notification topic:"
echo ""
echo "\"$NTFY_TOPIC\""
echo ""
