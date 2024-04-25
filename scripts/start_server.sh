#!/bin/bash

BR=br0
TAP=tap0

sudo ip tuntap del dev $TAP mode tap
sudo ip tuntap add dev $TAP mode tap user $(whoami)

sudo ip link set $TAP up
sudo ip link set $TAP master $BR


root_path=$(pwd)
board=riscv64_virt
cpus=1
memory=8096
image_path=${root_path}/out/${board}/packages/phone/images2
QEMU=$(which qemu-system-riscv64)
sudo $QEMU \
    -name PolyOS-1 \
    -machine virt \
    -m ${memory} \
    -smp ${cpus} \
    -no-reboot \
    -netdev tap,id=net0,ifname=$TAP,script=no,downscript=no \
	-device virtio-net-device,netdev=net0,mac=12:22:33:44:55:66 \
    -drive if=none,file=${image_path}/updater.img,format=raw,id=updater,index=5 \
    -device virtio-blk-device,drive=updater \
    -drive if=none,file=${image_path}/system.img,format=raw,id=system,index=4 \
    -device virtio-blk-device,drive=system \
    -drive if=none,file=${image_path}/vendor.img,format=raw,id=vendor,index=3 \
    -device virtio-blk-device,drive=vendor \
    -drive if=none,file=${image_path}/userdata.img,format=raw,id=userdata,index=2 \
    -device virtio-blk-device,drive=userdata \
    -drive if=none,file=${image_path}/sys_prod.img,format=raw,id=sys-prod,index=1 \
    -device virtio-blk-device,drive=sys-prod \
    -drive if=none,file=${image_path}/chip_prod.img,format=raw,id=chip-prod,index=0 \
    -device virtio-blk-device,drive=chip-prod \
    -append "loglevel=1 ip=192.168.1.151:255.255.255.0::eth0:off sn=0023456789 console=tty0,115200 console=ttyS0,115200 init=/bin/init ohos.boot.hardware=virt root=/dev/ram0 rw ohos.required_mount.system=/dev/block/vdb@/usr@ext4@ro,barrier=1@wait,required ohos.required_mount.vendor=/dev/block/vdc@/vendor@ext4@ro,barrier=1@wait,required ohos.required_mount.sys_prod=/dev/block/vde@/sys_prod@ext4@ro,barrier=1@wait,required ohos.required_mount.chip_prod=/dev/block/vdf@/chip_prod@ext4@ro,barrier=1@wait,required ohos.required_mount.data=/dev/block/vdd@/data@ext4@nosuid,nodev,noatime,barrier=1,data=ordered,noauto_da_alloc@wait,reservedsize=1073741824 ohos.required_mount.misc=/dev/block/vda@/misc@none@none=@wait,required" \
    -kernel ${image_path}/Image \
    -initrd ${image_path}/ramdisk.img \
    -nographic \
    -device virtio-mouse-pci \
    -device virtio-keyboard-pci \
	-bios fw_jump.bin
    #-display sdl,gl=off

exit
