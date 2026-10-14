#!/usr/bin/env bash
set -euo pipefail

echo "Installing Samba..."
sudo pacman -S --needed samba

echo
echo "Enabling the Samba file-sharing service..."
sudo systemctl enable --now smb.service

echo
echo "Samba is installed and smb.service is running."
cat <<'EOF'

Next steps:
1. Edit /etc/samba/smb.conf and define the shares you want to publish.
   See /etc/samba/smb.conf.default for the packaged example.
2. Validate the configuration with: testparm
3. Add a Samba password for an existing Linux account with: sudo smbpasswd -a USER
4. Restart the service after changing the configuration:
   sudo systemctl restart smb.service

Samba user passwords are separate from Linux login passwords. Configure your
firewall to allow Samba only on the trusted network where you need file sharing.
EOF
