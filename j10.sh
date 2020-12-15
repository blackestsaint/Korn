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

#caches
cd
cat > /etc/adm-lite/caches.sh <<END
echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3 > /dev/null 2>&1
rm -rf /tmp/*
END
sleep 1
chmod +x /etc/adm-lite/caches.sh


#ADM Limiter On after reboot
cd
wget -O /etc/adm-lite/lim.sh "https://raw.githubusercontent.com/blackestsaint/Korn/master/lim.sh"
chmod +x /etc/adm-lite/lim.sh
sleep 1

#Start Up Command v2 (crontab)
cd
echo "@reboot root /etc/adm-lite/lim.sh 
@reboot root /etc/adm-lite/ohp.sh
@reboot root /etc/adm-lite/caches.sh
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
cd
sleep 1

#experiment squid
#full update
apt-get clean && apt-get update && apt-get upgrade -y && apt-get full-upgrade -y && apt-get --fix-missing install -y && apt-get autoremove -y


# install build tools
apt-get -y install devscripts build-essential fakeroot cdbs debhelper dh-apparmor dh-autoreconf

# install additional packages for new squid
apt-get -y install \
    libsasl2-dev \
    libxml2-dev \
    libdb-dev \
    libkrb5-dev \
    nettle-dev \
    libnetfilter-conntrack-dev \
    libpam0g-dev \
    libldap2-dev \
    libcppunit-dev \
    libexpat1-dev \
    libcap2-dev \
    libltdl-dev \
    libssl-dev \
    libdbi-perl
	
	
#Build eCAP 3 Library
#set ecap version
wget https://www.dropbox.com/s/vx5zpjmdvq0u18b/ecap.ver
source ecap.ver

# drop ecap build folder
rm -R build/libecap

# we will be working in a subfolder make it
mkdir -p build/libecap

# decend into working directory
pushd build/libecap

# get libecap from debian stretch
wget http://http.debian.net/debian/pool/main/libe/libecap/libecap_${ECAP_PKG}.dsc
wget http://http.debian.net/debian/pool/main/libe/libecap/libecap_${ECAP_VER}.orig.tar.gz
wget http://http.debian.net/debian/pool/main/libe/libecap/libecap_${ECAP_PKG}.debian.tar.xz

# unpack the source package
dpkg-source -x libecap_${ECAP_PKG}.dsc

# build the package
cd libecap-${ECAP_VER} && dpkg-buildpackage -rfakeroot -b

# and revert
popd

#install ecap build
#set ecap version
source ecap.ver

# decend into working directory
pushd build/libecap

# install ecap packages
dpkg --install libecap3_${ECAP_PKG}_amd64.deb
dpkg --install libecap3-dev_${ECAP_PKG}_amd64.deb
# and revert
popd

# set squid version
wget https://www.dropbox.com/s/9t51j6hoj70p918/squid.ver
source squid.ver

# decend into working directory
mkdir -p build/squid
pushd build/squid
wget https://www.dropbox.com/s/hgey8q2sbexhbqg/ubuntu16_squid4.9.tar.gz
tar -xzvf ubuntu16_squid4.9.tar.gz

# install squid packages
apt-get install -y squid-langpack
dpkg --install squid-common_${SQUID_PKG}_all.deb
dpkg --install squid_${SQUID_PKG}_amd64.deb
dpkg --install squidclient_${SQUID_PKG}_amd64.deb
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
http_port 8008

acl localnet src 0.0.0.1-0.255.255.255  # RFC 1122 "this" network (LAN)
acl localnet src 10.0.0.0/8             # RFC 1918 local private network (LAN)
acl localnet src 100.64.0.0/10          # RFC 6598 shared address space (CGN)
acl localnet src 169.254.0.0/16         # RFC 3927 link-local (directly plugged) machines
acl localnet src 172.16.0.0/12          # RFC 1918 local private network (LAN)
acl localnet src 192.168.0.0/16         # RFC 1918 local private network (LAN)
acl localnet src fc00::/7               # RFC 4193 local private network range
acl localnet src fe80::/10              # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http

acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH

http_access allow localhost manager
http_access deny manager
http_access allow localnet
http_access allow localhost
http_access deny all

coredump_dir /squid/var/cache/squid

refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
visible_hostname tacome9
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart

rm -R /root/build
rm -R /root/*.gz



# install badvpn
cd
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


#TCP SPEED ON
echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf

#webmin
wget "https://sourceforge.net/projects/webadmin/files/webmin/1.881/webmin_1.881_all.deb"
dpkg --install webmin_1.881_all.deb"
apt-get -y -f install
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.881_all.deb > /dev/null 2>&1
service webmin restart 

# setting vnstat
vnstat -u -i eth0
service vnstat restart


#banner
sleep 2
cd
cat > /etc/issue.net <<END
<br><font>
<br><font>
<br><font color='green'> <b>░▒▓█ gωαρσиg ℓαи∂єя νρи █▓▒░</b> </br></font>
<br><font>
<br><font color='#32CD32'>: : : ★  TEST SERVER </br></font>
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


# fix bugs
cd
sleep 1
fix2


clear
echo " "
echo "Installation has been completed!!" | lolcat
echo " "
echo ""
echo "--------------------------- Configuration Setup Server -------------------------" | lolcat
echo "                         Credits to: ADM-MANAGER                          " | lolcat
echo "                        Modified by Gwapong Lander                      " | lolcat
echo "--------------------------------------------------------------------------------" | lolcat

echo ""
echo "Server Information: " | tee -a log-install.txt | lolcat
echo "   • Timezone: Asia/Manila (GMT +8)" | tee -a log-install.txt | lolcat
echo "   • Server Auto-Reboot: [OFF] Go to menu to configure" | tee -a log-install.txt | lolcat
echo "   • IPv6 : [OFF]" | tee -a log-install.txt | lolcat
echo "   • Webmin : ON" | tee -a log-install.txt | lolcat
echo "   • TCP tweak for Speed : ON" | tee -a log-install.txt | lolcat
echo "   • Multi-login Auto Disconnect : ON " | tee -a log-install.txt | lolcat
echo "   • Server Auto Clear Cache : ON | Every restart" | tee -a log-install.txt | lolcat
echo ""
echo "Application & Port Information:" | tee -a log-install.txt | lolcat
echo "   • OpenVPN     : OFF " | tee -a log-install.txt | lolcat
echo "   • Dropbear    : ON :  9933 | 9870 |2110" | tee -a log-install.txt | lolcat
echo "   • Squid Proxy : ON: 61790 | 8000 |3993 | limit to IP Server" | tee -a log-install.txt | lolcat
echo "   • Privoxy         : ON:  7190 | 2256 | limit to IP Server" | tee -a log-install.txt | lolcat
echo "   • OHP             : ON: 8899 | 8898 | Auto Reconnect [OFF] " | tee -a log-install.txt | lolcat
echo "   • OHP             : ON: 7799 | 7798 | Auto Reconnect [ON]" | tee -a log-install.txt | lolcat
echo "   • BADVPN       : ON: 7300 " | tee -a log-install.txt | lolcat
echo ""
echo "Notes:" | tee -a log-install.txt | lolcat
echo "   • To display list of commands: " menu "" | tee -a log-install.txt | lolcat
echo "   • Privoxy auto reconnect every 57 seconds. " | tee -a log-install.txt | lolcat
echo "   • For Globe No Load, use OHP Port. " | tee -a log-install.txt | lolcat
echo "   • Payload for Globe using OHP? same payload with SocksIP." | tee -a log-install.txt | lolcat
echo "   • This is modified ADM-MANAGER-ULTIMATE-FREE." | tee -a log-install.txt | lolcat
echo ""
echo "   • Other concern and questions of these auto-scripts?" | tee -a log-install.txt | lolcat
echo "      Direct Messege : www.facebook.com/kornips" | tee -a log-install.txt | lolcat
echo ""
