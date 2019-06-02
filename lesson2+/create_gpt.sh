#!/bin/bash

sudo mdadm --create --verbose /dev/md10 --level=10 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
sudo mdadm --create --verbose /dev/md5 --level=5 --raid-devices=3 /dev/sdf /dev/sdg /dev/sdh 
 echo "Create GPT disk 10"
sudo sudo fdisk /dev/md10 << EOF
g
n



w
EOF
sudo echo "Create GPT disk 5"
sudo fdisk /dev/md5 << EOF
g
n



w
EOF
sudo mkfs.ext4 /dev/md10
sudo mkfs.ext4 /dev/md5
sudo mkdir /mnt-raid10 
sudo mkdir /mnt-raid5
sudo echo "/dev/md5     /mnt-raid5     ext4     defaults   0   0" >>/etc/fstab
sudo echo "/dev/md10     /mnt-raid10    ext4     defaults   0   0" >>/etc/fstab
sudo mount /dev/md5 /mnt-raid5
sudo mount /dev/md10 /mnt-raid10
