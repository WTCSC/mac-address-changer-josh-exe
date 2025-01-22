#!/bin/bash

[ "$EUID" -ne 0 ] && echo "Run as root." && exit 1 #------------------------------------------------------------------------------  Check if the script is run as root
[ "$#" -ne 2 ] && echo "Usage: $0 <interface> <new_mac>" && exit 1 #--------------------------------------------------------------  Checks the number of arguments

INTERFACE=$1 #-------/------------------------------------------------------------------------------------------------------------  Assigns arguments to variables
NEW_MAC=$2   #------/

[[ ! $NEW_MAC =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]] && echo "Invalid MAC address format." && exit 1 #------------------------  Validates the MAC address format

ip link show "$INTERFACE" &>/dev/null || { echo "Interface $INTERFACE does not exist."; exit 1; } #-------------------------------  Checks if the network interface exists

ip link set "$INTERFACE" down #---------------------------------------------------------------------------------------------------  Brings the network interface down

ip link set "$INTERFACE" address "$NEW_MAC" || { echo "Failed to set MAC address."; ip link set "$INTERFACE" up; exit 1; } #---|--  Attempts to set the new MAC address,
#                                                                                                                              |    handles failure, and brings the network
#                                                                                                                              \--  interface back up upon failure

ip link set "$INTERFACE" up #-----------------------------------------------------------------------------------------------------  Brings the network interface back up

echo "MAC address changed to $(cat /sys/class/net/$INTERFACE/address)" #----------------------------------------------------------  Confirms the change