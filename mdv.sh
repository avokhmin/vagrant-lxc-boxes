#!/bin/bash

ch="${NAME}"
echo ${NAME}
echo ${ARCH}
mkdir ${ch}

repo=http://abf-downloads.rosalinux.ru/${NAME}/repository/${ARCH}
urpmi.addmedia --urpmi-root ${NAME} --distrib --all-media ${repo} > /home/vagrant/results/addrepo.log 2>&1
urpmi --urpmi-root ${NAME} --root ${NAME} basesystem-minimal basesystem urpmi rpm locales-en locales-ru rpm-build syslinux yum bootloader-utils git lxc --auto --no-suggests --no-verify-rpm

mkdir -p ${ch}/dev
mkdir -p ${ch}/dev/pts
mkdir -p ${ch}/proc
mkdir -p ${ch}/sys
mkdir -p ${ch}/opt

mount --bind /dev/      ${ch}/dev
mount --bind /dev/pts   ${ch}/dev/pts
mount --bind /proc      ${ch}/proc
mount --bind /sys       ${ch}/sys
cp /etc/resolv.conf ${ch}/etc/


chroot ${ch} git clone -b ${BRANCH} https://github.com/avokhmin/vagrant-lxc.git ${ch}/opt/VAGRANT-LXC-BOX-BUILD
ls -R > /home/vagrant/results/ls.log

echo 
echo "----------> UR IN Z MATRIX <----------"

exit_code=0
/usr/sbin/chroot ${ch} /bin/bash -c "cd ${ch}/opt/VAGRANT-LXC-BOX-BUILD/boxes; ./build-openmandriva-box.sh ${NAME} ${ARCH}" > /home/vagrant/results/build.log 2>&1
cp -rfT  ${ch}/${ch}/opt/VAGRANT-LXC-BOX-BUILD/boxes/output /home/vagrant/results
[ $? -ne 0 ] && exit_code=1

umount -l ${ch}/sys
umount -l ${ch}/proc
umount -l ${ch}/dev/pts
umount -l ${ch}/dev

rm -rf ${ch}

exit ${exit_code}