#!/bin/bash
trap "pkill -P $$" SIGINT

export PATH=$PATH:~/bin && echo export PATH=\$PATH:~/bin >> ~/.bashrc
curl -sL https://raw.githubusercontent.com/OLSF/libra/main/ol/util/install.sh | bash
wget -q https://github.com/DreamGallery/libra/releases/download/v5.2.0/tower -O ~/bin/tower && chmod +x ~/bin/tower

ONBOARDMNEMONIC="Input your 0L mnemonic here"
onboard keygen > keygen.log
Address=$(cat keygen.log | sed -n "3p")
AutheneticationKey=$(cat keygen.log | sed -n "7p")
MNEMONIC=$(cat keygen.log | sed -n "11p" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
echo "Address: ${Address}"
echo "MNEMONIC: ${MNEMONIC}"
echo "AutheneticationKey: ${AutheneticationKey}"

./gettemplate.sh "${MNEMONIC}"
PID=$!; wait ${PID}


sed -i 's/upstream_nodes = \[.*\]/upstream_nodes = \["http:\/\/63.229.234.77:8080", "http:\/\/63.229.234.76:8080", "http:\/\/73.181.115.53:8080", "http:\/\/135.181.118.28:8080", "http:\/\/65.108.14.25:8080"\]/g' ~/.0L/0L.toml
sed -i "$(($(cat ~/.0L/0L.toml | grep -n "tx_configs.miner_txs_cost" | awk -F ":" '{print $1}')+1))c max_gas_unit_for_tx = 20000" ~/.0L/0L.toml


while [[ $(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"get_account","params":["'${Address}'"],"id":1}' http://65.108.14.25:8080 | jq -r '.result') == "null" ]]
do
    ./onboard.sh "${ONBOARDMNEMONIC}" "${AutheneticationKey}"
    PID=$!; wait ${PID}
    sleep 10
done

while [[ $(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"get_tower_state_view","params":["'${Address}'"],"id":1}' http://65.108.14.25:8080 | jq -r '.result') == "null" ]]
do
    ./submitgenesis.sh "${MNEMONIC}"
    PID=$!; wait ${PID}
    sleep 10
done

wget -q https://github.com/OLSF/libra/releases/download/v5.2.0/tower -O ~/bin/tower && chmod +x ~/bin/tower

echo "-----------------------------------------------------------------------------------"
echo "New account initialization completed, please write down the mnemonic in keygen.log"
echo "You can add the mnemonic to AutoLocalTower.sh and start mining you first proof."
echo "-----------------------------------------------------------------------------------"
