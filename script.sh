#!/bin/ash

set -euo pipefail

ping_chk()
{
    if [ -z "$1" ]; then
        echo "Ping network chk error! [URL isn't a nullable value]"
    else
        ping -c 1 -W 1 $1
        
        if [ $? -eq 0 ]; then
            echo "Ping network check [$1] success!" >> /tmp/script_debug
        else
            echo "Ping network check [$1] failed!" >> /tmp/script_debug
        fi
    fi
}

exploit() {
    echo "Start download Danbi FW..." > /tmp/script_debug

    ping_chk "8.8.8.8"
    ping_chk "https://fwdown.s3.ap-northeast-2.amazonaws.com"

    scp "~/work/dev/firmware/mir4ag-V2.3.5.bin" "root@192.168.31.1:/tmp/"
    echo $? >> /tmp/script_debug

    echo "$(ssh -i /lib/danbi_router.dbear root@192.168.9.1 'ls -al /tmp/mir4ag-V2.3.5.bin')" >> /tmp/script_debug

    echo "Done download Danbi FW...FW update start..." >> /tmp/script_debug

    mtd -e OS1 -r write /tmp/danbi_fw.bin OS1
    echo $? >> /tmp/script_debug
}

# From https://stackoverflow.com/a/16159057
"$@"