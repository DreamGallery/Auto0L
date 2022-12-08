#!/bin/bash
trap "pkill -P $$" SIGINT

export PATH=$PATH:~/bin && echo export PATH=\$PATH:~/bin >> ~/.bashrc
curl -sL https://raw.githubusercontent.com/OLSF/libra/main/ol/util/install.sh | bash
wget https://github.com/DreamGallery/libra/releases/download/v5.2.0/tower -O ~/bin/tower && chmod +x ~/bin/tower

ONBOARDMNEMONIC="Input your 0L mnemonic here"
onboard keygen > keygen.log
Address=$(cat keygen.log | sed -n "3p")
AutheneticationKey=$(cat keygen.log | sed -n "7p")
echo "AutheneticationKey: ${AutheneticationKey}"
MNEMONIC=$(cat keygen.log | sed -n "11p")

./gettemplate.sh ${MNEMONIC}

sed -i 's/upstream_nodes = \[.*\]/upstream_nodes = \["http:\/\/52.15.236.78:8080", "http:\/\/73.181.115.53:8080", "http:\/\/fullnode.letsmove.fun"\]/g' ~/.0L/0L.toml
sed -i "$(($(cat ~/.0L/0L.toml | grep -n "tx_configs.miner_txs_cost" | awk -F ":" '{print $1}')+1))c max_gas_unit_for_tx = 20000" ~/.0L/0L.toml


while [[ $(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"get_account","params":["'$Address'"],"id":1}' http://0lexplorer.io/api/proxy/node | jq -r '.result') == "null" ]]
do
    ./onboard.sh ${ONBOARDMNEMONIC} ${AutheneticationKey}
done

while [[ $(curl -s https://0l.interblockcha.in:444/epochs/proofs/$Address) == \[\] ]]
do
    ./submitgenesis.sh ${MNEMONIC}
done

wget https://github.com/OLSF/libra/releases/download/v5.2.0/tower -O ~/bin/tower && chmod +x ~/bin/tower
./AutoLocalTower.sh
