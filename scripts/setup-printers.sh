#!/usr/bin/env bash
set -euo pipefail

echo "Installing CUPS and printer setup tools..."
sudo pacman -S --needed cups cups-filters system-config-printer avahi nss-mdns

echo
echo "Enabling printing and local network discovery..."
sudo systemctl enable --now cups.socket avahi-daemon.service

echo
echo "Printing support is installed."
cat <<'EOF'

Next steps:
- Open system-config-printer to add a USB or network printer.
- For the CUPS web interface, open http://localhost:631.
- For network printers advertised with mDNS, confirm that Avahi is allowed on
  your trusted local network.

If a printer needs a vendor-specific driver, install that driver's package
separately. This setup does not change firewall rules or printer permissions.
EOF
