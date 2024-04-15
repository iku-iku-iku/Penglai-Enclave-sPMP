#/bin/bash
docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave \
-e http_proxy=http://172.17.0.1:7890 \
-e https_proxy=https://172.17.0.1:7890 \
--rm -it ddnirvana/penglai-enclave:v0.5 bash -c "
cp openeuler-kernel/arch/riscv/boot/Image .
cd /home/penglai/penglai-enclave/opensbi-1.2
mkdir -p build-oe/qemu-virt
CROSS_COMPILE=riscv64-unknown-linux-gnu- make O=build-oe/qemu-virt PLATFORM=generic FW_PAYLOAD=y FW_PAYLOAD_PATH=/home/penglai/penglai-enclave/Image
"
