#!/bin/sh

mkdir -p /home/dk/repos
mv profile /home/dk
cd /home/dk
mv profile ~/.profile

git clone https://github.com/noirlinux/main /home/dk/repos/noir

. ~/.profile

echo | kiss update
echo | kiss b baseinit grub e2fsprogs dhcpcd ncurses libelf perl vim libudev-zero util-linux

git clone https://github.com/Doomking36/vmware
cd vmware
mv vm* /boot
mv Sys* /boot
mv CON* /root
cd ..
rm -rf vmware

echo "noir" > /etc/hostname
echo "127.0.0.1 noir.localdomain noir::1 noir.localdomain noir ip6-localhost" > /etc/hosts

echo root:123 | chpasswd
adduser -h /home/dk dk
echo dk:123 | chpasswd
addgroup dk wheel

git clone https://codeberg.org/sw1tchbl4d3/rdo
cd rdo
mkdir -p /usr/local/bin
make
make install
cd ..

su dk << EOT
git clone https://github.com/Doomking36/noir-setup
cp noir-setup/profile /home/dk
mv profile ~/.profile
EOT

curl -fLO https://github.com/cemkeylan/genfstab/raw/master/genfstab
chmod +x genfstab
./genfstab -U / >> /etc/fstab

tune2fs -O ^metadata_csum_seed /dev/sda1
echo GRUB_DISABLE_OS_PROBER=false >> /etc/default/grub

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
