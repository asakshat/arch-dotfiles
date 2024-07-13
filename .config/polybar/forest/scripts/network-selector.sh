#!/bin/bash

# Path to the custom Rofi theme
rofi_theme="/home/retrosax/.config/polybar/forest/scripts/rofi/network-selector.rasi"

# Function to display available networks
list_networks() {
   nmcli -f SSID,SECURITY,SIGNAL dev wifi | grep -v "^--" | sed '/^$/d' | awk '{
    signal = $3;
    protected_very_high="󰤪"; 
    protected_high="󰤧";
    protected_medium="󰤤"; 
    protected_low="󰤡"; 
    unprotected_very_high="󰤨"; 
    unprotected_high="󰤥"; 
    unprotected_medium="󰤢"; 
    unprotected_low="󰤟"; 
    
    # Determine if the network is password-protected and its signal strength
    if($2 != "--" && $2 != "none") { # Protected network
        if(signal >= 90) icon=protected_very_high;
        else if(signal >= 75) icon=protected_high;
        else if(signal >= 50) icon=protected_medium;
        else icon=protected_low;
    } else { # Unprotected network
        if(signal >= 90) icon=unprotected_very_high;
        else if(signal >= 75) icon=unprotected_high;
        else if(signal >= 50) icon=unprotected_medium;
        else icon=unprotected_low;
    }
    
    printf "%-30s %s\n", $1, icon
   }'
}

# Function to list connection options for a selected network
network_options() {
    echo -e "Connect\nShow Password"
}

# Function to list options including disconnect if currently connected
network_options_connected() {
    echo -e "Disconnect\nShow Password"
}

# Get list of available WiFi networks
networks=$(list_networks)

# Get the currently connected network's SSID
connected_ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)

# Use Rofi to select a network
selected_network=$(echo "$networks" | rofi -dmenu -i -theme "$rofi_theme" -p "Select Network:")

# Extract the SSID from the selected network
ssid=$(echo "$selected_network" | awk '{print $1}')

if [ -n "$ssid" ]; then
    # List connection options based on connection status
    if [ "$ssid" = "$connected_ssid" ]; then
        action=$(network_options_connected | rofi -dmenu -i -theme "$rofi_theme" -p "Action for $ssid:")
    else
        action=$(network_options | rofi -dmenu -i -theme "$rofi_theme" -p "Action for $ssid:")
    fi

    case "$action" in
        "Connect")
            # Prompt for password
            password=$(rofi -dmenu -password -theme "$rofi_theme" -p "Password for $ssid:")
            # Connect to the selected network
            nmcli dev wifi connect "$ssid" password "$password"
            ;;
        "Disconnect")
            # Disconnect from the selected network
            nmcli connection down id "$ssid"
            ;;
        "Show Password")
            # Get the saved password for the selected network
            saved_password=$(nmcli -s -g 802-11-wireless-security.psk connection show "$ssid")
            # Display the saved password
            rofi -theme "$rofi_theme" -e "Password for $ssid: $saved_password"
            ;;
        *)
            echo "No valid action selected."
            ;;
    esac
else
    echo "No network selected."
fi
