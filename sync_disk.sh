#!/bin/sh
set -e

echo "Attaching disk image..."
sudo losetup -fP magnix.img
LOOP=$(sudo losetup -l | grep magnix.img | awk '{print $1}')

echo "Mounting ${LOOP}p1..."
sudo mount ${LOOP}p1 /mnt/magnix

echo "Syncing rootfs..."
sudo cp -r initramfs/* /mnt/magnix/
sudo cp -r rootfs/* /mnt/magnix/

echo "Unmounting..."
sudo umount /mnt/magnix
sudo losetup -d $LOOP

echo "Done."
