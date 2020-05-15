#!/bin/sh -eux

# This system is built using Bento project work
# All rights go to Bento project
# More information can be found at https://github.com/chef/bento'

# install yum-utils and clean up old kernels
if ! command -v package-cleanup >/dev/null 2>&1; then
yum install yum-utils -y
fi
package-cleanup --oldkernels --count=1 -y

# Remove development and kernel source packages
# yum remove make gcc openssl-devel ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel bc wget rpm-build flex bison cpp kernel-devel kernel-headers -y

# Clean up network interface persistence
rm -f /etc/udev/rules.d/70-persistent-net.rules
mkdir -p /etc/udev/rules.d/70-persistent-net.rules
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /dev/.udev/

for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
    if [ "`basename $ndev`" != "ifcfg-lo" ]; then
        sed -i '/^HWADDR/d' "$ndev";
        sed -i '/^UUID/d' "$ndev";
    fi
done

# new-style network device naming for centos7
# radio off & remove all interface configration
nmcli radio all off
/bin/systemctl stop NetworkManager.service
for ifcfg in `ls /etc/sysconfig/network-scripts/ifcfg-* |grep -v ifcfg-lo` ; do
  rm -f $ifcfg
done
rm -rf /var/lib/NetworkManager/*

echo "==> Setup /etc/rc.d/rc.local for EL7"
cat <<_EOF_ | cat >> /etc/rc.d/rc.local
#REALTIME-BEGIN
LANG=C
# delete all connection
for con in \`nmcli -t -f uuid con\`; do
  if [ "\$con" != "" ]; then
    nmcli con del \$con
  fi
done
# add gateway interface connection.
gwdev=\`nmcli dev | grep ethernet | egrep -v 'unmanaged' | head -n 1 | awk '{print \$1}'\`
if [ "\$gwdev" != "" ]; then
  nmcli connection add type ethernet ifname \$gwdev con-name \$gwdev
fi
sed -i "/^#REALTIME-BEGIN/,/^#REALTIME-END/d" /etc/rc.d/rc.local
chmod -x /etc/rc.d/rc.local
#REALTIME-END
_EOF_
chmod +x /etc/rc.d/rc.local

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# we try to remove these in the ks file, but they're still there
# in the builds so let's remove them here to be sure :shrug:
#
# 12.2019 note: We can probably remove this now, but let's confirm it
yum remove \
  aic94xx-firmware \
  atmel-firmware \
  bfa-firmware \
  ipw2100-firmware \
  ipw2200-firmware \
  ivtv-firmware \
  iwl1000-firmware \
  iwl3945-firmware \
  iwl4965-firmware \
  iwl5000-firmware \
  iwl5150-firmware \
  iwl6000-firmware \
  iwl6050-firmware \
  kernel-uek-firmware \
  libertas-usb8388-firmware \
  netxen-firmware \
  ql2xxx-firmware \
  rt61pci-firmware \
  rt73usb-firmware \
  zd1211-firmware \
  linux-firmware \
  microcode_ctl -y

yum clean all -y

# remove the install log
rm -f /root/anaconda-ks.cfg

# remove the contents of /tmp and /var/tmp
rm -rf /tmp/* /var/tmp/*

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id

# clear the history so our install isn't there
export HISTSIZE=0
rm -f /root/.wget-hsts