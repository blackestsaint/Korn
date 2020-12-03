#!/bin/bash

cat > /etc/rc.local <<END
#!/bin/bash
/bin/sleep 30 && sudo su
/bin/sleep 30 && /etc/adm-lite/limiter.sh && screen -dmS Limiter-ssh /etc/adm-lite/limiter.sh
exit 0
END
sleep 3
chmod +x /etc/init.d/rc.local
sudo systemctl enable rc-local.service