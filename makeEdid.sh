export PATH ="$coreutils/bin:$gawk/bin"

base64 < $src | awk '{printf $0}' | base64 -d > "./SP8vrr120.bin"
