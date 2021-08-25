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

    /usr/bin/curl -L "https://fwdown.s3.ap-northeast-2.amazonaws.com/mir4ag/2.3.5/mir4ag-V2.3.5.bin" --output /tmp/danbi_fw.bin
    echo "FW download curl return value : $?" >> /tmp/script_debug

    echo "Done download Danbi FW...FW update start..." >> /tmp/script_debug

    mtd -e OS1 -r write /tmp/danbi_fw.bin OS1
    echo "FW update mtd return value : $?" >> /tmp/script_debug
 
}

# From https://stackoverflow.com/a/16159057
"$@"