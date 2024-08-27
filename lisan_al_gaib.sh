# run in the target machine with kernel, kernel-devel, kernel-debuginfo, and kernel-debuginfo-common installed
# 1 clone repo
# 2 make volatility module
# 3 make lime module
# 4 dump memory
# 5 copy misc
# 6 create archive

#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: $0 OS_NAME (eg: script.sh RHEL99)"
    exit 1
fi
os_name="$1"
cd /tmp/
git clone https://github.com/volatilityfoundation/volatility
git clone https://github.com/504ensicsLabs/LiME
cd /tmp/volatility/tools/linux/
make
cp ./module.ko /tmp/
cd /tmp/LiME/src/
make
rmmod lime
insmod lime-$(uname -r).ko "path=mem-"$os_name"_$(uname -r).lime format=lime"
mv ./mem-"$os_name"_$(uname -r).lime /tmp/
cd /tmp/
cp /boot/System.map-$(uname -r) ./
cp /usr/lib/debug/lib/modules/$(uname -r)/vmlinux ./
tar cvf "$os_name"_$(uname -r).tar module.ko vmlinux System.map-$(uname -r) mem-"$os_name"_$(uname -r).lime
rm -f module.ko vmlinux System.map-$(uname -r) mem-"$os_name"_$(uname -r).lime
