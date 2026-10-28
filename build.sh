#!/usr/bin/env bash
# Pro OS ISO derleyici. Debian 13 (trixie) ortamında, root ile çalışır.
set -euo pipefail
cd "$(dirname "$0")"
apt-get update
apt-get install -y live-build debootstrap squashfs-tools xorriso mtools dosfstools \
  grub-pc-bin grub-efi-amd64-bin isolinux syslinux-common debian-archive-keyring ca-certificates
rm -rf build && mkdir build
cp -r config build/config
cd build
lb config \
  --distribution trixie \
  --architectures amd64 \
  --archive-areas "main contrib non-free-firmware" \
  --binary-images iso-hybrid \
  --debian-installer none \
  --apt-recommends true \
  --chroot-squashfs-compression-type zstd \
  --iso-application "ProOS" --iso-volume "PRO_OS" \
  --bootappend-live "boot=live components quiet splash locales=tr_TR.UTF-8 keyboard-layouts=tr timezone=Europe/Istanbul username=proos hostname=proos"
chmod +x config/hooks/live/*.hook.chroot config/includes.chroot/usr/local/bin/* 2>/dev/null || true
lb build
ISO=$(ls -1 *.iso | head -n1)
mv "$ISO" ../ProOS.iso
echo "Hazır: ProOS.iso"
