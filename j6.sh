#!/bin/bash
#Created by Korn

# initializing var
OS=`uname -m`;
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

#iptables 
apt-get update
sudo apt update 
sudo apt-get install iptables-persistent


#ADM-Free Framework
apt-get update; apt-get upgrade -y; wget https://raw.githubusercontent.com/blackestsaint/Korn/master/instala.sh; chmod +x ./instala.sh; ./instala.sh

#Time Zone
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
sleep 1

#Startup Command (rc.local)
cd
cat > /etc/rc.local <<END
#!/bin/sh -e
sudo su
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

#Enhance Squid and Fix Dropbear
wget -O /usr/local/bin/fix "https://raw.githubusercontent.com/blackestsaint/Korn/master/fix"
chmod +x /usr/local/bin/fix
sleep 1

#OHP Over-HTTP-Puncher
cd
wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip 
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
sleep 1
chmod +x /etc/adm-lite/ohp.sh

#ADM Limiter On after reboot
cd
wget -O /etc/adm-lite/lim.sh "https://raw.githubusercontent.com/blackestsaint/Korn/master/lim.sh"
chmod +x /etc/adm-lite/lim.sh
sleep 1

#Start Up Command v2 (crontab)
cd
echo "@reboot root /etc/adm-lite/lim.sh 
@reboot root /etc/adm-lite/ohp.sh
@reboot root /bin/sleep 5 && sudo iptables-restore < /etc/iptables/rules.v4" >> /etc/crontab
sleep 1

#Translate to English 1
cd
wget -O /etc/adm-lite/idioma "https://raw.githubusercontent.com/blackestsaint/Korn/master/idioma"
chmod +x /etc/adm-lite/idioma
 sleep 1

#Translate to English 2
cd
wget -O /etc/adm-lite/idioma_geral "https://raw.githubusercontent.com/blackestsaint/Korn/master/idioma_geral"
chmod +x /etc/adm-lite/idioma_geral
sleep 1
cd


#add port and banner
sudo echo "Port 333" >> /etc/ssh/sshd_config
sudo echo "Port 334" >> /etc/ssh/sshd_config
sudo echo "Port 335" >> /etc/ssh/sshd_config
sudo echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config


#banner
sleep 2
cd
cat > /etc/issue.net <<END
<br><font>
<br><font>
<br><font color='green'> <b>░▒▓█ gωαρσиg ℓαи∂єя νρи █▓▒░</b> </br></font>
<br><font>
<br><font color='#32CD32'>: : : ★ LUNOX SERVER </br></font>
<br><font color='#32CD32'>: : : ★ NOT RECOMMENDED FOR GAMING</br></font>
<br><font color='#FDD017'>: : : ★ EXCLUSIVE FOR ADMIN ONLY</br></font>
<br><font>
<br><font color='#32CD32'>: : : ★ STRICTLY NO ACCOUNT SHARING</br></font>
<br><font color='#32CD32'>: : : ★ STRICTLY NO MULTI-LOGIN</br></font>
<br><font color='#32CD32'>: : : ★ STRICTLY NO TORRENT</br></font>
<br><font>
<br><font color='#FF00FF'>░▒▓█ VIOLATORS WILL BE BAN!!!</br></font>
<br><font>
<br><font>
END


# info
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "--------------------------- Configuration Setup Server -------------------------"
echo "                         Credits to: ADM-MANAGER                          "
echo "                        and to HostingTermurah.net                         "
echo "                   Special Thanks to Gwapong Lander                  "
echo "                   Modified by blackestsaint and Korn                   "
echo "--------------------------------------------------------------------------------"
echo ""  | tee -a log-install.txt
echo "Second Phase of Installation"  | tee -a log-install.txt
echo "1. Type "menu" and press "9" (install Dropbear and Squid)"  | tee -a log-install.txt
echo "2. Type "fix".These for fixing bugs "  | tee -a log-install.txt
echo "3. Type "auto-reboot" and set your desire schedule of rebooting VPS."  | tee -a log-install.txt
echo "After finish all 3steps above, reboot your VPS. Type "sudo reboot" "  | tee -a log-install.txt

echo ""  | tee -a log-install.txt
echo "Server Information"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Manila (GMT +8)"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF] Type "sudo auto-reboot" to configure"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN     : OFF "  | tee -a log-install.txt
echo "   - Dropbear    : 9933, 9870, 2110"  | tee -a log-install.txt
echo "   - Squid Proxy : 61790, 8000, 3993 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Over-HTTP-Puncher for SSH : 8899 "  | tee -a log-install.txt

echo "   To display list of commands: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "   To read this again type this: cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "   Explanation of scripts and VPS setup" | tee -a log-install.txt
echo "   follow this link: http://phcorner.net"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "WARNING: IN ADM MENU, DO NOT ACTIVATE OR ON: "  | tee -a log-install.txt
echo "   - 1. CONTROLS"  | tee -a log-install.txt
echo "   - 2. AUTO START"  | tee -a log-install.txt
echo "   - 3. DDoS"  | tee -a log-install.txt
echo "   - 4. FAIL2BAN"  | tee -a log-install.txt

echo "----------- Modified by blackestsaint and Korn ----------------"

