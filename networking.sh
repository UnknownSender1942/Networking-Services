#! /bin/bash

sudo apt install lolcat -y

# display network configuration # 

show_network_config() {
    echo
    echo "Current Network Configuration : " | lolcat
    echo
    ip addr show
    echo 
    echo "Routing Table : " | lolcat
    ip route show
    echo
}

# restart networking services # 

restart_networking() {
    echo
    echo "Restarting Networking Services!" | lolcat
    echo
    sudo systemctl restart networking
    echo
    echo "Networking Services Restarted!" | lolcat
    echo
}

# flush the ip address from the interface #

flush_ip() {
    echo
    echo "Available Interfaces : " | lolcat
    echo
    ip link show | grep -E '^[0-9]+:' | awk -F '{print $2}'
    echo
    read -p "Enter the Interface to Flush IP from (e.g., eno1) : " interface
    echo
    echo "Flushing IP Address from $interface..."
    echo
    sudo ip addr flush dev $interface
    echo
    echo "IP Address Flushed from $interface!"
    echo
}

# set a static ip address # 

set_static_ip() {
    echo
    echo "Available Interfaces : " | lolcat
    ip link show | grep -E '^[0-9]+:' | awk -F '{print $2}'
    echo
    read -p "Enter the Interface to set Static IP on 9e.g., eno1) :" interface
    echo
    read -p "Enter the Static IP Address (e.g., 192.168.1.100) : " ip_address
    echo
    read -p "Enter the Netmask (e.g., 255.255.255.0) : " netmask
    echo
    read -p "Enter the gateway (e.g., 192.168.1.1) : " gateway
    echo
    echo "Setting Static IP Address on $interface..."
    echo
    sudo ip addr add $ip_address/$netmask dev $interface
    echo
    sudo ip route add default via $gateway
    echo
    echo "Static IP Address set on $interface!"
    echo
}

# change the mac address of the interface #

change_mac() {
    echo
    echo "Available Interfaces : " | lolcat
    ip link show | grep -E '^[0-9]+:' | awk -F '{print $2}' 
    echo
    read -p "Enter the Interface to change MAC Address e.g., eno1) : " interface
    echo
    read -p "Enter the New MAC Address (e.g., 00:11:22:33:44:55) : " new_mac
    echo
    echo "Chnaging New MAC Address of $interface to $new_mac..."
    echo
    sudo ip link set dev $interface down
    echo
    sudo ip link set dev $interface address $new_mac
    echo
    sudo ip link set dev $interface up
    echo
    echo "MAC Address of $interface Changed to $new_mac!" 
    echo
}

##############

# main menu # 

##############

while true; do
    echo
    echo "Network Services" | lolcat
    echo "----------------"
    echo
    echo "1. Show Network Configuration"
    echo
    echo "2. Restart Networking Service"
    echo
    echo "3. Flush IP Address from Interface"
    echo
    echo "4. Set Static IP Address"
    echo
    echo "5. Change MAC Address"
    echo
    echo "6. Exit"
    echo
    read -p "Choose an Option (1-6): " choice
    echo
    case $choice in
    1) show_network_config ;;
    2) restart_networking ;;
    3) flush_ip ;;
    4) set_static_ip ;;
    5) change_mac ;;
    6) echo "Exiting..."; 
    echo
    break ;;
    *) echo "Invalid Option! Please try again!" ;;
        esac
done


 