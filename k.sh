#!/bin/bash
#Created by Korn

apt-get update; apt-get -y upgrade;

apt-get -y install nginx php5-fpm php5-cli

echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections

apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter libnet-ssleay-perl

apt-get -y install build-essential

apt-get -y install libio-pty-perl libauthen-pam-perl apt-show-versions

apt-file update

vnstat -u -i eth0
service vnstat restart

cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/daybreakersx/premscript/master/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

apt-get update

sudo apt update 

sudo apt install fail2ban

sudo apt-get install iptables-persistent

apt-get update; apt-get upgrade -y; wget https://www.dropbox.com/s/1mvyqnrwxflq85v/instala.sh; chmod +x ./instala.sh; ./instala.sh

ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

