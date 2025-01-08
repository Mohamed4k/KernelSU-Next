#!/bin/bash
# copy right by zetaxbyte
# you can rich me on telegram t.me/@zetaxbyte
# flags of proton clang
sudo apt-get install clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python3-clang

sudo apt-get install gcc-aarch64-linux-gnu
sudo apt-get install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu                                                                                                                                               
git clone https://github.com/Mohamed4k/android_samsung_kernel_SM-G981N.git --depth=1 kernel
cd kernel
if [ -d $(pwd)/../proton-clang ] ; then
echo -e "\n lets's go \n"
else
echo -e "\n \033[91mproton-clang dir not found!!!\033[0m \n"
sleep 2
echo -e "\033[93m wait.. cloning proton-clang...\033[0m \n"
sleep 2
git clone https://gitlab.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-r536225 --depth=1 $(pwd)/proton-clang
sleep 1
echo
echo -e "\n \033[92mokay cloning done...\033[0m \n"
sleep 1
fi

cyan="\033[96m"
green="\033[92m"
red="\033[91m"
blue="\033[94m"
yellow="\033[93m"

echo -e "$cyan===========================\033[0m"
echo -e "$cyan= START COMPILING KERNEL  =\033[0m"
echo -e "$cyan===========================\033[0m"

echo -e "$blue...LOADING...\033[0m"

echo -e -ne "$green## (10%\r"
sleep 0.7
echo -e -ne "$green#####                     (33%)\r"
sleep 0.7
echo -e -ne "$green#############             (66%)\r"
sleep 0.7
echo -e -ne "$green#######################   (100%)\r"
echo -ne "\n"

echo -e -n "$yellow\033[104mPRESS ENTER TO CONTINUE\033[0m"
read P
echo  $P

# change DEFCONFIG to you are defconfig name or device codename

DEFCONFIG="vendor/x1q_kor_singlex_defconfig"

# you can set you name or host name(optional)

export KBUILD_BUILD_USER="Sudoooo"
export KBUILD_BUILD_HOST="Dark-Angel"

# do not modify TC_DIR and export PATCH it's been including with the proton-clang dir

TC_DIR="$(pwd)/proton-clang"
git clone  https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 --depth=1 gcc
export CROSS_COMPILE_ARM32=$(pwd)/gcc/bin/arm-linux-androideabi-    
export CROSS_COMPILE=$(pwd)/gcc/bin/aarch64-linux-android-
export PATH="$TC_DIR/bin:$PATH"
export CONFIG_NO_ERROR_ON_MISMATCH=y
export CONFIG_DEBUG_SECTION_MISMATCH=y
mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG

make -j$(nproc --all) O=out ARCH=arm64 CC=clang AR=llvm-ar NM=llvm-nm KCFLAGS=-w OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump W=1 STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt
make KCFLAGS=-w O=out
if [ -f out/arch/arm64/boot/Image ] ; then
    echo -e "$cyan===========================\033[0m"
    echo -e "$cyan=  SUCCESS COMPILE KERNEL =\033[0m"
    echo -e "$cyan===========================\033[0m"
else
echo -e "$red!ups...something wrong!?\033[0m"
fi
