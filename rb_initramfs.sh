#!/bin/sh
# rebuild initramfs
cd ~/my_distro/initramfs
find . | cpio -oH newc | gzip > ../initramfs.cpio.gz
cd ..
echo "Rebuilt and zipped initramfs."
