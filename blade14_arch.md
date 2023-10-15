# Razer Blade 14 2021 - Arch Linux Setup

## This Guide

This guide walks you through installing Arch Linux on the Razer Blade 14 2021 Edition.

The laptop has a AMD Ryzen 5900HX with AMD Graphics and a Nvidia Geforce 3xxx Graphics. 

Currently the only thing not working with this guide is the headphone jack.

## Stage 1 - Arch Installer

1.	Download the latest arch iso from [https://www.mirrorservice.org/sites/ftp.archlinux.org/iso/](https://www.mirrorservice.org/sites/ftp.archlinux.org/iso/)

2.  Copy to a USB Stick with the command `dd if=archlinux-xxxx.iso of=/dev/sdb status=progress bs=4M`  or use [https://www.ventoy.net/en/index.html](Ventoy)

3.  Reboot and boot from USB


## Stage 2 - Installing

There's some weirdness between the integrated AMD graphics and the Nvidia card - so you may observe the machine rebooting during the boot process.

On the installer's grub boot screen press the 'e' button and then edit the boot entry to include `nomodeset` after the linux img entry and press F10

1. Set the keyboard layout e.g. `loadkeys en_GB` or `loadkeys us`

2. Ensure you are connected to the internet - ethernet should just work with a USB ethernet adapter

3. Set NTP with `timedatectl set-ntp true`

4. Update the archlinux keyring

```
pacman-key --init
pacman-key --populate archlinux
pacman -Sy archlinux-keyring
```

### Stage 2.1 - Disks

##### 2.1.1  Prepare for full disk encryption

`modprobe dm-crypt` + `modprobe dm-mod`

##### 2.1.2  Partition your disk (This will erase everything!)

To get your ssd device name  e.g. `nvme0n1` use the `lsblk` command

run `fdisk /dev/nvme0n1`

now delete all the partitions by pressing `d` until you have no partitions left, then press `w` to commit the changes to the disk.

Create your new partitions

Press `g` to create a GPT style layout

Press `n` to create a new parition

```
Layout:
	Partition number: **1**
	Starting Block: leave as default
	Finish Block: `+512mb`
	Type: 1 (EFI System)
	Dev: /dev/nvme0n1p1

	Partition number: **2**
	Starting Block: leave as default
	Finish Block: `+512mb`
	Type: 20 (Linux filesystem)
	Dev: /dev/nvme0n1p2

	Partition number: **3**
	Starting Block: leave as default
	Finish Block: leave as default
	Type: 20 (Linux filesystem)
	Dev: /dev/nvme0n1p3
```

##### 2.1.3  Setup LUKS Encryption
	
To set up the encrypted filesystem run:

```
cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme0n1p3
```

Once you follow the instructions and entered a passsword open the disk:

```
cryptsetup open /dev/nvme0n1p3 luks_root
```

##### 2.1.4  Create the volume groups and logical volumes

Create the volume groups

```
pvcreate /dev/mapper/luks_root
```

```
vgcreate VolGroup /dev/mapper/luks_root
```

Now create the logical volumes

```
lvcreate -L 16G VolGroup -n swap
lvcreate -l 100%FREE VolGroup -n root
```

##### 2.1.5  Format the paritions

Format the EFI System Partition as FAT

```
mksfs.vfat -n "EFI SYSTEM" /dev/nvme0n1p1
```

Format the Boot parition as EXT4

```
mkfs.ext4 -L boot /dev/nvme0n1p2
```

Format the Root partition as EXT4

```
mkfs.ext4 -L root /dev/VolGroup/root
```

Enable swap

```
mkswap /dev/VolGroup/swap
swapon /dev/VolGroup/swap
```

##### 2.1.6  Mount the disks for installation

```
mount /dev/mapper/luks_root /mnt
mount --mkdir /dev/nvme0n1p2 /mnt/boot
mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi
```


### Stage 2.2 - Install the base arch system

```
pacstrap -i /mnt base base-devel efibootmgr grub linux linux-firmware networkmanager sudo vi vim bash bash-completion nvidia amd-ucode lvm2
```
	
Now generate the fstab based on the layout in /mnt
	
```
genfstab -U /mnt >> /mnt/etc/fstab
````

### Stage 2.3 - Configure the arch system

Now it's time to drop into the new arch system and configure it for boot.

```
arch-chroot /mnt
```

##### Set the hostname

```
echo 'HOSTNAME' >> /etc/hostname
```

##### Set the keyboard layout
```
echo 'KEYMAP=en_GB' >> /etc/vconsole.conf
```

##### Set the language

```
echo 'LANG=en_GB.UTF-8' >> /etc/locale.conf
```

##### Set the locale

```
echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
```

##### Set the hosts file

```
echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
echo '127.0.1.1 hostname.my.domain.tld hostname' >> /etc/hosts
```

##### Set the root user password

```
passwd root
```

##### Configure the bootloader

Edit the grub file using  `vim /etc/default/grub`

locate the line with `GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"`

edit this to the following: 

`GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 nvidia-drm.modeset=1"` (don't forget the quotes)

Locate the line with `GRUB_CMDLINE_LINUX=""` and change to read:
`GRUB_CMDLINE_LINUX="cryptdevice=/dev/nvme0n1p3:luks_root root=/dev/VolGroup/root"`

Save and exit with escape :wq

**Install Grub:**

```
grub-install --boot-directory=/boot --efi-directory=/boot/efi /dev/nvme0n1p2
grub-mkconfig -o /boot/grub/grub.cfg
grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
```

##### Initramfs

Edit the `/etc/mkinitcpio.conf` file and look for the `HOOKS=` section, after the `block` entry add the entry `encrypt` and `lvm2`

e.g.

```
HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
```

Save and exit

Execute `mkinitcpio -p linux`

##### Reboot

To reboot type exit to exit out of the chroot and then type reboot.

##### Setup

Once the system has booted off the internal SSD, login as root and your password set above.

You will need to setup your network connection to do this run:
`systemctl enable --now NetworkManager`

Then run nmtui to configure your network.

Use pacman to install the various packages, have a look at my setup_arch script in this repo for an example.
