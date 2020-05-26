# rocker

This project is purely around building basic understanding around kernel cgroups and namespace. It simply runs a command in a container. It uses the cgcreate, cgexec, cgset, cgdelete, unshare, and chroot commands to initialize the container.

###Prerequisites

The following are required.

- bash
- unshare
- cgcreate
- cgexec
- cgset
- cgdelete
- uuidgen
- bc
- docker (required only to pull docker base OS images, currently busybox)

Most of these other than 'bc' and 'libcgroup-tools' are installed already on most systems.


### Usage

./rocker.sh

### TODO
Add netnamespace 

### Example to replace Docker with an ISO image

 - $ mkdir centos7 squash root rootfs
 - $ wget -q http://centos.openitc.uk/7.0.1406/isos/x86_64/CentOS-7.0-1406-x86_64-DVD.iso
 - $ sudo mount -o loop,ro CentOS-7.0-1406-x86_64-DVD.iso centos7/
 - $ sudo mount -o loop,ro centos7/LiveOS/squashfs.img squashfs/
 - $ sudo mount -o loop,ro squashfs/LiveOS/rootfs.img root/
 - $ sudo cp -aR root/* rootfs/
 - $ sudo umount root/
 - $ sudo umount squashfs/
 - $ sudo umount centos7/
 - $ rm -rf centos7 squash root CentOS-7.0-1406-x86_64-DVD.iso

###Note

Currently it uses busybox but can be any other OS. Still need to add network/IP associated.

