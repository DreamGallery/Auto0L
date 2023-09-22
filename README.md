# Auto0L
Auto install 0L and set 0L.toml to run Tower(only).

## Requirement
```
sudo apt-get install jq tcl expect moreutils screen -y
```
Give users sudo permission under multi-user
```
sudo usermod -a -G sudo username
```
Give these scripts run permission and move to user root dir.
```
chmod +x Auto0L/* && mv Auto0L/* ~ && rm -rf Auto0L/ README.md
```
If show "libssl.so.1.1: cannot open shared object file: No such file or directory"
```
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.23_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb
```

## Auto0L.sh
```
ONBOARDMNEMONIC="Input your 0L mnemonic here"
```
this is used to onboard your new accounts, add your mnemonic of the address which have gas cions.

the new account info will be saved in `keygen.log` in the same directory.

I recommended you write the mnemonic down and delete the file once everything is done.

## gettemplate.sh
this will use `onboard val -u http://${fullnodeip}` to create. 
```
0L.toml 
keystore.json
proof_0.json
```
you can also edit the .toml file as you like.

## onboard.sh
this is the script to onboard your new account with the mnemonic you add on Auto0L.sh

the onboard command.
```
txs create-account --authkey ${your authkey here} --coins 1
```

## submitgenesis.sh
used to submit genesis proof(proof_0.json).

The official tower tool doesn't seem to be able to upload it, so a Modify version is provided here.

and will replace it to official version after submitting genesis proof successfully.

## AutoLocalTower.sh
used to run tower with local mode and auto restart tower when it get stucked for some reasons.

you need to add your mnemonic of new account to it after account initialization completed.

## 0Lsubmit.sh
used to submit backlog proofs.

you need to input your mnemonic in it.
