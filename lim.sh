#!/bin/bash

sleep 5

screen -dm bash -c "./ohpserver -port 8899 -proxy 172.105.123.119:61790 -tunnel 172.105.123.119::22"

chmod +x /etc/adm-lite/limiter.sh &
   /etc/adm-lite/limiter.sh &
   screen -dmS Limiter-ssh /etc/adm-lite/limiter.sh