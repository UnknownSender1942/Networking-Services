#! /bin/bash

# display network configuration # 

show_network_config() {
    echo "Current Network Configuration : "
    ip addr show
    echo 
    echo "Routing Table : "
    ip route show
    echo
}

# restart networking services # 

restart_networking() {
    echo "Restarting Networking Services..."
    sudo systemctl restart networking
    echo "Networking Services Restarted!"
    echo
}

# flush the ip address from the interface #

flush_ip() {
    echo "Available Interfaces : "
    ip link show | grep -E '^[0-9]+:' | awk -F '{print $2}'
    echo
    read -p "Enter the Interface to Flush IP from (e.g., eno1) : " interface
    echo "Flushing IP Address from $interface..."
    sudo ip addr flush dev $interface
    echo "IP Address Flushed from $interface!"
    echo
}

# set a static ip address # 

set_static_ip() {
    echo "Available Interfaces : "
    ip link show | grep -E '^[0-9]+:' | awk -F '{print $2}'
    echo
    read -p "Enter the Interface to set Static IP on 9e.g., eno1) :" interface
    read -p "Enter the Static IP Address (e.g., 192.168.1.100) : " ip_address
    read -p "Enter the Netmask (e.g., 255.255.255.0) : " netmask
    read -p "Enter the gateway (e.g., 192.168.1.1) : " gateway

    echo "Setting Static IP Address on $interface..."
    sudo ip addr add $ip_address/$netmask dev $interface
    sudo ip route add default via $gateway
    echo "Static IP Address set on $interface!"
    echo
}

# change the mac address of the interface #

change_mac() {
    echo "Available Interfaces : "
    ip link show | grep -E '^[0-9]+:' | awk -F '{print $2}' 
    echo
    read -p "Enter the Interface to change MAC Address e.g., eno1) : " interface
    read -p "Enter the New MAC Address (e.g., 00:11:22:33:44:55) : " new_mac

    echo "Chnaging New MAC Address of $interface to $new_mac..."
    sudo ip link set dev $interface down
    sudo ip link set dev $interface address $new_mac
    sudo ip link set dev $interface up
    echo "MAC Address of $interface Changed to $new_mac!" 
    echo
}

##############

# main menu # 

##############

while true; do
    echo
    echo "Network Services"
    echo
    echo "1. Show Network Configuration"
    echo "2. Restart Networking Service"
    echo "3. Flush IP Address from Interface"
    echo "4. Set Static IP Address"
    echo "5. Change MAC Address"
    echo "6. Exit"
    read -p "Choose an Option (1-6): " choice

    case $choice in
    1) show_network_config ;;
    2) restart_networking ;;
    3) flush_ip ;;
    4) set_static_ip ;;
    5) change_mac ;;
    6) echo "Exiting..."; 
    break ;;
    *) echo "Invalid Option! Please try again!" ;;
        esac
done


