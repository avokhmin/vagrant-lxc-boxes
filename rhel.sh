#!/bin/bash

ch="${NAME}"
echo ${NAME}
echo ${ARCH}
mkdir ${ch}

# Init rpm db
mkdir -p ${ch}/var/lib/rpm
setarch ${ARCH} rpm --rebuilddb --root=${ch}
mkdir -p ${ch}/etc/yum.repos.d/
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

# Fill in packages into chroot
setarch ${ARCH} rpm -i --root=${ch} --nodeps groupinstall buildsys-build git lxc


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

/usr/sbin/chroot ${ch} /bin/bash -c "cd ${ch}/opt/VAGRANT-LXC-BOX-BUILD/boxes; ./build-rels-box.sh ${NAME} ${ARCH}" > /home/vagrant/results/build.log 2>&1
cp -rfT  ${ch}/${ch}/opt/VAGRANT-LXC-BOX-BUILD/boxes/output /home/vagrant/results
umount -l ${ch}/sys
umount -l ${ch}/proc
umount -l ${ch}/dev/pts
umount -l ${ch}/dev

rm -rf ${ch}