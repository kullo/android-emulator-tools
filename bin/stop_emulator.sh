#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

function print_usage() {
    echo "Usage: $0 port"
    echo "  port: the ADB port of the device"
}

if [ $# -ne 1 ]; then
    print_usage
    exit 1
fi

if [ $# -eq 1 ] && [ "$1" == "--help"  ]; then
    print_usage
    exit 0
fi

if ! which expect ; then
    echo "Error: command 'expect' not found."
    exit 1
fi

PORT=$1
AUTH=$(cat "$HOME/.emulator_console_auth_token")

expect << EOF
spawn telnet localhost $PORT
expect "OK"
send   "auth $AUTH\r"
expect "OK"
send   "kill\r"
expect "OK"
send   "exit\r"
EOF
