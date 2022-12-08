#!/bin/bash

trap "pkill -P $$" SIGINT

[ -f tower.log ] && rm tower.log
DIR=~/.0L/vdf_proofs/
MNEMONIC="put your 0L menmonic here"

{
    while true
    do
        {
            /usr/bin/expect <<-EOF 2>&1 | ts "%Y-%m-%d %H:%M:%S" >> tower.log
            set timeout -1
            spawn tower start -l
            expect {
                "Enter your 0L mnemonic:" { send "${MNEMONIC}\n" }
            }
            expect eof
EOF
        }&
        while true
        do
            while true
            do
                LOGLTIME=$(cat tower.log | tail -n 1 | awk -F' ' '{print $1,$2}')
                if [[ -n ${LOGLTIME} ]]; then
                    break
                fi
            done
            TIMEDIFF=$(expr $(date +%s) - $(date -d "$LOGLTIME" +%s))
            PID=$(ps ux | grep -v grep | grep "tower start" | awk '{print $2}')
            if [[ ${TIMEDIFF} -gt 1800 ]]; then
                if [[ -n ${PID} ]]; then
                    echo "tower stopped for some reason, restarting" | ts "%Y-%m-%d %H:%M:%S" | tee -a tower.log
                    kill ${PID} && break
                else
                    sleep 10
                    PID=$(ps ux | grep -v grep | grep "tower start" | awk '{print $2}')
                    if [[ ! -n ${PID} ]]; then
                        break
                    fi
                fi
            fi
            sleep 3   
        done
    done
} &

sleep 1 && tail -f tower.log 2> /dev/null | grep -E 'Mining VDF Proof | difficulty: | Delay: | Proof mined: | Submitted from account: | Success: Proof committed to chain'
