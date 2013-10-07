#!/bin/bash

ch="$PRODUCTNAME"
echo $PRODUCTNAME
echo $REPO
mkdir $ch
umount $ch/sys
umount $ch/proc
umount $ch/dev/pts
umount $ch/dev
urpmi.addmedia --urpmi-root $PRODUCTNAME --distrib --all-media $REPO > /home/vagrant/results/addrepo.log 2>&1
urpmi --urpmi-root $PRODUCTNAME --root $PRODUCTNAME basesystem-minimal basesystem urpmi rpm locales-en locales-ru rpm-build syslinux yum git lxc --auto
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


chroot $ch git clone -b $BRANCH git@github.com:avokhmin/vagrant-lxc.git $ch/opt/VAGRANT-LXC-BOX-BUILD
cd $ch/$ch/opt/VAGRANT-LXC-BOX-BUILD
cd ../../../../
ls -R > /home/vagrant/results/ls.log




echo 
echo "----------> UR IN Z MATRIX <----------"

/usr/sbin/chroot $ch $ch/opt/VAGRANT-LXC-BOX-BUILD/boxes/build-$PRODUCTNAME-box.sh > /home/vagrant/results/build.log 2>&1
cp -rfT  $ch/$ch/opt/VAGRANT-LXC-BOX-BUILD/boxes/output /home/vagrant/results
umount -l $ch/sys
umount -l $ch/proc
umount -l $ch/dev/pts
umount -l $ch/iso
umount -l $ch/dev