# Arch Linux Installation Guide
## ThinkPad X1 Carbon Gen 9

---

## Pre-Installation

### Boot the Arch ISO
```bash
# Verify boot mode (should show files for UEFI)
ls /sys/firmware/efi/efivars

# Connect to internet via ethernet or wifi
iwctl
  station wlan0 scan
  station wlan0 connect "SSID"
  exit

ping archlinux.org
timedatectl set-ntp true
```

---

## Partition the Disk

```bash
lsblk                          # confirm disk is nvme0n1
fdisk /dev/nvme0n1
```

Inside `fdisk`:
```
g        # new GPT partition table

n        # partition 1 — EFI
<enter>  # default partition number (1)
<enter>  # default first sector
+1G      # size

t        # change type
1        # select partition 1
1        # type: EFI System

n        # partition 2 — boot
<enter>  # default partition number (2)
<enter>  # default first sector
+1G      # size
         # type stays Linux filesystem (default, no change needed)

n        # partition 3 — LUKS
<enter>  # default partition number (3)
<enter>  # default first sector
<enter>  # rest of disk

t        # change type
3        # select partition 3
44       # type: Linux LVM

p        # print and verify layout
w        # write and exit
```

Your layout should look like:
```
Device           Start       End   Sectors  Size Type
/dev/nvme0n1p1   2048   2099199   2097152    1G  EFI System
/dev/nvme0n1p2   2099200  4196351   2097152    1G  Linux filesystem
/dev/nvme0n1p3   4196352  ...      ...       rest Linux LVM
```

---

## Format EFI and Boot

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
```

---

## Set Up LUKS Encryption

```bash
# Encrypt the third partition
cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme0n1p3

# Verify the settings
cryptsetup luksDump /dev/nvme0n1p3

# Open the encrypted container
cryptsetup open /dev/nvme0n1p3 cryptlvm
```

---

## Set Up LVM Inside LUKS

```bash
# Create physical volume
pvcreate /dev/mapper/cryptlvm

# Create volume group
vgcreate vg0 /dev/mapper/cryptlvm

# Create swap (32GB)
lvcreate -L 32G vg0 -n swap

# Create root (remaining space)
lvcreate -l 100%FREE vg0 -n root

# Format volumes
mkfs.ext4 /dev/vg0/root
mkswap /dev/vg0/swap
```

---

## Mount Everything

```bash
mount /dev/vg0/root /mnt

mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot

mkdir /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

swapon /dev/vg0/swap
```

---

## Install Base System

```bash
pacstrap /mnt base base-devel linux linux-firmware \
  lvm2 grub efibootmgr \
  networkmanager vim sudo
```

---

## Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab   # verify it looks correct
```

---

## Chroot In

```bash
arch-chroot /mnt
```

---

## System Configuration

```bash
# Timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Locale
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf

# Hostname
echo "thinkpad" > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   thinkpad.localdomain thinkpad
EOF

# Root password
passwd
```

---

## Configure mkinitcpio

Edit `/etc/mkinitcpio.conf` — find the `HOOKS` line and make it:

```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
```

The critical additions are **`encrypt`** and **`lvm2`**, placed before `filesystems`.

```bash
mkinitcpio -P
```

---

## Install & Configure GRUB

```bash
grub-install --target=x86_64-efi \
  --efi-directory=/boot/efi \
  --bootloader-id=GRUB \
  --recheck
```

### Get the LUKS UUID

```bash
blkid /dev/nvme0n1p3
# Copy the UUID value
```

### Edit GRUB defaults

Edit `/etc/default/grub`, find `GRUB_CMDLINE_LINUX` and set:

```
GRUB_CMDLINE_LINUX="cryptdevice=UUID=<YOUR-UUID-HERE>:cryptlvm root=/dev/vg0/root"
```

Also uncomment:
```
GRUB_ENABLE_CRYPTODISK=y
```

### Generate GRUB config

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Enable Services & Create User

```bash
# Enable NetworkManager for post-boot networking
systemctl enable NetworkManager

# Create a regular user
useradd -m -G wheel -s /bin/bash yourusername
passwd yourusername

# Allow wheel group to use sudo
EDITOR=vim visudo
# Uncomment:  %wheel ALL=(ALL:ALL) ALL
```

---

## Reboot

```bash
exit              # exit chroot
umount -R /mnt
swapoff /dev/vg0/swap
reboot
```

Remove the USB drive when the screen goes blank. GRUB will prompt for your LUKS passphrase on every boot before handing off to the system.

---

## ThinkPad X1 Carbon Gen 9 — Post-Install Tips

| Thing | Package |
|---|---|
| Intel microcode (auto-applied via `microcode` hook) | `intel-ucode` — add if not pulled in |
| Wifi (Intel AX201) | included in `linux-firmware` |
| Touchpad | `xf86-input-libinput` if you add X11 |
| Throttling fix | `throttled` (AUR) |
| Power management | `tlp` + `tlp-rdw` |
| Fingerprint reader | `fprintd` + `libfprint` |

Install `intel-ucode` now if not already present:
```bash
pacman -S intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg
```
