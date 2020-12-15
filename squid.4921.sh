#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#full update
apt-get clean && apt-get update && apt-get upgrade -y && apt-get full-upgrade -y && apt-get --fix-missing install -y && apt-get autoremove -y

# initializing var
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";


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

