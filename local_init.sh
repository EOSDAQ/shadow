. ./local_keys.sh $1

# key gen
export KEY1_PUB=`pubkey key1`
export KEY1_PRI=`prikey key1`
export KEY2_PUB=`pubkey key2`
export KEY2_PRI=`prikey key2`
export KEY3_PUB=`pubkey key3`
export KEY3_PRI=`prikey key3`
export KEY4_PUB=`pubkey key4`
export KEY4_PRI=`prikey key4`

# sys account gen
cleos create account eosio eosio.token ${KEY1_PUB} ${KEY1_PUB}
cleos create account eosio eosio.msig ${KEY1_PUB} ${KEY1_PUB}
cleos create account eosio exchange ${KEY1_PUB} ${KEY1_PUB}

# app account gen
cleos create account eosio eosdaq ${KEY2_PUB} ${KEY2_PUB}
cleos create account eosio eosdaqacnt ${KEY2_PUB} ${KEY2_PUB}
cleos set account permission eosdaq active  '{"threshold": 1,"keys": [{"key": "'${KEY2_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"eosdaq","permission":"eosio.code"},"weight":1}]}' owner -p eosdaq
cleos set account permission eosdaqacnt active  '{"threshold": 1,"keys": [{"key": "'${KEY2_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"eosdaqacnt","permission":"eosio.code"},"weight":1}]}' owner -p eosdaqacnt
cleos create account eosio newrovp ${KEY3_PUB} ${KEY3_PUB}
cleos set account permission newrovp active  '{"threshold": 1,"keys": [{"key": "'${KEY3_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"eosdaq","permission":"eosio.code"},"weight":1}]}' owner -p newrovp
cleos create account eosio newrotaker ${KEY4_PUB} ${KEY4_PUB}
cleos set account permission newrotaker active  '{"threshold": 1,"keys": [{"key": "'${KEY4_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"eosdaq","permission":"eosio.code"},"weight":1}]}' owner -p newrotaker
cleos get accounts ${KEY1_PUB}

# contract upload
cleos set contract eosio /mnt/dev/contracts/eosio.bios -p eosio@active
cleos set contract eosio.token /mnt/dev/contracts/eosio.token -p eosio.token@active
cleos set contract eosio.msig /mnt/dev/contracts/eosio.msig -p eosio.msig@active
cleos set contract exchange /mnt/dev/contracts/exchange -p exchange@active
cleos set contract eosdaq /mnt/dev/contracts/eosdaq -p eosdaq@active
cleos set contract eosdaqacnt /mnt/dev/contracts/eosdaq_acnt -p eosdaqacnt@active

# Token gen
cleos push action eosio.token create '{ "issuer":"eosio", "maximum_supply":"1000000000.0000 SYS"}' -p eosio.token@active
cleos push action eosio.token create '{ "issuer":"eosio", "maximum_supply":"1000000000.0000 ABC"}' -p eosio.token@active
cleos push action eosio.token issue '[ "newrovp", "1000000.0000 ABC", "memo" ]' -p eosio@active
cleos push action eosio.token issue '[ "newrovp", "1000000.0000 SYS", "memo" ]' -p eosio@active
cleos push action eosio.token issue '[ "newrotaker", "1000000.0000 SYS", "memo" ]' -p eosio@active
cleos push action eosio.token issue '[ "newrotaker", "1000000.0000 ABC", "memo" ]' -p eosio@active

# Ask gen : price = SYS 개수 / TOKEN 개수
#cleos push action eosdaq askorder '[ "newrovp", 30, "30.0000 ABC", "0.0000 SYS", "0.0000 ABC" ]' -p newrovp@active
#cleos push action eosdaq bidorder '[ "newrotaker", 30, "1.0000 SYS", "0.0000 SYS", "0.0000 ABC" ]' -p newrotaker@active
cleos push action eosdaqacnt enroll '[ "eosdaqacnt", "newrovp" ]' -p eosdaqacnt
cleos push action eosdaqacnt enroll '[ "eosdaqacnt", "newrotaker" ]' -p eosdaqacnt
cleos transfer newrotaker eosdaq "10.0000 ABC" "30" -p newrotaker
cleos transfer newrovp eosdaq "10.0000 SYS" "30" -p newrovp
#cleos push action eosdaq verify '[ "eosdaq" ]' -p eosdaq@active
#cleos -v --print-request push action eosdaq deletetransx '[ "eosdaq", 0, 0 ]' -p eosdaq@active

if [ -f local_init_extra.sh ]; then
    local_init_extra.sh
fi

