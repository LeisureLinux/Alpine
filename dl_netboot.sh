#!/bin/sh
# 下载网络启动需要的内核以及 initrd
URL="http://mirrors.nju.edu.cn/alpine/edge"
arch="x86_64"
[ ! -d $arch ] && mkdir $arch
cd $arch
KERNEL=vmlinuz-lts
RD=initramfs-lts
[ ! -r $KERNEL ] && wget $URL/releases/$arch/netboot/$KERNEL
[ ! -r $RD ] && wget $URL/releases/$arch/netboot/$RD

exit
# ##### Please ignore below for now #####
# APKOVL=http://192.168.7.11/client.apkovl.tar.gz
# BR=virtbr0
# sudo tunctl -d tap0 2>/dev/null
# sudo tunctl -t tap0 -u $(whoami)
# # Add tap0 to bridge
# sudo brctl addif $BR tap0
# sudo ifconfig tap0 up
#
# sudo qemu-system-$arch \
# 	-m 512 -smp 4 $CPU \
# 	-kernel $KERNEL -initrd $RD \
# 	-netdev tap,id=net1,ifname=tap0,vhost=on,script=no,downscript=no \
# 	-device e1000,netdev=net1 \
# 	-append "console=ttyS0 ip=dhcp alpine_repo=$URL/main apkovl=$APKOVL" \
# 	-nographic
#
# # Cleanup
# sudo tunctl -d tap0
