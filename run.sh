#!/bin/sh
qemu-system-x86_64 \
  -kernel linux-6.8/arch/x86/boot/bzImage \
  -initrd initramfs.cpio.gz \
  -drive file=magnix.img,format=raw,if=virtio \
  -m 512M \
  -netdev user,id=net0 -device virtio-net-pci,netdev=net0 \
  -nographic \
  -append "console=ttyS0 rdinit=/sbin/init quiet"
