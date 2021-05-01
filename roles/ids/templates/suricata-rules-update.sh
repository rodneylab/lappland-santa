#!/bin/sh
/usr/local/bin/oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules
/usr/sbin/rcctl restart suricata
sleep 60
RETRIES=0
until [ $RETRIES -eq 60 ] || /etc/rc.d/suricata check; do
  rm -f /var/suricata/run/suricata.pid
  /etc/rc.d/suricata restart
  sleep 60
done
