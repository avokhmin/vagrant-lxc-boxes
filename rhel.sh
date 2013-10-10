#!/bin/bash

ch="${NAME}"
echo ${NAME}
echo ${ARCH}
mkdir ${ch}
script_path=`pwd`

# Init rpm db
mkdir -p ${ch}/var/lib/rpm
setarch ${ARCH} rpm --rebuilddb --root=${script_path}/${ch}
mkdir -p ${ch}/etc/yum.repos.d/

# Fill in packages into chroot
setarch ${ARCH} rpm -i --root=${script_path}/${ch} --nodeps http://abf.rosalinux.ru/downloads/${NAME}/repository/${ARCH}/base/release/rosa-release-6Server-4.res6.${ARCH}.rpm

rm -f ${ch}/etc/yum.repos.d/*
cat <<"EOF"> ${ch}/etc/yum.repos.d/base.repo
[base]
name=BASE
baseurl=http://abf-downloads.rosalinux.ru/${NAME}/repository/${ARCH}/base/release/
gpgcheck=0

[abf-worker-service]
name=abf-worker-service
baseurl=http://abf-downloads.rosalinux.ru/abf_personal/repository/${NAME}/${ARCH}/base/release/
gpgcheck=0
EOF

setarch ${ARCH} yum --installroot=${script_path}/${ch} install -y yum git lxc


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
/usr/sbin/chroot ${ch} /bin/bash -c "cd ${ch}/opt/VAGRANT-LXC-BOX-BUILD/boxes; ./build-rels-box.sh 6.4 ${ARCH}" > /home/vagrant/results/build.log 2>&1
cp -rfT  ${ch}/${ch}/opt/VAGRANT-LXC-BOX-BUILD/boxes/output /home/vagrant/results
[ $? -ne 0 ] && exit_code=1

umount -l ${ch}/sys
umount -l ${ch}/proc
umount -l ${ch}/dev/pts
umount -l ${ch}/dev

rm -rf ${ch}

exit ${exit_code}