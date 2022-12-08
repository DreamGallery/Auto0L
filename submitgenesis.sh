#!/usr/bin/expect

set timeout -1
set MNEMONIC [lindex $argv 0]

spawn tower backlog
expect {
    "Enter your 0L mnemonic:" { send "$MNEMONIC\r" }
}
expect eof