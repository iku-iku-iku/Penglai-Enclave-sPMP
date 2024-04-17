#!/bin/bash
if [ ! -d "oh-kernel" ]; then
    wget https://filebin.net/m6q51s538bgd12p1/oh-kernel.tar.gz
    tar -zxvf oh-kernel.tar.gz
fi

docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --network=host --rm -it ddnirvana/penglai-enclave:v0.5 bash -c "
cd /home/penglai/penglai-enclave/penglai-enclave-driver
CROSS_COMPILE=riscv64-unknown-linux-gnu- make
"
