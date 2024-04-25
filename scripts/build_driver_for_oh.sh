#!/bin/bash
echo "Begin building penglai enclave"
if [ ! -d "oh-kernel" ]; then
    wget -O oh-kernel.tar.gz https://ipads.se.sjtu.edu.cn:1313/f/23d8465436fd47929c7f/?dl=1
    tar -zxvf oh-kernel.tar.gz
fi

docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --network=host --rm -it ddnirvana/penglai-enclave:v0.5 bash -c "
cd /home/penglai/penglai-enclave/penglai-enclave-driver
CROSS_COMPILE=riscv64-unknown-linux-gnu- make
"
echo "Finished"
