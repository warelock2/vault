#!/bin/bash -
sudo cp vault.service /etc/systemd/system/
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vault.service
sudo systemctl start vault.service
