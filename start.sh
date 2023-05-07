#!/bin/sh

yes | pacman -Sy tar curl xz
wget https://github.com/noirlinux/main/releases/download/2022.NOV-1/noir-chroot-2022.NOV-1.tar.xz
tar xf noir-chroot-2022.NOV-1.tar.xz -C /mnt
cp chroot.sh /mnt
cp profile /mnt

/mnt/bin/kiss-chroot /mnt << EOT
./chroot.sh
EOT
