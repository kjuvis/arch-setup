# Arch Linux Post-Install Skript

Dieses Repository enthält ein Post-Installations-Skript für Arch Linux mit KDE, das wichtige Programme installiert, die Firewall konfiguriert, Themes setzt und mehr.

## Features

- Installation von yay, flatpak, AUR-Paketen (Discord, Spotify, Brave, VSCode)
- Aktivierung und Konfiguration der UFW Firewall
- Zsh als Standard-Shell setzen
- KDE Breeze Dark Theme aktivieren
- Brave als Standard-Webbrowser und Alacritty als Standard-Terminal setzen
- Flatpak Flathub Repository hinzufügen

## Nutzung

### Repository klonen und Skript in einem Schritt ausführen

Um das Skript direkt aus dem Repository zu klonen und auszuführen, kannst du folgenden Einzeiler verwenden:

```bash
git clone https://github.com/kjuvis/arch-setup.git 
cd arch-setup 
sh arch-post-install.sh
