#!/bin/bash -
sed -i "s|^WorkingDirectory=.*$|WorkingDirectory=$(pwd)|" vault.service
sudo cp vault.service /etc/systemd/system/
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vault.service
sudo systemctl start vault.service
