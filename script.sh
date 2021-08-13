#!/bin/ash

set -euo pipefail

exploit() {
    debug=0

    echo "Start download Danbi FW..." > /tmp/script_debug

    /usr/bin/curl "https://fwdown.s3.ap-northeast-2.amazonaws.com/mir4ag/2.3.5/mir4ag-V2.3.5.bin" -o /tmp/danbi_fw.bin
    debug=$?
    echo "FW download curl return value : ${debug}"

    echo "Done download Danbi FW...FW update start..." >> /tmp/script_debug

    mtd -e OS1 -r write /tmp/danbi_fw.bin OS1
    debug=$?
    echo "FW update mtd return value : ${debug}"
}

# From https://stackoverflow.com/a/16159057
"$@"