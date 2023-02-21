#!/usr/bin/expect

set MNEMONIC "Input your 0L mnemonic here"
set timeout -1

while { true } {
    spawn tower backlog -s
    expect {
        "can make client but could not get metadata Error" { continue; }
        "Enter your 0L mnemonic:" { send "${MNEMONIC}\n" }
    }
    expect {
        "*Server error: Mempool submission error" { continue; }
        "*cannot submit more proofs than allowed in epoch, aborting backlog" { break; }
    }
    expect eof
    wait
    sleep 1
}
