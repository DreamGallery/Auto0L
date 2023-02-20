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
        "WARN: Unable to submit backlog:" { continue; }
        "Backlog: Maximum number of proofs sent this epoch" { break; }
    }
    expect eof
}
