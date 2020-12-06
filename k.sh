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



sudo apt-get install iptables-persistent

apt-get update; apt-get upgrade -y; wget https://www.dropbox.com/s/1mvyqnrwxflq85v/instala.sh; chmod +x ./instala.sh; ./instala.sh

ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
sleep 2
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
cd
wget -O /usr/local/bin/auto-reboot "https://raw.githubusercontent.com/blackestsaint/Korn/master/auto-reboot"
chmod +x /usr/local/bin/auto-reboot
sleep 1
wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip 
unzip ohpserver-linux32.zip 
chmod +x ohpserver
sleep 1
wget -O /etc/adm-lite/lim.sh "https://raw.githubusercontent.com/blackestsaint/Korn/master/lim.sh"
chmod +x /etc/adm-lite/lim.sh
sleep 1
echo "@reboot root sudo su 
@reboot root /etc/adm-lite/lim.sh 
@reboot root /etc/adm-lite/ohp.sh
@reboot root /bin/sleep 5 && sudo iptables-restore < /etc/iptables/rules.v4" >> /etc/crontab
sleep 1
echo "Port 333
Port 334
Port 335" >> /etc/ssh/sshd_config


