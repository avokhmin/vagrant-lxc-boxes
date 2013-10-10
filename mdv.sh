#!/bin/bash

ch="$PRODUCTNAME"
echo $PRODUCTNAME
echo $REPO
echo $ARCH
mkdir $ch
umount $ch/sys
umount $ch/proc
umount $ch/dev/pts
umount $ch/dev
urpmi.addmedia --urpmi-root $PRODUCTNAME --distrib --all-media $REPO > /home/vagrant/results/addrepo.log 2>&1
urpmi --urpmi-root $PRODUCTNAME --root $PRODUCTNAME basesystem-minimal basesystem urpmi rpm locales-en locales-ru rpm-build syslinux yum bootloader-utils git lxc --auto --no-suggests --no-verify-rpm
mkdir -p $ch/dev
mkdir -p $ch/dev/pts
mkdir -p $ch/proc
mkdir -p $ch/sys
mkdir -p $ch/opt

mount --bind /dev/      $ch/dev
mount --bind /dev/pts   $ch/dev/pts
mount --bind /proc      $ch/proc
mount --bind /sys       $ch/sys
cp /etc/resolv.conf $ch/etc/


chroot $ch git clone -b $BRANCH https://github.com/avokhmin/vagrant-lxc.git $ch/opt/VAGRANT-LXC-BOX-BUILD
cd $ch/$ch/opt/VAGRANT-LXC-BOX-BUILD
cd ../../../../
ls -R > /home/vagrant/results/ls.log




echo 
echo "----------> UR IN Z MATRIX <----------"

# Configure network
# sudo chkconfig NetworkManager off
# sudo chkconfig --level 35 network on
# sudo service NetworkManager stop
# sudo service network restart

# sudo cat <<"EOF"> /etc/sysconfig/network-scripts/ifcfg-eth0
# DEVICE=eth0
# BOOTPROTO=none
# BRIDGE=br0
# ONBOOT=yes
# EOF

# sudo cat <<"EOF"> /etc/sysconfig/network-scripts/ifcfg-br0 
# DEVICE=br0
# BOOTPROTO=dhcp
# ONBOOT=yes
# TYPE=Bridge
# DELAY=0
# EOF


# sudo cat <<"EOF"> /etc/sysconfig/network
# NETWORKING=yes
# EOF

# sudo service network restart

/usr/sbin/chroot $ch ip a

/usr/sbin/chroot $ch /bin/bash -c "cd $ch/opt/VAGRANT-LXC-BOX-BUILD/boxes; ./build-openmandriva-box.sh $PRODUCTNAME $ARCH" > /home/vagrant/results/build.log 2>&1
cp -rfT  $ch/$ch/opt/VAGRANT-LXC-BOX-BUILD/boxes/output /home/vagrant/results
umount -l $ch/sys
umount -l $ch/proc
umount -l $ch/dev/pts
umount -l $ch/iso
umount -l $ch/dev