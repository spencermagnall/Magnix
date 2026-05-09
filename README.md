# Magnix
 
A minimal Linux-based operating system built from scratch. No distro underpinnings,
no package manager bootstrapped from someone else's rootfs — just a custom kernel,
a hand-built userland, and a clear picture of every layer in the stack.
 
Built as a portfolio project and eventually a personal dev environment.
 
---
 
## Architecture
 
```
Linux Kernel (custom compiled, minimal config)
    └── initramfs (cpio, loaded into RAM at boot)
            └── BusyBox (compiled from source, statically linked)
                    └── BSD-style init (inittab + /etc/rc)
                            └── apk-tools (coming in 0.2)
                                    └── Weston on fbdev (coming in 0.3)
                                            └── Quake via SDL2 (coming in 0.4)
```
 
Magnix uses a BSD-style init system — a plain shell script that runs top to bottom
at boot. No systemd, no service manager, no magic. You can read exactly what happens
at startup in `/etc/rc`.
 
The long term goal is to replace the ext4 filesystem with 9P, making Magnix
architecturally closer to Plan 9 than a traditional Linux distro.
 
---
 
## Milestones
 
| Version | Status | Description |
|---------|--------|-------------|
| 0.1 | ✅ Done | Own kernel + BusyBox compiled from source, shell prompt |
| 0.2 | 🔨 In progress | ext4 filesystem + apk package manager |
| 0.3 | Planned | Weston compositor on fbdev, software rendering |
| 0.4 | Planned | Quake via SDL2 direct to framebuffer |
| 1.0 | Planned | Live USB, boots straight into Quake |
 
---
 
## Building from Source
 
### Prerequisites

Source code for BusyBox, and the Linux kernel is required. Current build uses src available [here](https://busybox.net/downloads/busybox-1.36.1.tar.bz2) 
and [here](https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.8.tar.xz).

Dependencies for Ubuntu/WSL may be installed via: 
```bash
# on Ubuntu/WSL
sudo apt-get install build-essential libelf-dev libssl-dev bc flex bison
```
 
### 1. Clone the repo
 
```bash
git clone https://github.com/spencerb/magnix.git
cd magnix
```
 
### 2. Build the kernel
 
```bash
cd linux-6.8
make ARCH=x86_64 tinyconfig
make ARCH=x86_64 menuconfig   # enable options per docs/kernel-config.md
make ARCH=x86_64 -j$(nproc)
cd ..
```
 
### 3. Build BusyBox
 
```bash
cd busybox-1.36.1
make defconfig
make menuconfig   # enable static binary, set distro name to Magnix
make -j$(nproc)
make install
cd ..
```
 
### 4. Build the initramfs
 
```bash
# populate initramfs from BusyBox install
cp -r busybox-1.36.1/_install/* initramfs/
 
# rebuild symlinks
cd initramfs/bin
for cmd in $(./busybox --list); do ln -sf busybox $cmd; done
cd ../sbin
ln -sf ../bin/busybox init
ln -sf ../bin/busybox reboot
ln -sf ../bin/busybox poweroff
cd ../..
 
# pack
cd initramfs
find . | cpio -oH newc | gzip > ../initramfs.cpio.gz
cd ..
```
 
---
 
## Running in QEMU
 
```bash
qemu-system-x86_64 \
  -kernel linux-6.8/arch/x86_64/boot/bzImage \
  -initrd initramfs.cpio.gz \
  -m 512M \
  -nographic \
  -append "console=ttyS0 rdinit=/bin/sh"
```
 
Exit QEMU with `Ctrl+A` then `X` (the `:q!` of QEMU).
 
---
 
## Booting on Real Hardware
 
Magnix uses (eventually) [Limine](https://github.com/limine-bootloader/limine) as its bootloader.
Live USB support is coming in 1.0.
 
---
 
## License
 
Magnix build scripts and configuration files are MIT licensed.
 
Magnix is built on the Linux kernel (GPL2) and BusyBox (GPL2).
Source for both is available at their respective upstream repositories.
