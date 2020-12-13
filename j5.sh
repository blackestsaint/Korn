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


# install squid
# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#update
apt-get clean && apt-get update && apt-get upgrade -y && apt-get --fix-missing install -y && apt-get autoremove -y

# install build tools
apt-get -y install \
    devscripts build-essential fakeroot \
    debhelper dh-autoreconf dh-apparmor cdbs ed net-tools

# install additional header packages for squid 4
apt-get -y install \
    libcppunit-dev \
    libsasl2-dev \
    libxml2-dev \
    libkrb5-dev \
    libdb-dev \
    libnetfilter-conntrack-dev \
    libexpat1-dev \
    libcap2-dev \
    libldap2-dev \
    libpam0g-dev \
    libgnutls28-dev \
    libssl-dev \
    libdbi-perl \
    libecap3 \
    libecap3-dev

# install build dependences for squid
apt-get -y build-dep squid
# set squid version
wget https://www.dropbox.com/s/9t51j6hoj70p918/squid.ver
source squid.ver
# decend into working directory
wget https://www.dropbox.com/s/vi7v2k1jwl3rxns/debian9_squid4.9.tar.gz
tar -xzvf debian9_squid4.9.tar.gz
pushd /root/root/build/

# get arch
ARCH="amd64"
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    ARCH="armhf"
fi

# install squid packages
apt-get install -y squid-langpack
dpkg --install squid-common_${SQUID_PKG}_all.deb
dpkg --install squid_${SQUID_PKG}_${ARCH}.deb
dpkg --install squidclient_${SQUID_PKG}_${ARCH}.deb
# and revert
popd
# put the squid on hold to prevent updating
apt-mark hold squid squidclient squid-common squid-langpack
# change the number of default file descriptors
OVERRIDE_DIR=/etc/systemd/system/squid.service.d
OVERRIDE_CNF=$OVERRIDE_DIR/override.conf

mkdir -p $OVERRIDE_DIR

# generate the override file
rm $OVERRIDE_CNF
echo "[Service]"         >> $OVERRIDE_CNF
echo "LimitNOFILE=65535" >> $OVERRIDE_CNF
# and reload the systemd
systemctl daemon-reload
systemctl enable squid
#setup squid.conf
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
cat > /etc/squid/squid.conf <<-END
cache_mem 200 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid3 100 16 256
access_log /var/log/squid3/access.log squid
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 61790
http_port 8000
http_port 3993
relaxed_header_parser off
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname Korn
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart
cd
sleep 1


# install dropbear
apt-get install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=9933/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 2109 -p 2110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
/etc/init.d/dropbear restart
cd
sleep 1


#add port and banner
sudo echo "Port 333" >> /etc/ssh/sshd_config
sudo echo "Port 334" >> /etc/ssh/sshd_config
sudo echo "Port 335" >> /etc/ssh/sshd_config
sudo echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sudo echo "DROPBEAR_BANNER="/etc/issue.net"" >> /etc/default/dropbear


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
echo "Server Information"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Manila (GMT +8)"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF] Type "sudo auto-reboot" to configure"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN     : OFF "  | tee -a log-install.txt
echo "   - Dropbear    : 9933, 2109, 2110"  | tee -a log-install.txt
echo "   - Squid Proxy : 61790, 8000, 3993 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Over-HTTP-Puncher for SSH : 8899 "  | tee -a log-install.txt

echo "   To display list of commands: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "   Explanation of scripts and VPS setup" | tee -a log-install.txt
echo "   follow this link: http://phcorner.net"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt

echo "WARNING: IN ADM MENU, DO NOT ACTIVATE OR ON: "  | tee -a log-install.txt
echo "   - 1. CONTROLS"  | tee -a log-install.txt
echo "   - 2. AUTO START"  | tee -a log-install.txt
echo "   - 3. DDoS"  | tee -a log-install.txt
echo "   - 4. FAIL2BAN"  | tee -a log-install.txt
echo "   - Installation Log        : cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------- Modified by blackestsaint and Korn ----------------"

