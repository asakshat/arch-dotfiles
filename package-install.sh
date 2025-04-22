#!/bin/bash
set -e

sudo dnf update -y

packages=(
    ripgrep
    fzf
    zoxide
    zsh
    alacritty
)

flatpak_apps=(
    org.mozilla.firefox
    com.discordapp.Discord
    com.spotify.Client
    org.videolan.VLC
)

# 1. check if Flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak not found. Installing..."
    sudo dnf install -y flatpak
else
    echo "Flatpak is already installed."
fi

# 2. add Flathub repository
if ! flatpak remote-list | grep -q flathub; then
    echo "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo "Flathub repository already exists."
fi

# 3. remove default Firefox (RPM version)
echo "=== Removing default Fedora Firefox ==="
if rpm -q firefox &>/dev/null; then
    echo "[+] Removing Firefox RPM..."
    sudo dnf remove -y firefox
else
    echo "[✓] Firefox RPM already removed."
fi

# 4. install DNF packages
echo "=== Installing Packages (using dnf) ==="
for package in "${packages[@]}"; do
    sudo dnf install -y "$package"
done

# 5. install Flatpak apps
echo "=== Installing Flatpak apps ==="
for app in "${flatpak_apps[@]}"; do
    if flatpak list | grep -q "$app"; then
        echo "[✓] $app is already installed."
    else
        echo "[+] Installing $app..."
        sudo flatpak install -y flathub "$app"
    fi
done

# 6. load dconf settings for GNOME extensions
echo "=== Loading dconf for extensions ==="
dconf_file="$HOME/extensions-data.txt"
if [ -f "$dconf_file" ]; then 
    echo "Loading from: $dconf_file"
    dconf load /org/gnome/shell/extensions/ < "$dconf_file"
else 
    echo "No extension config found. Skipping."
fi

# most used shortcuts
# path to the keybindings file
KEYBINDINGS_FILE="wm-keybindings.txt"

# check if the file exists
if [ ! -f "$KEYBINDINGS_FILE" ]; then
    echo "Keybindings file ($KEYBINDINGS_FILE) not found! Exiting."
    exit 1
fi

# loop through each line of the file
while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)

    if [[ "$key" != /* ]]; then
        key="/$key"
    fi

    # convert the value to GVariant format (Array of Strings)
    value=$(echo "$value" | sed "s/\[\(.*\)\]/@as [\1]/g")

    echo "Setting: $key = $value"
    dconf write "$key" "$value"
done < "$KEYBINDINGS_FILE"

echo "Keybindings successfully set!"

echo "✅ Setup complete!"


