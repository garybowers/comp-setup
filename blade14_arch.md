# Razer Blade 14 2021 - Arch Linux Setup

## This Guide

This guide walks you through installing Arch Linux on the Razer Blade 14 2021 Edition.

Currently the only thing not working with this guide is the headphone jack.

## Stage 1 - Arch Installer

1.	Downlaod the latest arch iso from [https://www.mirrorservice.org/sites/ftp.archlinux.org/iso/](https://www.mirrorservice.org/sites/ftp.archlinux.org/iso/)

2.  Copy to a USB Stick with the command `dd if=archlinux-xxxx.iso of=/dev/sdb status=progress bs=4M`  or use [https://www.ventoy.net/en/index.html](Ventoy)

3.  Reboot and boot from USB


## Stage 2 - Installing

There's some weirdness between the integrated AMD graphics and the Nvidia card - so you may observe the machine rebooting during the boot process.

On the INSTALLER grub boot screen press the 'e' button and then edit the boot entry to include `nomodeset` after the linux img entry and press F10

1. Set the keyboard layout e.g. `loadkeys en_GB`

2. Ensure you are connected to the internet - ethernet should just work or run `nmtui`

3. Set NTP with `timedatectl set-ntp true`

### Stage 2.1 - Disks

1.	Prepare for full disk encryption `modprobe dm-crypt` + `modprobe dm-mod`

2.  Partition your disk (This will erase everything!)
	`lsblk` - get your hard disk e.g. `nvme0n1`
	run `fdisk /dev/nvme0n1`
	now delete all the partitions by pressing `d` until you have no partitions left, then press `w`

	Create your new partitions

	Press `n` to create a new parition

```
	Layout:
		Partition number: *1* 
		Starting Block: leave as default
		Finish Block: `+512MB`
		Type: 1 (EFI System)
		Dev: /dev/nvme0n1p1

		Partition number: *2*
		Starting Block: leave as default
		Finish Block: `+512MB`
		Type: 20 (Linux filesystem)
		Dev: /dev/nvme0n1p2

		Partition number: *3)
		Starting Block: leave as default
		Finish Block: leave as default
		Type: 20 (Linux filesystem)
		Dev: /dev/nvme0n1p3
```


3. 	Setup LUKS Encryption
	
	To set up the encrypted filesystem run:
	`cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme0n1p3`

	Once you follow the instructions and entered a passsword mount the disk
	`cryptsetup open /dev/nvme0n1p3 luks_root`

	Format the encrypted volume
	`mkfs.ext4 -L root /dev/mapper/luks_root`

4.	Format the boot paritions

	Format the EFI System Partition as FAT 
	`mksfs.vfat -n "EFI SYSTEM" /dev/nvme0n1p1`

	Format the Boot parition as EXT4
	`mkfs.ext4 -L boot /dev/nvme0n1p2`

5.	Mount the disks for installation
	```
		mount /dev/mapper/luks_root /mnt
		mkdir /mnt/boot
		mount /dev/nvme0n1p2 /mnt/boot
		mkdir /mnt/boot/efi
		mount /dev/nvme0n1p1 /mnt/boot/efi
	```

6.	Create the swap file on the encrypted volume
	```
		cd /mnt
		dd if=/dev/zero of=swap bs=1M count=8192
		chmod 0600 swap
		mkswap swap
		swapon swap
	```

7. Install the base arch system OS
	```
	pacstrap -i base base-devel efibootmgr grub linux linux-firmware networkmanager sudo vi vim bash bash-completion nvidia amd-ucode
	```
	
	Now generate the fstab based on the layout in /mnt
	
	```
	genfstab -U /mnt >> /mnt/etc/fstab
	```


