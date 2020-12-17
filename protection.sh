#!/bin/bash
# Original Script by Usnekx
# Created by 0123456
# Add new torrent ports by Gwapong Lander

# Bruteforce Protection
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set 
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP  

# Protection Port Scanning
iptables -N port-scanning 
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN 
iptables -A port-scanning -j DROP

# Anti-Torrent Blocking

iptables -A OUTPUT -p tcp -m multiport --dports 25,26,465,587 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable

iptables -A OUTPUT -p udp -m multiport --dports 25,26,465,587 -j DROP

iptables -A OUTPUT -p tcp -m multiport --dports 109,110,995 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable

iptables -A OUTPUT -p udp -m multiport --dports 109,110,995 -j DROP

iptables -A OUTPUT -p tcp -m multiport --dports 143,218,220,993 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable

iptables -A OUTPUT -p udp -m multiport --dports 143,218,220,993 -j DROP

iptables -A OUTPUT -p tcp -m multiport --dports 24,50,57,105,106,158,209,1109,24554,60177,60179 -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable

iptables -A OUTPUT -p udp -m multiport --dports 24,50,57,105,106,158,209,1109,24554,60177,60179 -j DROP

iptables -A INPUT -m string --algo bm --string "BitTorrent" -j REJECT
iptables -A INPUT -m string --algo bm --string "BitTorrent protocol" -j REJECT
iptables -A INPUT -m string --algo bm --string "peer_id=" -j REJECT
iptables -A INPUT -m string --algo bm --string ".torrent" -j REJECT
iptables -A INPUT -m string --algo bm --string "announce.php?passkey=" -j REJECT
iptables -A INPUT -m string --algo bm --string "torrent" -j REJECT
iptables -A INPUT -m string --algo bm --string "info_hash" -j REJECT
iptables -A INPUT -m string --algo bm --string "/default.ida?" -j REJECT
iptables -A INPUT -m string --algo bm --string ".exe?/c+dir" -j REJECT
iptables -A INPUT -m string --algo bm --string ".exe?/c_tftp" -j REJECT
iptables -A INPUT -m string --string "peer_id" --algo kmp -j REJECT
iptables -A INPUT -m string --string "BitTorrent" --algo kmp -j REJECT
iptables -A INPUT -m string --string "BitTorrent protocol" --algo kmp -j REJECT
iptables -A INPUT -m string --string "bittorrent-announce" --algo kmp -j REJECT
iptables -A INPUT -m string --string "announce.php?passkey=" --algo kmp -j REJECT
iptables -A INPUT -m string --string "find_node" --algo kmp -j REJECT
iptables -A INPUT -m string --string "info_hash" --algo kmp -j REJECT
iptables -A INPUT -m string --string "get_peers" --algo kmp -j REJECT
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j REJECT
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j REJECT
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j REJECT
iptables -A FORWARD -m string --algo bm --string ".torrent" -j REJECT
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j REJECT
iptables -A FORWARD -m string --algo bm --string "torrent" -j REJECT
iptables -A FORWARD -m string --algo bm --string "info_hash" -j REJECT
iptables -A FORWARD -m string --algo bm --string "/default.ida?" -j REJECT
iptables -A FORWARD -m string --algo bm --string ".exe?/c+dir" -j REJECT
iptables -A FORWARD -m string --algo bm --string ".exe?/c_tftp" -j REJECT
iptables -A FORWARD -m string --string "peer_id" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "BitTorrent" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "BitTorrent protocol" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "bittorrent-announce" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "announce.php?passkey=" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "find_node" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "info_hash" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "get_peers" --algo kmp -j REJECT
iptables -A OUTPUT -m string --algo bm --string "BitTorrent" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "BitTorrent protocol" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "peer_id=" -j REJECT
iptables -A OUTPUT -m string --algo bm --string ".torrent" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "announce.php?passkey=" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "torrent" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "info_hash" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "/default.ida?" -j REJECT
iptables -A OUTPUT -m string --algo bm --string ".exe?/c+dir" -j REJECT
iptables -A OUTPUT -m string --algo bm --string ".exe?/c_tftp" -j REJECT
iptables -A OUTPUT -m string --string "peer_id" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "BitTorrent" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "BitTorrent protocol" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "bittorrent-announce" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "announce.php?passkey=" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "find_node" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "info_hash" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "get_peers" --algo kmp -j REJECT
iptables -A INPUT -p tcp --dport 25 -j REJECT   
iptables -A FORWARD -p tcp --dport 25 -j REJECT 
iptables -A OUTPUT -p tcp --dport 25 -j REJECT 

rm -f /root/AntiAbuse.sh

clear
echo "Anti-Abuse Succesfully Installed!"
echo " "
echo "Features:"
echo "Bruteforce Protection"
echo "Port Scanning Protection"
echo "Torrent Blocking"
echo "Torrent newest Port block"
echo " "
echo "Original Script by Usnekx"
echo "Created by 0123456"
echo "Add new torrent ports by Gwapong Lander"
echo " "
