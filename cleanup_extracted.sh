echo"#!/bin/sh

FS='/nsm/bro/extracted'
FREE=1000000

checkdf() {
  local used
  used=`df -k ${FS} | tail -1 | awk '{ print $4 }'`
  if [ ${used} -ge ${FREE} ]; then
    exit 0
  fi
}

checkdf

cd /nsm/
for f in `find /nsm/bro/extracted/ -type f \( -name '*.*' \) -exec basename {} \; | sort -n -t\. -k3`; do
  echo "  deleting " `ls -lash /nsm/pcap/${f}`
  rm -f /nsm/bro/extracted/${f}
  checkdf
done
exit 0">/nsm/scripts/cleanup_extracted

chmod +x /nsm/scripts/cleanup_extracted

echo "*/5 * * * * root /nsm/scripts/cleanup_extracted" >> /etc/crontab
