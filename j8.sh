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

# Fix 1
wget -O /usr/local/bin/fix "https://raw.githubusercontent.com/blackestsaint/Korn/master/fix"
chmod +x /usr/local/bin/fix
sleep 1

# Fix 2
wget -O /usr/local/bin/fix2 "https://raw.githubusercontent.com/blackestsaint/Korn/master/fix2"
chmod +x /usr/local/bin/fix2
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
screen -dm bash -c "./ohpserver -port 8899 -proxy $MYIP:61790 -tunnel $MYIP:22"
screen -dm bash -c "./ohpserver -port 8898 -proxy $MYIP:3993 -tunnel $MYIP:333"
screen -dm bash -c "./ohpserver -port 7799 -proxy $MYIP:7190 -tunnel $MYIP:22"
screen -dm bash -c "./ohpserver -port 7798 -proxy $MYIP:2256 -tunnel $MYIP:333"
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

# modified installation menu_inst
cd
wget -O /etc/adm-lite/menu_inst "https://raw.githubusercontent.com/blackestsaint/Korn/master/menu_inst"
chmod +x /etc/adm-lite/menu_inst
sleep 1

# modified menu
cd
wget -O /etc/adm-lite/menu "https://raw.githubusercontent.com/blackestsaint/Korn/master/menu"
chmod +x /etc/adm-lite/lmenu
sleep 1

# modified menu text
cd
wget -O /etc/adm-lite/menu-txt "https://raw.githubusercontent.com/blackestsaint/Korn/master/menu-txt"
chmod +x /etc/adm-lite/menu-txt
sleep 1

# modified cabecalho
cd
wget -O /etc/adm-lite/cabecalho "https://raw.githubusercontent.com/blackestsaint/Korn/master/cabecalho"
chmod +x /etc/adm-lite/cabecalho
sleep 1

# modified user
cd
wget -O /etc/adm-lite/user "https://raw.githubusercontent.com/blackestsaint/Korn/master/user"
chmod +x /etc/adm-lite/user
sleep 1

# modified user-txt
cd
wget -O /etc/adm-lite/user-txt "https://raw.githubusercontent.com/blackestsaint/Korn/master/user-txt"
chmod +x /etc/adm-lite/user-txt
sleep 1


#privoxy
apt-get update -y && apt-get upgrade -y && apt autoclean -y && apt autoremove
apt-get install privoxy
cat > /etc/privoxy/config <<-END
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address 0.0.0.0:7190
listen-address 0.0.0.0:2256
toggle  1
enable-remote-toggle  0
enable-remote-http-toggle  0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 1
forwarded-connect-retries  1
accept-intercepted-requests 1
allow-cgi-request-crunching 1
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
permit-access 0.0.0.0/0 $MYIP
END

#loli 
cd
sleep 1
apt-get install ruby
wget https://github.com/busyloop/lolcat/archive/master.zip
unzip master.zip
cd lolcat-master/bin
gem install lolcat


#experiment squid
apt-get install -y wget && wget https://www.dropbox.com/s/lh6kvwj0860elgt/install_ubnt16x64_modsquid4.9-2.sh && chmod +x install_ubnt16x64_modsquid4.9-2.sh && ./install_ubnt16x64_modsquid4.9-2.sh


# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/daybreakersx/premscript/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/daybreakersx/premscript/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300


# install dropbear
apt-get install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=9933/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
/etc/init.d/dropbear restart

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





# fix
sudo fix



clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "--------------------------- Configuration Setup Server -------------------------"
echo "                         Credits to: ADM-MANAGER                          "
echo "                        Modified by Gwapong Lander                      "
echo "--------------------------------------------------------------------------------"
echo ""  | tee -a log-install.txt


echo ""  | tee -a log-install.txt
echo "Server Information"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Manila (GMT +8)"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF] Type "sudo auto-reboot" to configure"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN     : OFF "  | tee -a log-install.txt
echo "   - Dropbear    :  OFF : 9933, 9870, 2110"  | tee -a log-install.txt
echo "   - Squid Proxy :  OFF: 61790, 8000, 3993 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Over-HTTP-Puncher for SSH : 8899,8899,7799,7798 "  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo " - Note: Squid and Dropbear Port are fixed. (Cannot be change)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "OHP: For Advance User: "  | tee -a log-install.txt
echo "- OHP Port: 8899= Squid Port: 61790 |SSHD Port:22"  | tee -a log-install.txt
echo "- OHP Port: 8898= Squid Port: 3993 |SSHD Port:333"  | tee -a log-install.txt
echo "- OHP Port: 7799= Privoxy Port: 7190 |SSHD Port:22"  | tee -a log-install.txt
echo "- OHP Port: 7798= Privoxy Port: 2256 |SSHD Port:333"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "   To display list of commands: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "   To read this again type this: cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "   Explanation of scripts and VPS setup" | tee -a log-install.txt
echo "   Direct Messege me at www.facebook.com/kornips"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "----------- Modified by Gwapong Lander ----------------"

