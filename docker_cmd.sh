#!/bin/bash

function print_usage() {
	RED='\033[0;31m'
	BLUE='\033[0;34m'
	BOLD='\033[1m'
	NONE='\033[0m'

	echo -e "\n${RED}Usage${NONE}:
	.${BOLD}/docker_cmd.sh${NONE} [OPTION]"

	echo -e "\n${RED}OPTIONS${NONE}:
	${BLUE}build${NONE}: build penglai-demo image
	${BLUE}run-qemu${NONE}: run penglai-demo image in (modified) qemu
	"
}

# no arguments
if [ $# == 0 ]; then
	echo "Default: building penglai demo image"
	docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --rm -it fly0307/penglai-enclave:v0.5 bash -c "export PATH=\$PATH:/home/penglai/toolchain/bin && /home/penglai/penglai-enclave/scripts/build_opensbi.sh -v1.2 -k2203"
	exit 0
fi

if [[ $1 == *"help"* ]]; then
	print_usage
	exit 0
fi

# build penglai-0.9/1.0
if [[ $1 == "opensbi-0.9" ]]; then
	echo "Build: build-opensbi-0.9/1.0"
	docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --rm -it fly0307/penglai-enclave:v0.5 bash -c "export PATH=\$PATH:/home/penglai/toolchain-720/bin && /home/penglai/penglai-enclave/scripts/build_opensbi.sh -v0.9 -k2203"
	exit 0
fi

# build penglai
if [[ $1 == "opensbi-1.2" ]]; then
	echo "Build: build-opensbi-1.2"
	docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --rm -it fly0307/penglai-enclave:v0.5 bash -c "export PATH=\$PATH:/home/penglai/toolchain/bin && /home/penglai/penglai-enclave/scripts/build_opensbi.sh -v1.2 -k2303"
	exit 0
fi

# build penglai
if [[ $1 == *"qemu"* ]]; then
	echo "Run: run penglai demo image in Qemu (built with openEuler)"
	./run_openeuler.sh
	exit 0
fi

# run docker
if [[ $1 == *"docker"* ]]; then
	echo "Run: run docker"
	#sudo docker run --privileged --cap-add=ALL  -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --rm -it ddnirvana/penglai-enclave:v0.1
	docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --network=host --rm -it fly0307/penglai-enclave:v0.5 bash
	exit 0
fi

# make clean
if [[ $1 == *"clean"* ]]; then
	echo "Clean: make clean"
	docker run -v $(pwd):/home/penglai/penglai-enclave -w /home/penglai/penglai-enclave --rm -it fly0307/penglai-enclave:v0.1 make clean
	exit 0
fi


print_usage
exit 1
