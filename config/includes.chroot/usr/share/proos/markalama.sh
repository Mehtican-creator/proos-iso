#!/bin/bash
# ProOS: sistemde gorunen "Debian" yazilarini ProOS yapar.
# Kullanim:  sudo bash markalama.sh
set -e
R="${PROOS_ROOT:-}"
[ -n "$R" ] || [ "$(id -u)" = 0 ] || { echo "sudo ile calistir:  sudo bash markalama.sh"; exit 1; }
yedek() { [ -e "$1" ] && [ ! -e "$1.proos-yedek" ] && cp -a "$1" "$1.proos-yedek" || true; }
say() { echo "==> $*"; }

say "1/5 Sistem adi (os-release, issue, lsb-release)"
mkdir -p "$R/usr/lib" "$R/etc"
yedek "$R/usr/lib/os-release"
cat > "$R/usr/lib/os-release" <<'EOT'
PRETTY_NAME="ProOS 1.0"
NAME="ProOS"
VERSION_ID="1.0"
VERSION="1.0"
ID=proos
ID_LIKE=debian
LOGO=proos
EOT
[ -L "$R/etc/os-release" ] || { yedek "$R/etc/os-release"; cp "$R/usr/lib/os-release" "$R/etc/os-release"; }
printf 'ProOS 1.0 \\n \\l\n\n' > "$R/etc/issue"
printf 'ProOS 1.0\n' > "$R/etc/issue.net"
: > "$R/etc/motd"
cat > "$R/etc/lsb-release" <<'EOT'
DISTRIB_ID=ProOS
DISTRIB_RELEASE=1.0
DISTRIB_DESCRIPTION="ProOS 1.0"
EOT

say "2/5 Onyukleyici (GRUB) basligi ve arka plani"
G="$R/etc/default/grub"
if [ -f "$G" ]; then
  yedek "$G"
  if grep -q '^GRUB_DISTRIBUTOR=' "$G"; then sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="ProOS"/' "$G"; else echo 'GRUB_DISTRIBUTOR="ProOS"' >> "$G"; fi
  BG=/usr/share/backgrounds/proos/proos-login.png
  if [ -f "$R$BG" ]; then
    sed -i '/^GRUB_BACKGROUND=/d' "$G"; echo "GRUB_BACKGROUND=\"$BG\"" >> "$G"
  fi
fi
# desktop-base'in Debian temali GRUB ekranini kapat
[ -f "$R/etc/grub.d/05_debian_theme" ] && chmod -x "$R/etc/grub.d/05_debian_theme" || true
if [ -z "$R" ] && [ -z "$PROOS_NO_UPDATE_GRUB" ] && command -v update-grub >/dev/null 2>&1; then update-grub 2>&1 | tail -3 || true; fi

say "3/5 Menu kategorileri"
for f in "$R"/usr/share/desktop-directories/debian*.directory; do
  [ -f "$f" ] || continue
  yedek "$f"
  sed -i 's/^Name=.*Debian.*/Name=ProOS/; s/^Name\[\([^]]*\)\]=.*Debian.*/Name[\1]=ProOS/' "$f"
done

say "4/5 Kurulum sihirbazi (Calamares)"
for f in "$R/etc/calamares/modules/bootloader.conf" "$R/usr/share/calamares/modules/bootloader.conf"; do
  [ -f "$f" ] || continue
  yedek "$f"
  sed -i 's/^\(efiBootloaderId:\).*/\1 "ProOS"/; s/^\(bootloaderEntryName:\).*/\1 "ProOS"/' "$f"
  grep -q '^efiBootloaderId:' "$f" || echo 'efiBootloaderId: "ProOS"' >> "$f"
done
for f in "$R"/etc/calamares/branding/proos/branding.desc "$R"/usr/share/proos/calamares-proos/branding.desc; do
  [ -f "$f" ] || continue
  sed -i 's/Pro OS/ProOS/g' "$f"
done

say "5/5 Kalan 'Debian' yazilari taraniyor (gorunebilecek yerler)"
{
  grep -rIn --include='*.desktop' --include='*.directory' --include='*.conf' --include='*.rc' --include='*.xml' -i 'debian' \
    "$R/usr/share/applications" "$R/usr/share/desktop-directories" "$R/etc/xdg" "$R/etc/lightdm" "$R/etc/calamares" 2>/dev/null | grep -vi 'debian-archive\|debian-keyring\|dpkg\|apt' | head -30
} || true
echo
echo "Tamam. Degisikliklerin gorunmesi icin:  sudo reboot"
echo "Not: cekirdek surum satiri (uname -a), paket adlari ve lisans dosyalari teknik nedenlerle degismez."
