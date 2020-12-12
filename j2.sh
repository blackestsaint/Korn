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

#iptables 
apt-get update
sudo apt update 
sudo apt-get install iptables-persistent


#ADM-Free Framework
apt-get update; apt-get upgrade -y; wget https://raw.githubusercontent.com/blackestsaint/Korn/master/instala.sh; chmod +x ./instala.sh; ./instala.sh

#Time Zone
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
sleep 2

#Startup Command (rc.local)
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
sleep 2

#Translate to English 1
cd
cat > /etc/adm-lite/idioma <<END
Gwapong Lander
 ONLINE:
 EXPIRED:
 HIS SYSTEM:
 WELCOME TO THE MENU!
 MANAGE USERS
 TOOLS
 TO UPDATE
 REMOVE Korn Server
 OPTION:
 [ON]
 [OFF]
 CHANGE MENU COLORS
 [BACK / EXIT]
 USERS MENU
 CREATE USERS
 REMOVE USERS
 MODIFY USERS
 USER DETAILS
 VERIFY ONLINE USERS
 CONTROLS
 YOUR CURRENTLY USED COLORS
 Choose in order, 1 2 3 4 5 6
 What is the color sequence ?:
 Six colors have not been selected!
 Applying the selected color!  ...
 CHANGE LANGUAGE
 Korn Server USER CREATOR
 Name of the new user:
 Null name
 Existing user!
 Password for user
 Duration for the User
 Connection limit for user
 User:
 Password:
 Limit:
 Validity:
 LIST OF REGISTERED USERS
 REMOVE USERS
 Delete 1 User
 Delete all users
 Select user or type name
 No user has been selected
 User does not exist!
 removed
 remove
 Enter, to return!
 USER EDITOR
 No user has selected
 Which option are you going to edit from:
 Number of logins of:
 Expiration date of:
 Change password for:
 What is the new login limit:
 Limit not changed!
 Limit changed
 How many days should it last?
 Unchanged date
 Changed!
 What is the new password for:
 Password not changed!
 New password applied
 No option selected!
 User
 Password
 Limit
 Weather
 ??
 Unlimited
 Timed out
 You've got:
 Users on your server
 days
 USERS
 CONNECTION
 WEATHER
 That Tool Will Translate
 Brought you by Gwapong Lander
 Select the language number, or use the initials of the language.

 Translating the system ...
 Enter a language:
 hours
 minutes
 use
 There is no user online
 DELETE EXPIRED USERS
 No Expired Users!
 TOOLS MENU
 CREATE BACKUP
 RESTORE BACKUP
 CLEAR CACHE
 BAD UDP
 TCP SPEED
 FAILBAN
 SQUID CACHE
 SHARE ONLINE FILE
 Enter only numeric values
 STARTING BACKUP
 User Backup
 User not registered in Korn Server
 Enter the user information.
 Current password:
 Duration Days:
 Connection limit:
 Full backup
 Back UDP available in folder
 Enter the backup directory
 or Enter a link for a backup
 File or link
 Invalid file or link!
 Backup incompatible with Korn Server
 Restoration ...
 User not restored
 This Tool will Clear Caches
 and delete temporary files
 Procedure completed
 BADVPN will install
 which is nothing more than a program
 which frees UDP ports on the server
 and thus enable the VOIP service!
 Start
 BADVPN started successfully
 Stopping BADVPN service ...
 BADVPN stopped successfully
 This Script was projected
 To Improve Latency
 and server speed!
 analyze
 This is an experimental script
 Use at your own risk and expense!
 This script will change some
 network settings
 of the system to reduce
 latency and improve speed
 Continue with the installation?
 Network Configuration
 have been added successfully
 have already been added in the system!
 You want to remove the settings
 Network Configuration
 have been successfully removed
 Why not?
 uninstall
 View record
 This is FAILBAN PROTECTION
 Made solely to protect the safety of the
 System, your goal is to analyze
 ACCESS LOGS and block all
 suspicious action
 increasing by 70% of its security.
 Do you want to install Fail2Ban?
 Fail2ban Will Be Installed
 Next Services
 Do you confirm the choice?
 Installation completed
 Squid cache is nothing but
 A browsing history in Squid
 That will save data when opening sites
 Hosted in your cache
 The script will do a short check!
 Squid not identified!
 Squid is Active on your system!
 There is no cache service on the Squid!
 Restarting Services Wait!
 Activating the SquidCache service!
 Disabling SquidCache !!
 wait!
 PLACE FILE ONLINE
 OPTION TO PLACE
 ANY ONLINE FILE
 WHAT THIS FILE
 IN THE ADDRESS BOOK
 REMOVE ONLINE FILE
 SEE MY FILES ONLINE
 Invalid option
 Select a file
 No file has been selected
 Procedure Done Successfully
 ACCESS TO THE FILE THROUGH THE LINK
 Your files in the folder
 TEST YOUR SPEED
 VPS INFORMATION
 Test start, please wait ...
 Ping response time
 Loading speed
 Download speed
 Error processing information
 His system
 based
 Physical Processor
 Operating frequency
 Processor usage
 Total Virtual Memory
 Virtual Memory In use
 Free Virtual Memory
 Virtual Memory Swap
 Online time
 Machine name
 Machine Direction
 Kernel versions
 Architecture
 analyze
 proceedings
 updated
 Updated files
 Valid!  Updating ...
 Expired or invalid Exiting!
 Are you sure about this?
 Uninstall canceled by user
 Created by @iSrDiiabloNS
 ADD / REMOVE HOST-SQUID
 not found
 Or Squid not installed
 Add Host to Squid
 Remove host from Squid
 Invalid Option
 Current domains on file
 Enter the Host-Squid you want to add
 Starting with a., Example: .bughost.com
 It's empty, you haven't written anything!
 Domain already exists in file
 Success, File Updated!
 Enter the domain you want to remove
 domain not found
 Enter the text for the BANNER
 green
 Red
 blue
 yellow
 purple
 Enter the main message
 Want to Add More Texts
 COLORFUL BANNER
 Dependencies Not Installed, Do you want to install?
 Installing dependencies for proxy-socks ...
 Stopping proxy-sock ...
 Proxy-sock stopped!
 Select the port to rotate
 Your Proxy Sockets:
 Opa, is being used by:
 Disable this service to use
 Port:
 For the SOCKS
 Enter, to select another port!
 Write a text, for status 200OK
 Choose the type of sock to use
 PROXY SOCKET IN PYTHON
 PROXY SOCKET IN PYTHON3
 Something went wrong, Socks Not Started!
 perfect
 BRUTE FORCE PAYLOAD
 ACTIVATE PROXY SOCKET
 SIMULTANEOUS CONNECTION LIMITER
 SEE PROXY PYTHON
 INSTALLATION MENU
 NONE PROXY SOCKS IS ACTIVE
 ENTER A HOST TO CREATE
 GENERIC PAYLOADS!
 PAYLOAD CREATOR
 ENTER THE HOST
 Do not add anything.
 PAYLOAD GENERATOR
 CHOOSE THE REQUIREMENTS METHOD
 AND FINALLY
 INJECTION METHOD!
 SOMETHING IS
 EVIL!
 SUCCESS !, PAYLOADS GENERATED
 DIRECTORY:
 ACTIVATE PROXY GETTUNEL
 What is the port you want for the GetTUNNEL
 Port Used By:
 GETTUNEL KEY:
 GETTUNEL STARTED SUCCESSFULLY!
 GETTUNEL DOES NOT START!
 Select the service to manage ports
 No Service Chosen, Or Service Chosen Is Not Supported
 Do you want to close the current port?
 Or Open a new port in the service?
 Procedure, Finished!
 DOOR MANAGEMENT
 Chosen service and port:
 Unsupported architecture!
 APPROXIMATE USE
 TOTAL CONSUMPTION
 USERS
 CONSUMPTION MONITOR
 Verification is not activated, or there is no information
 TELEGRAM BOT
 SHADOWSOCKS / SSL stunnel
 SHADOWSOCKS AND SSL
 select a redirect port
 select a port
 Invalid port!
 No Inland Ports Open!
 Port Of Your External SSL!  Enter port in injector application
 Port in use!
 Answer the Questions Correctly!
 Encryption Media
 Select encryption
 Encryption not selected!
 Password:
 TCP OVER
 ULTRA HOST (SUBDOMAIN SCANNER)
 HOST
 CAPTURE LIMIT
 ENTER A PASSWORD and THEN CONFIRM IT
 VNC connects using the ip of the vps on the port
 To access the graphical interface
 Download from PlayStore:
 VNC is not active Do you want to activate?
 VNC is active Do you want to disable?
 VNC SERVER
 YOUR Korn Server IS UPDATED!
 YOUR Korn Server NEEDS TO UPDATE!
 APPLY TORRENT LOCK
 Create a new OpenVPN file?
 Create file with authentication (username and password)?
 File generated in:
 To leave it online:
 AUTO STARTUP
 PROXY SQUID AUTHENTICATION
 Error generating password, squid authentication did not start!
 AUTHENTICATION OF THE INITIATED PROXY SQUID.
 Squid proxy not installed, cannot continue.
 PROXY SQUID AUTHENTICATION DISABLED.
 The user cannot be null.
 Do you want to enable squid proxy authentication?
 Do you want to disable squid proxy authentication?
 YOUR IP:
 REBOOT VPS (REBOOT)
 Do you really want to Restart the VPS?
 Preparing for restarting VPS.
 INSTALLATION MENU
 INSTALL
 SET UP
 Select an option
END
sleep 2


#Translate to English 2
cd
cat > /etc/adm-lite/idioma_geral <<END
#!/bin/bash

if [[ -e $_dr ]]; then
n=0
while read line; do
txt[$n]="$line"
n=$(($n+1))
done < $_dr
unset n
[[ ${txt[0]} = "" ]] && rm $_dr && exit 1
else
 txt [0] = "Gwapong Lander"
 txt [1] = "ONLINE:"
 txt [2] = "EXPIRED:"
 txt [3] = "YOUR SYSTEM:"
 txt [4] = "WELCOME TO THE MENU!"
 txt [5] = "MANAGE USERS"
 txt [6] = "TOOLS"
 txt [7] = "UPDATE"
 txt [8] = "REMOVER Korn Set Up"
 txt [9] = "OPTION:"
 txt [10] = "[ON]"
 txt [11] = "[OFF]"
 txt [12] = "CHANGE MENU COLORS"
 txt [13] = "[BACK / EXIT]"
 txt [14] = "USERS MENU"
 txt [15] = "CREATE USERS"
 txt [16] = "REMOVE USERS"
 txt [17] = "MODIFY USERS"
 txt [18] = "USER DETAILS"
 txt [19] = "VERIFY ONLINE USERS"
 txt [20] = "CONTROLS"
 txt [21] = "YOUR CURRENTLY USED COLORS"
 txt [22] = "Choose in order, 1 2 3 4 5 6"
 txt [23] = "What is the sequence of colors?:"
 txt [24] = "No six colors selected!"
 txt [25] = "Applying the selected color! ..."
 txt [26] = "CHANGE LANGUAGE"
 txt [27] = "Korn Server USER CREATOR"
 txt [28] = "Name of the new user:"
 txt [29] = "Null name"
 txt [30] = "User already existing!"
 txt [31] = "Password for user"
 txt [32] = "Duration for User"
 txt [33] = "Connection limit for user"
 txt [34] = "User:"
 txt [35] = "Password:"
 txt [36] = "Limit:"
 txt [37] = "Validity:"
 txt [38] = "LIST OF REGISTERED USERS"
 txt [39] = "REMOVE USERS"
 txt [40] = "Delete 1 User"
 txt [41] = "Delete all users"
 txt [42] = "Select user or type name"
 txt [43] = "No user has been selected"
 txt [44] = "User does not exist!"
 txt [45] = "deleted"
 txt [46] = "delete"
 txt [47] = "Enter, to return!"
 txt [48] = "USER EDITOR"
 txt [49] = "No user has selected"
 txt [50] = "What option are you going to edit from:"
 txt [51] = "Number of logins from:"
 txt [52] = "Expiration date of:"
 txt [53] = "Change password from:"
 txt [54] = "What is the new login limit:"
 txt [55] = "Limit not changed!"
 txt [56] = "Limit changed"
 txt [57] = "How many days should it last?"
 txt [58] = "Date not modified"
 txt [59] = "Changed!"
 txt [60] = "What is the new password for:"
 txt [61] = "Password not changed!"
 txt [62] = "New password applied"
 txt [63] = "No option selected!"
 txt [64] = "User"
 txt [65] = "Password"
 txt [66] = "Limit"
 txt [67] = "Time"
 txt [68] = "??"
 txt [69] = "Unlimited"
 txt [70] = "Expired"
 txt [71] = "You have:"
 txt [72] = "Users on your server"
 txt [73] = "days"
 txt [74] = "USERS"
 txt [75] = "CONNECTION"
 txt [76] = "TIME"
 txt [77] = "That Tool Will Translate"
 txt [78] = "Brought you by Gwapong Lander"
 txt [79] = "Select the language number, or use the initials of the language."
 txt [80] = ""
 txt [81] = "Translating the system ..."
 txt [82] = "Please enter a language:"
 txt [83] = "hours"
 txt [84] = "minutes"
 txt [85] = "use"
 txt [86] = "There is no user online"
 txt [87] = "DELETE EXPIRED USERS"
 txt [88] = "No Expired Users!"
 txt [89] = "TOOLS MENU"
 txt [90] = "CREATE BACKUP"
 txt [91] = "RESTORE BACKUP"
 txt [92] = "CLEAR CACHE"
 txt [93] = "BAD UDP"
 txt [94] = "TCP SPEED"
 txt [95] = "FAILBAN"
 txt [96] = "SQUID CACHE"
 txt [97] = "SHARE ONLINE FILE"
 txt [98] = "Enter only numeric values"
 txt [99] = "STARTING BACKUP"
 txt [100] = "User backup"
 txt [101] = "User not registered in ADM-FREE"
 txt [102] = "Enter user information."
 txt [103] = "Current password:"
 txt [104] = "Duration Days:"
 txt [105] = "Connection limit:"
 txt [106] = "Full backup"
 txt [107] = "Back UDP available in folder"
 txt [108] = "Enter the backup directory"
 txt [109] = "or, Enter a link for a backup"
 txt [110] = "File or link"
 txt [111] = "Invalid file or link!"
 txt [112] = "Backup incompatible with ADM"
 txt [113] = "Restore ..."
 txt [114] = "User not restored"
 txt [115] = "This Tool will Clear Caches"
 txt [116] = "and delete temporary files"
 txt [117] = "Procedure completed"
 txt [118] = "BADVPN will be installed"
 txt [119] = "which is nothing more than a program"
 txt [120] = "which frees UDP ports on the server"
 txt [121] = "and thus allow the VOIP service!"
 txt [122] = "Start"
 txt [123] = "BADVPN started successfully"
 txt [124] = "Stopping BADVPN service ..."
 txt [125] = "BADVPN stopped successfully"
 txt [126] = "This Script was projected"
 txt [127] = "To Improve Latency"
 txt [128] = "and server speed!"
 txt [129] = "analyze"
 txt [130] = "This is an experimental script"
 txt [131] = "Use at your own risk and expense!"
 txt [132] = "This script will change some"
 txt [133] = "network settings"
 txt [134] = "from system to reduce"
 txt [135] = "latency and improve speed"
 txt [136] = "Continue with the installation?"
 txt [137] = "Network configuration"
 txt [138] = "have been added successfully"
 txt [139] = "have already been added in the system!"
 txt [140] = "You want to remove the configuration"
 txt [141] = "Network configuration"
 txt [142] = "have been removed successfully"
 txt [143] = "Why not?"
 txt [144] = "uninstall"
 txt [145] = "View record"
 txt [146] = "This is FAILBAN PROTECTION"
 txt [147] = "Made solely to protect the security of the"
 txt [148] = "System, your goal is to analyze"
 txt [149] = "ACCESS LOGS and block all"
 txt [150] = "suspicious action"
 txt [151] = "increasing your security by 70%."
 txt [152] = "Do you want to install Fail2Ban?"
 txt [153] = "Fail2ban Will Be Installed"
 txt [154] = "Next Services"
 txt [155] = "Do you confirm the choice?"
 txt [156] = "Installation completed"
 txt [157] = "Squid cache is nothing but"
 txt [158] = "A browsing history on Squid"
 txt [159] = "What will save data when opening sites"
 txt [160] = "Hosted in your cache"
 txt [161] = "The script will do a short check!"
 txt [162] = "Squid not identified!"
 txt [163] = "Squid is Active on your system!"
 txt [164] = "There is no cache service on the Squid!"
 txt [165] = "Restarting Services Please wait!"
 txt [166] = "Activating the SquidCache service!"
 txt [167] = "Disabling SquidCache !!"
 txt [168] = "wait!"
 txt [169] = "PLACE FILE ONLINE"
 txt [170] = "OPTION TO PLACE"
 txt [171] = "ANY ONLINE FILE"
 txt [172] = "WHAT THIS FILE"
 txt [173] = "IN THE DIRECTORY"
 txt [174] = "REMOVE ONLINE FILE"
 txt [175] = "SEE MY FILES ONLINE"
 txt [176] = "Invalid option"
 txt [177] = "Please select a file"
 txt [178] = "No file has been selected"
 txt [179] = "Procedure Done Successfully"
 txt [180] = "ACCESS TO THE FILE THROUGH THE LINK"
 txt [181] = "Your files in the folder"
 txt [182] = "TEST YOUR SPEED"
 txt [183] ​​= "VPS INFORMATION"
 txt [184] = "Test start, please wait ..."
 txt [185] = "Ping response time"
 txt [186] = "Loading speed"
 txt [187] = "Download speed"
 txt [188] = "Error processing information"
 txt [189] = "Your System"
 txt [190] = "based"
 txt [191] = "Physical Processor"
 txt [192] = "Operating frequency"
 txt [193] = "Processor usage"
 txt [194] = "Total Virtual Memory"
 txt [195] = "Virtual Memory In use"
 txt [196] = "Free Virtual Memory"
 txt [197] = "Virtual Memory Swap"
 txt [198] = "Online time"
 txt [199] = "Machine name"
 txt [200] = "Machine Address"
 txt [201] = "Kernel versions"
 txt [202] = "Architecture"
 txt [203] = "analyze"
 txt [204] = "file"
 txt [205] = "updated"
 txt [206] = "Updated files"
 txt [207] = "Validate! Updating ..."
 txt [208] = "Expired or invalid Exiting!"
 txt [209] = "Are you sure about this?"
 txt [210] = "Uninstall canceled by user"
 txt [211] = "Created by @iSrDiiabloNS"
 txt [212] = "ADD / REMOVE HOST-SQUID"
 txt [213] = "not found"
 txt [214] = "Or Squid not installed"
 txt [215] = "Add Host to Squid"
 txt [216] = "Remove Squid host"
 txt [217] = "Invalid Option"
 txt [218] = "Current domains on file"
 txt [219] = "Enter the Host-Squid you want to add"
 txt [220] = "Starting with a., example: .bughost.com"
 txt [221] = "This is empty, you have not written anything!"
 txt [222] = "The domain already exists in the file"
 txt [223] = "Success, File Updated!"
 txt [224] = "Enter the domain you want to remove"
 txt [225] = "domain not found"
 txt [226] = "Enter the text for the BANNER"
 txt [227] = "green"
 txt [228] = "red"
 txt [229] = "blue"
 txt [230] = "yellow"
 txt [231] = "purple"
 txt [232] = "Please enter the main message"
 txt [233] = "Want to Add More Texts"
 txt [234] = "COLORFUL BANNER"
 txt [235] = "Dependencies not installed, do you want to install?"
 txt [236] = "Installing dependencies for proxy-socks ..."
 txt [237] = "Stopping proxy-sock ..."
 txt [238] = "Proxy-sock stopped!"
 txt [239] = "Select the port to turn on"
 txt [240] = "Your Proxy Sockets:"
 txt [241] = "Opa, is being used by:"
 txt [242] = "Disable this service to use"
 txt [243] = "The port:"
 txt [244] = "For the SOCKS"
 txt [245] = "Enter, to select another port!"
 txt [246] = "Write a text, for status 200OK"
 txt [247] = "Choose the type of sock to use"
 txt [248] = "PROXY SOCKET IN PYTHON"
 txt [249] = "PROXY SOCKET IN PYTHON3"
 txt [250] = "Something went wrong, Socks Not Started!"
 txt [251] = "perfect"
 txt [252] = "BRUTE FORCE PAYLOAD"
 txt [253] = "ACTIVATE PROXY SOCKET"
 txt [254] = "SIMULTANEOUS CONNECTION LIMITER"
 txt [255] = "VIEW PROXY PYTHON"
 txt [256] = "INSTALLATION MENU"
 txt [257] = "NONE PROXY SOCKS IS ACTIVE"
 txt [258] = "SEND A HOST TO CREATE"
 txt [259] = "GENERIC PAYLOADS!"
 txt [260] = "PAYLOAD CREATOR"
 txt [261] = "ENTER THE HOST"
 txt [262] = "Do not add anything."
 txt [263] = "PAYLOAD GENERATOR"
 txt [264] = "CHOOSE THE REQUIREMENTS METHOD"
 txt [265] = "AND LASTLY"
 txt [266] = "INJECTION METHOD!"
 txt [267] = "SOMETHING IS"
 txt [268] = "BAD!"
 txt [269] = "SUCCESS !, GENERATED PAYLOADS"
 txt [270] = "DIRECTORY:"
 txt [271] = "ACTIVATE PROXY GETTUNEL"
 txt [272] = "What is the port you want for the GetTUNNEL"
 txt [273] = "Port Used By:"
 txt [274] = "GETTUNEL KEY:"
 txt [275] = "GETTUNEL STARTED SUCCESSFULLY!"
 txt [276] = "GETTUNEL NOT STARTING!"
 txt [277] = "Select the service to manage ports"
 txt [278] = "No Chosen Service, Or Chosen Service Is Not Supported"
 txt [279] = "Do you want to close the current port?"
 txt [280] = "Or Open a new port in the service?"
 txt [281] = "Procedure, Finished!"
 txt [282] = "DOOR MANAGEMENT"
 txt [283] = "Chosen service and port:"
 txt [284] = "Unsupported architecture!"
 txt [285] = "APPROXIMATE USE"
 txt [286] = "TOTAL CONSUMPTION"
 txt [287] = "USERS"
 txt [288] = "CONSUMPTION MONITOR"
 txt [289] = "Verification is not activated, or there is no information"
 txt [290] = "BOT TELEGRAM"
 txt [291] = "SHADOWSOCKS / SSL stunnel"
 txt [292] = "SHADOWSOCKS AND SSL"
 txt [293] = "select a redirect port"
 txt [294] = "select a port"
 txt [295] = "Invalid port!"
 txt [296] = "No Internal Ports Open!"
 txt [297] = "Port From Your External SSL! Enter port in injector application"
 txt [298] = "Port in use!"
 txt [299] = "Answer the Questions Correctly!"
 txt [300] = "Encryption Media"
 txt [301] = "Select encryption"
 txt [302] = "Encryption not selected!"
 txt [303] = "Password:"
 txt [304] = "TCP OVER"
 txt [305] = "ULTRA HOST (SUBDOMAIN SCANNER)"
 txt [306] = "HOST"
 txt [307] = "CAPTURE LIMIT"
 txt [308] = "ENTER A PASSWORD and THEN CONFIRM IT"
 txt [309] = "VNC connects using the ip of the vps on the port"
 txt [310] = "To access the graphical interface"
 txt [311] = "Download from PlayStore:"
 txt [312] = "VNC is not active. Do you want to activate?"
 txt [313] = "VNC is active. Do you want to disable it?"
 txt [314] = "VNC SERVER"
 txt [315] = "YOUR Korn Server IS UPDATED!"
 txt [316] = "YOUR Korn Server NEEDS TO UPDATE!"
 txt [317] = "APPLY TORRENT LOCK"
 txt [318] = "Create a new OpenVPN file?"
 txt [319] = "Create file with authentication (username and password)?"
 txt [320] = "File generated in:"
 txt [321] = "To leave it online:"
 txt [322] = "AUTO START"
 txt [323] = "PROXY SQUID AUTHENTICATION"
 txt [324] = "Error generating password, squid authentication did not start!"
 txt [325] = "AUTHENTICATED PROXY SQUID INITIATED."
 txt [326] = "Squid proxy not installed, cannot continue."
 txt [327] = "PROXY SQUID AUTHENTICATION DISABLED."
 txt [328] = "User cannot be null."
 txt [329] = "Do you want to enable squid proxy authentication?"
 txt [330] = "Do you want to disable squid proxy authentication?"
 txt [331] = "YOUR IP:"
 txt [332] = "REBOOT VPS (REBOOT)"
 txt [333] = "Do you really want to Restart the VPS?"
 txt [334] = "Preparing to restart VPS."
 txt [335] = "INSTALLATION MENU"
 txt [336] = "INSTALL"
 txt [337] = "CONFIGURE"
 txt [338] = "Please select an option"
 echo "${txt[0]}" > $_dr
for((_cont=1; _cont<${#txt[@]}; _cont++)); do
echo "${txt[$_cont]}" >> $_dr
done
fi
END
sleep 2
cd

#add port and banner
sudo echo "Port 333" >> /etc/ssh/sshd_config
sudo echo "Port 334" >> /etc/ssh/sshd_config
sudo echo "Port 335" >> /etc/ssh/sshd_config
sudo echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sudo echo "DROPBEAR_BANNER="/etc/issue.net"" >> /etc/default/dropbear
sudo echo "relaxed_header_parser off" >> /etc/squid3/squid.conf

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

#clear all message in screen
clear

#END of Installation
echo -e""
echo -e""
echo  " End of Installation | Created by Gwapong Lander "
echo -e""
echo "Next Step:"
echo "(Menu:9) Install Dropbear and Squid"
echo "(Menu:2) Install TCP Speed and Squid Cache and Torrent"
echo "(Menu:1) Install Banner"
echo -e""
echo "Squid Port must be " 61790 " and must add SSHD Port " 333 ""
echo " in order to use OHP "
echo ""
echo " Type "menu" or "adm" to access ADM-FREE Manager "
echo " "
