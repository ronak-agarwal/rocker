#!/usr/bin/env bash

UUID=$(uuidgen)
mkdir rootfs
docker export $(docker create busybox) | gzip -c > busybox.tar.gz
tar -xf busybox.tar.gz -C rootfs/
ROOTFS=rootfs/

# TODO: Networking support
# Initialize networking
# NETID=${UUID:0:8}
# ip link add dev veth0_"$NETID" type veth peer name veth1_"$NETID"
# ip link set dev veth0_"$NETID" up
# ip link set veth0_"$NETID" master bridge0
# ip netns add netns_"$NETID"
# ip link set veth1_"$NETID" netns netns_"$NETID"
# ip netns exec netns_"$NETID" ip link set dev lo up

# # Assign an IP and MAC address
# IP=$(shuf -i 2-254 -n 1)
# MAC=${IP:-2:1}:${IP:-1:1}
# ip netns exec netns_"$NETID" ip link set veth1_"$NETID" address 02:42:ac:11:00"$MAC"
# ip netns exec netns_"$NETID" ip addr add 10.0.0."$IP"/24 dev veth1_"$NETID"
# ip netns exec netns_"$NETID" ip link set dev veth1_"$NETID" up
# ip netns exec netns_"$NETID" ip route add default via 10.0.0.1

# Set CPU and Memory
cgcreate -a "root":"root" -t "root":"root" -g cpu,memory:"$UUID"
cgset -r memory.limit_in_bytes=100000000 $UUID
cgset -r cpu.shares=512 $UUID
cgset -r cpu.cfs_period_us=1000000 $UUID
cgset -r cpu.cfs_quota_us=2000000 $UUID

# Finally run the command to start the container.
CMD="cgexec -g cpu,memory:$UUID unshare --fork --ipc --pid --uts --net -- /bin/sh -c \"/bin/hostname $UUID && chroot $ROOTFS /bin/sh -c '/bin/mount -t proc proc /proc &> /dev/null || true && /bin/sh'\""
eval "$CMD"