#!/bin/bash
set -e

# Aktueller Benutzer und Home-Verzeichnis
USER_NAME=$(logname)
HOME_DIR=$(eval echo "~$USER_NAME")

echo "Starte Post-Installations-Skript für Benutzer: $USER_NAME"

# 1. System aktualisieren
echo "System aktualisieren..."
sudo pacman -Syu --noconfirm

# 2. Basis-Pakete installieren (inkl. wichtige Tools ohne NM, Firefox, PulseAudio, pavucontrol)
echo "Installiere Basis-Pakete und wichtige Programme..."

sudo pacman -S --noconfirm --needed git base-devel zsh flatpak ufw \
    alacritty kdeconnect vim htop wget curl \
    neofetch unzip tar gzip

# 3. Yay installieren (AUR Helper)
if ! command -v yay &> /dev/null; then
    echo "yay nicht gefunden, installiere..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# 4. AUR Pakete installieren via yay (discord, spotify, brave-bin, visual-studio-code-bin)
echo "Installiere AUR Pakete via yay..."
sudo -u "$USER_NAME" yay -S --noconfirm --needed discord spotify brave-bin visual-studio-code-bin

# 5. UFW Firewall aktivieren und konfigurieren
echo "Konfiguriere UFW Firewall..."
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# 6. Zsh als Standard-Shell setzen
echo "Setze Zsh als Standard-Shell für $USER_NAME..."
sudo chsh -s /bin/zsh "$USER_NAME"

# 7. KDE Einstellungen anpassen (Breeze Dark Theme und Standard-Anwendungen)
echo "Setze Breeze Dark als KDE Theme und konfiguriere Standard-Anwendungen..."

KDE_CONFIG_DIR="$HOME_DIR/.config"

sudo -u "$USER_NAME" mkdir -p "$KDE_CONFIG_DIR"

sudo -u "$USER_NAME" kwriteconfig5 --file kdeglobals --group 'General' --key 'ColorScheme' 'BreezeDark'

sudo -u "$USER_NAME" kwriteconfig5 --file kdeglobals --group 'KDE' --key 'DefaultTerminalApplication' 'alacritty.desktop'

sudo -u "$USER_NAME" xdg-settings set default-web-browser brave.desktop

sudo -u "$USER_NAME" xdg-mime default brave.desktop x-scheme-handler/http
sudo -u "$USER_NAME" xdg-mime default brave.desktop x-scheme-handler/https
sudo -u "$USER_NAME" xdg-mime default alacritty.desktop x-scheme-handler/terminal

# 8. Flatpak Repository hinzufügen (flathub)
echo "Füge Flathub Flatpak Repository hinzu..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 9. Benutzerrechte für kdeconnect (evtl. nötig)
echo "Füge $USER_NAME zur Gruppe 'plugdev' hinzu (für KDE Connect)..."
sudo usermod -aG plugdev "$USER_NAME"

echo "Post-Installation abgeschlossen!"
echo "Bitte melde dich neu an, damit alle Änderungen wirksam werden."

exit 0
