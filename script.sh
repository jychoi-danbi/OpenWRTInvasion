#!/bin/ash

set -euo pipefail

exploit() {
    echo "Start download Danbi FW..." > /tmp/script_debug

    # /usr/bin/curl "https://fwdown.s3.ap-northeast-2.amazonaws.com/mir4ag/2.3.5/mir4ag-V2.3.5.bin" -o /tmp/danbi_fw.bin
    /usr/bin/wget "https://fwdown.s3.ap-northeast-2.amazonaws.com/mir4ag/2.3.5/mir4ag-V2.3.5.bin" -O /tmp/danbi_fw.bin
    # echo "FW download curl return value : $?" >> /tmp/script_debug
    echo $? >> /tmp/script_debug

    echo "Done download Danbi FW...FW update start..." >> /tmp/script_debug

    mtd -e OS1 -r write /tmp/danbi_fw.bin OS1
    # echo "FW update mtd return value : $?" >> /tmp/script_debug
    echo $? >> /tmp/script_debug
}

# From https://stackoverflow.com/a/16159057
"$@"