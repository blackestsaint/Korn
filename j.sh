#!/bin/bash
#Created by Korn

#for IP replacement
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";
sleep 1

#Essential needs
apt-get update; apt-get -y upgrade;
apt-get -y install nginx php5-fpm php5-cli
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections

apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter libnet-ssleay-perl

apt-get -y install build-essential
apt-get -y install libio-pty-perl libauthen-pam-perl apt-show-versions
apt-file update
vnstat -u -i eth0
service vnstat restart

#Screen Design
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/blackestsaint/Korn/master/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

#iptables (lander)
apt-get update
sudo apt update 
sudo apt-get install iptables-persistent

#ADM-Free Framework
apt-get update; apt-get upgrade -y; wget https://raw.githubusercontent.com/blackestsaint/Korn/master/instala.sh; chmod +x ./instala.sh; ./instala.sh

#Time Zone
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
sleep 2

#Startup Command 
cat > /etc/rc.local <<END
#!/bin/bash
/bin/sleep 30 && sudo su
/bin/sleep 30 && chmod +x /etc/adm-lite/limiter.sh &
   /etc/adm-lite/limiter.sh &
   screen -dmS Limiter-ssh /etc/adm-lite/limiter.sh
exit 0
END
sleep 3
chmod +x /etc/init.d/rc.local
sudo systemctl enable rc-local.service
sleep 1

#Auto Reboot Script
cd
wget -O /usr/local/bin/auto-reboot "https://raw.githubusercontent.com/blackestsaint/Korn/master/auto-reboot"
chmod +x /usr/local/bin/auto-reboot
sleep 1

#OHP Over-HTTP-Puncher
cd
wget https://github.com/blackestsaint/Korn/blob/master/ohpserver-linux32.zip
 unzip ohpserver-linux32.zip 
chmod +x ohpserver
sleep 1

#OHP Set-UP
cd
cat > /etc/adm-lite/ohp.sh <<END
#!/bin/bash
sleep 5
sudo su
screen -dm bash -c "./ohpserver -port 8899 -proxy $MYIP:61790 -tunnel $MYIP:333"
END
chmod +x /etc/adm-lite/ohp.sh

#ADM Limiter On after reboot
cd
wget -O /etc/adm-lite/lim.sh "https://raw.githubusercontent.com/blackestsaint/Korn/master/lim.sh"
chmod +x /etc/adm-lite/lim.sh
sleep 1

#Start Up Command v2
cd
echo "@reboot root sudo su 
@reboot root /etc/adm-lite/lim.sh 
@reboot root /etc/adm-lite/ohp.sh
@reboot root /bin/sleep 5 && sudo iptables-restore < /etc/iptables/rules.v4" >> /etc/crontab
sleep 2

#clear all message in screen
clear

#END of Installation
echo -e""
echo -e""
echo -e " End of Installation | Created by Gwapong Lander "
echo -e""
echo -e"Next Step:"
echo -e"(Menu:9) Install Dropbear, Squid, SSL, Openvpn"
echo -e"(Menu:2) Install TCP Speed and Squid Cache and T
echo -e"(Menu:1) Install Banner
echo -e""

