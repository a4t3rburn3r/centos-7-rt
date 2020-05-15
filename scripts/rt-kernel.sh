#!/bin/sh -eux

# This system is built using Bento project work
# All rights go to Bento project
# More information can be found at https://github.com/chef/bento'

# For latest RT patches go to https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/
# For apropriate kernel go to https://mirrors.edge.kernel.org/pub/linux/kernel/

RT_KERNEL_VER="5"
RT_KERNEL_SUB_VER="5.6"
RT_KERNEL_FULL_VER="5.6.10"
RT_KERNEL_PATCH_REL="5.6.10-rt5"

yum install make gcc openssl-devel ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel bc wget rpm-build flex bison -y
mkdir -p /tmp/rt-kernel-$RT_KERNEL_FULL_VER
cd /tmp/rt-kernel-$RT_KERNEL_FULL_VER
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$RT_KERNEL_VER.x/linux-$RT_KERNEL_FULL_VER.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/$RT_KERNEL_SUB_VER/patch-$RT_KERNEL_PATCH_REL.patch.xz
tar -xf linux-$RT_KERNEL_FULL_VER.tar.xz
mv linux-$RT_KERNEL_FULL_VER linux-$RT_KERNEL_PATCH_REL
cd linux-$RT_KERNEL_PATCH_REL
xz -d ../patch-$RT_KERNEL_PATCH_REL.patch.xz
patch -p1 <../patch-$RT_KERNEL_PATCH_REL.patch
ls /boot/config-* | grep `uname -r` | xargs cp -t .
mv config* .config
yes "" | make oldconfig

# make menuconfig
# General -> Preemtion Model -> Preemtible Kernel (Low-Latency Desktop)

sed -i '/CONFIG_PREEMPT_VOLUNTARY=y/d' .config
sed -i '/# CONFIG_PREEMPT is not set/d' .config
sed -i '/CONFIG_INLINE_SPIN_UNLOCK_IRQ=y/d' .config
sed -i '/CONFIG_INLINE_READ_UNLOCK=y/d' .config
sed -i '/CONFIG_INLINE_READ_UNLOCK_IRQ=y/d' .config
sed -i '/CONFIG_INLINE_WRITE_UNLOCK=y/d' .config
sed -i '/CONFIG_INLINE_WRITE_UNLOCK_IRQ=y/d' .config
sed -i '/# CONFIG_DRM_I810 is not set/d' .config

echo "# ENABLE RT" >> .config
echo "# CONFIG_PREEMPT_VOLUNTARY is not set" >> .config
echo "CONFIG_PREEMPT=y" >> .config
echo "CONFIG_PREEMPT_COUNT=y" >> .config
echo "CONFIG_PREEMPTION=y" >> .config
echo "CONFIG_PREEMPT_RCU=y" >> .config
echo "CONFIG_TASKS_RCU=y" >> .config
echo "CONFIG_UNINLINE_SPIN_UNLOCK=y" >> .config
echo "CONFIG_DEBUG_PREEMPT=y" >> .config
echo "# CONFIG_PREEMPT_TRACER is not set" >> .config

make rpm-pkg
rpm -iUv /root/rpmbuild/RPMS/x86_64/*.rpm
rm -rf /tmp/rt-kernel-$RT_KERNEL_FULL_VER
rm -rf /root/rpmbuild

reboot
sleep 60
