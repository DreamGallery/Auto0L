#!/usr/bin/expect

set timeout -1
set MNEMONIC [lindex $argv 0]
set TEMPLATEURL "http://73.181.115.53"
set STATEMENT "hello 0L"

spawn onboard val -u $TEMPLATEURL
expect {
    "Enter your 0L mnemonic:" { send "$MNEMONIC\r" }
}
expect {
    "Enter a (fun) statement to go into your first transaction. This also creates entropy for your first proof:" { send "$STATEMENT\r" }
}
expect {
    "\[y/n\]" { send "n\r";}
}
expect {
    "Enter the IP address of the node:" { send "0.0.0.0\r";}
}
expect {
    "\[y/n\]" { send "n\r";}
}
expect {
    "\[y/n\]" { send "y\r";}
}
expect eof