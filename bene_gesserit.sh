# run in the machine with dwarfdump, dwarf2json, vol2, and vol3 installed
# 1 create vol2 profile.zip
# 2 create vol3 profile.json
# 3 run vol2 and vol3

#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: $0 ARCHIVE_FILE (archive.tar from prev script)"
    exit 1
fi
name=$(basename "$1")
name=${name%.tar}
cd /tmp/
tar xvf ./"$name".tar
dwarfdump -di module.ko > module.dwarf
zip ./"$name".zip module.dwarf System.map*
cp ./"$name".zip ~/tools/volatility/volatility/plugins/overlays/linux/
dwarf2json linux --elf vmlinux --system-map System.map* > ./"$name".json
cp ./"$name".json ~/tools/volatility3/volatility3/symbols/linux/
rm -f System.map* module.* vmlinux
python2 ~/tools/volatility/vol.py -f mem-"$name".* --profile=Linux$(echo "$name" | tr '.' '_')x64 linux_pslist
python3 ~/tools/volatility3/vol.py -f mem-"$name".* linux.pslist
