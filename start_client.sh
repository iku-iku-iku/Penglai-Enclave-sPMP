#!/bin/bash


BR=br0
TAP=tap0

sudo tunctl -d $TAP
sudo tunctl -t $TAP -u $(whoami)
sudo ip link set $TAP up
sudo ip link set $TAP master $BR

# For openEuler version is 20.03
sudo /opt/qemu/bin/qemu-system-riscv64 \
-nographic \
-machine virt \
					-smp 4 -m 4G \
					-kernel  ./opensbi-1.2/build-oe/qemu-virt/platform/generic/firmware/fw_payload.elf  \
					-drive file=openEuler-preview.riscv64.qcow2,format=qcow2,id=hd0 \
					-object rng-random,filename=/dev/urandom,id=rng0 \
					-device virtio-rng-device,rng=rng0 \
					-device virtio-blk-device,drive=hd0  \
-netdev tap,id=net0,ifname=$TAP,script=no,downscript=no -device virtio-net-device,netdev=net0,mac=52:54:00:12:34:57 \
					-append 'ip=192.168.1.152:255.255.255.0::eth0:off root=/dev/vda1 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon' \
					-bios none
