#!/bin/ash

set -euo pipefail

exploit() {
    echo "Start download Danbi FW..."

    /usr/bin/curl "https://fwdown.s3.ap-northeast-2.amazonaws.com/mir4ag/2.3.5/mir4ag-V2.3.5.bin" -o /tmp/danbi_fw.bin

    echo "Done download Danbi FW...FW update start..."

    mtd -e OS1 -r write /tmp/danbi_fw.bin OS1
}

# From https://stackoverflow.com/a/16159057
"$@"