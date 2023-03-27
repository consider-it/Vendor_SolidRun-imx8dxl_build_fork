#!/bin/bash
## Setup steps on first boot

set -eou pipefail


## Create partitions
echo "-------- FIRST BOOT: Creating Partitions"
/usr/sbin/sfdisk -f /dev/mmcblk0 < /opt/partitions.sfdisk
partx -u -n 1 /dev/mmcblk0
partx -a -n 3 /dev/mmcblk0
partx -a -n 4 /dev/mmcblk0
sleep 10 # it takes some time until lsblk lists the file system

echo "-------- FIRST BOOT: Expanding Root"
/usr/sbin/resize2fs /dev/mmcblk0p1

echo "-------- FIRST BOOT: Creating /mnt/src FS"
lsblk_p3=$(lsblk -f | grep mmcblk0p3 | cut -c 3- | xargs)
if [ ${#lsblk_p3} -gt 9 ]; then
  p3_fstype=${lsblk_p3:10:5}
  echo "mmcblk0p3: already contains some file system: $p3_fstype"
else
  /usr/sbin/mkfs.ext4 /dev/mmcblk0p3
fi

mkdir /mnt/src && echo "/dev/mmcblk0p3 /mnt/src ext4 defaults 0 2" >> /etc/fstab || true

echo "-------- FIRST BOOT: Creating /mnt/rw FS"
lsblk_p4=$(lsblk -f | grep mmcblk0p4 | cut -c 3- | xargs)
if [ ${#lsblk_p4} -gt 9 ]; then
  p4_fstype=${lsblk_p4:10:5}
  echo "mmcblk0p4: already contains some file system: $p4_fstype"
else
  /usr/sbin/mkfs.ext4 /dev/mmcblk0p4
fi

mkdir /mnt/rw && echo "/dev/mmcblk0p4 /mnt/rw ext4 defaults 0 2" >> /etc/fstab || true


## Extract v2x-bundle
cd /root
echo "-------- FIRST BOOT: Extracting V2X Software"
tar -C / -xf v2x-bundle.tar.xz


## remove ourselves and reboot
echo "-------- FIRST BOOT: Cleaning up"
rm -f /opt/firstboot.sh
rm -f /opt/partitions.sfdisk
rm -f /etc/cron.d/firstboot

systemctl reboot
