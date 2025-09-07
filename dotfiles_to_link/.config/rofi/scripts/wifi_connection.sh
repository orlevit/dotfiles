#!/bin/bash

# List available networks (filter out empty SSIDs)
SSID=$(nmcli -t -f SSID device wifi list | grep -v '^$' | sort -u | rofi -dmenu -i -p "Wi-Fi")

# If a network was selected
if [ -n "$SSID" ]; then
    # Ask for password (optional)
    PASSWORD=$(rofi -dmenu -password -p "Password for $SSID")
    
    # Connect to the network
    if [ -n "$PASSWORD" ]; then
        nmcli device wifi connect "$SSID" password "$PASSWORD"
    else
        nmcli device wifi connect "$SSID"
    fi
fi
