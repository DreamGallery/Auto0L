#!/usr/bin/expect

set timeout -1
set MNEMONIC [lindex $argv 0]
set AUTHENETICATIONKEY [lindex $argv 1]

spawn txs create-account --authkey $AUTHENETICATIONKEY --coins 1
expect {
    "Enter your 0L mnemonic:" { send "$MNEMONIC\r" }
}
expect eof