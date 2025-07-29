#!/bin/bash
set -e

# 1. System aktualisieren
echo "System aktualisieren..."
sudo pacman -Syu --noconfirm

# 2. Basis-Pakete installieren (inkl. wichtige Tools ohne NM, Firefox, PulseAudio, pavucontrol)
echo "Installiere Basis-Pakete und wichtige Programme..."

sudo pacman -S --noconfirm --needed git base-devel zsh flatpak ufw alacritty kdeconnect vim htop wget curl neofetch unzip tar gzip fastfetch 

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

echo "💡 Preparing Zsh plugins..."
touch ~/.zshrc
mkdir -p ~/.zsh/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/plugins/zsh-completions

echo "📜 Updating .zshrc with plugin configuration..."
cat << 'EOF' >> ~/.zshrc

# Plugin Paths
fpath+=~/.zsh/plugins/zsh-completions

# Load Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -Uz compinit && compinit
EOF

#source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

echo "=> Installiere Alacritty-Konfiguration..."
  mkdir -p ~/.config/alacritty
  cp ./config/alacritty/alacritty.toml ~/.config/alacritty/
  echo "✓ Alacritty-Konfiguration kopiert."

echo "=> Installiere Fastfetch-Konfiguration..."
  mkdir -p ~/.config/fastfetch
  cp ./config/fastfetch/config.jsonc ~/.config/fastfetch/
  echo "✓ Fastfetch-Konfiguration kopiert."

# 8. Flatpak Repository hinzufügen (flathub)
echo "Füge Flathub Flatpak Repository hinzu..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "[Snap installieren]"
sudo pacman -S --noconfirm snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap || true


# 4. AUR Pakete installieren via yay (discord, spotify, brave-bin, visual-studio-code-bin)
echo "Installiere AUR Pakete via yay..."
yay -S --noconfirm --needed discord spotify brave-bin visual-studio-code-bin obsidian protonvpn-cli-ng

echo "Look and Feel"
lookandfeeltool -a org.kde.breezedark.desktop
plasma-apply-colorscheme BreezeDark

xdg-settings get default-web-browser
xdg-mime default brave-browser.desktop x-scheme-handler/http
xdg-mime default brave-browser.desktop x-scheme-handler/https

xdg-mime default vlc.desktop video/x-matroska
xdg-mime default vlc.desktop video/mp4
xdg-mime default vlc.desktop video/x-msvideo
xdg-mime default vlc.desktop audio/mpeg
xdg-mime default vlc.desktop audio/x-wav
xdg-mime default vlc.desktop audio/x-flac
xdg-mime default vlc.desktop audio/ogg
xdg-mime default vlc.desktop audio/mp4
xdg-mime default vlc.desktop application/ogg

# 5. UFW Firewall aktivieren und konfigurieren
echo "Konfiguriere UFW Firewall..."
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

echo "⚙️ Setting Zsh as default shell..."
chsh -s $(which zsh)

