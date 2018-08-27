#!/bin/zsh

. ./local_keys.sh $1

# key gen
for N in {1..40}
do
export KEY${N}_PUB=`pubkey key${N}`
export KEY${N}_PRI=`prikey key${N}`
done

export ACCOUNT=eosdaq555555
export CONTRACT=eosdaqoooo2o
export TOKEN1=oo1122334455
export MANAGE=eosdaqmanage

# sys account gen
cleos create account eosio eosio.token ${KEY1_PUB} ${KEY1_PUB}
cleos create account eosio eosio.msig ${KEY1_PUB} ${KEY1_PUB}
cleos create account eosio exchange ${KEY1_PUB} ${KEY1_PUB}
cleos create account eosio ${TOKEN1} ${KEY2_PUB} ${KEY2_PUB}

# app account gen
cleos create account eosio ${CONTRACT} ${KEY3_PUB} ${KEY3_PUB}
cleos create account eosio ${ACCOUNT} ${KEY4_PUB} ${KEY4_PUB}
cleos create account eosio ${MANAGE} ${KEY4_PUB} ${KEY4_PUB}
cleos set account permission ${CONTRACT} active  '{"threshold": 1,"keys": [{"key": "'${KEY3_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"'${CONTRACT}'","permission":"eosio.code"},"weight":1}]}' owner -p ${CONTRACT}
cleos set account permission ${ACCOUNT} active  '{"threshold": 1,"keys": [{"key": "'${KEY4_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"'${ACCOUNT}'","permission":"eosio.code"},"weight":1}]}' owner -p ${ACCOUNT}
cleos create account eosio newrovp ${KEY5_PUB} ${KEY5_PUB}
cleos set account permission newrovp active  '{"threshold": 1,"keys": [{"key": "'${KEY5_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"'${CONTRACT}'","permission":"eosio.code"},"weight":1}]}' owner -p newrovp
cleos create account eosio newrotaker ${KEY6_PUB} ${KEY6_PUB}
cleos set account permission newrotaker active  '{"threshold": 1,"keys": [{"key": "'${KEY6_PUB}'","weight":1}],"accounts":[{"permission":{"actor":"'${CONTRACT}'","permission":"eosio.code"},"weight":1}]}' owner -p newrotaker
cleos get accounts ${KEY1_PUB}

# contract upload
cleos set contract eosio /mnt/dev/contracts/eosio.bios -p eosio@active
cleos set contract eosio.token /mnt/dev/contracts/eosio.token -p eosio.token@active
cleos set contract ${TOKEN1} /mnt/dev/contracts/eosio.token -p ${TOKEN1}@active
cleos set contract eosio.msig /mnt/dev/contracts/eosio.msig -p eosio.msig@active
cleos set contract exchange /mnt/dev/contracts/exchange -p exchange@active
cleos set contract ${CONTRACT} /mnt/dev/contracts/eosdaq -p ${CONTRACT}@active
cleos set contract ${ACCOUNT} /mnt/dev/contracts/eosdaq_acnt -p ${ACCOUNT}@active

# Token gen
cleos push action eosio.token create '{ "issuer":"eosio", "maximum_supply":"1000000000.0000 SYS"}' -p eosio.token@active
cleos push action ${TOKEN1} create '{ "issuer":"'${TOKEN1}'", "maximum_supply":"1000000000.0000 IPOS"}' -p ${TOKEN1}@active
cleos push action eosio.token issue '[ "newrovp", "1000000.0000 SYS", "memo" ]' -p eosio@active
cleos push action ${TOKEN1} issue '[ "newrovp", "1000000.0000 IPOS", "memo" ]' -p ${TOKEN1}@active
cleos push action eosio.token issue '[ "newrotaker", "1000000.0000 SYS", "memo" ]' -p eosio@active
cleos push action ${TOKEN1} issue '[ "newrotaker", "1000000.0000 IPOS", "memo" ]' -p ${TOKEN1}@active

# Ask gen : price = SYS 개수 / TOKEN 개수
#cleos push action eosdaq askorder '[ "newrovp", 30, "30.0000 ABC", "0.0000 SYS", "0.0000 ABC" ]' -p newrovp@active
#cleos push action eosdaq bidorder '[ "newrotaker", 30, "1.0000 SYS", "0.0000 SYS", "0.0000 ABC" ]' -p newrotaker@active
#cleos push action ${ACCOUNT} enroll '[ "'${MANAGE}'", "newrovp" ]' -p ${MANAGE}
#cleos push action ${ACCOUNT} enroll '[ "'${MANAGE}'", "newrotaker" ]' -p ${MANAGE}
./new_user.sh newrovp
./new_user.sh newrotaker
#cleos transfer newrotaker eosdaq "10.0000 ABC" "30" -p newrotaker
#cleos transfer newrovp eosdaq "10.0000 SYS" "30" -p newrovp
cleos transfer newrovp ${CONTRACT} "10.0000 SYS" "0.0030" -p newrovp
cleos transfer newrovp ${CONTRACT} "10.0000 SYS" "0.0040" -p newrovp
cleos transfer newrovp ${CONTRACT} "10.0000 SYS" "0.0050" -p newrovp
cleos push action ${TOKEN1} transfer '["newrotaker", "'${CONTRACT}'", "6000.0000 IPOS", "0.0030"]' -p newrotaker
#cleos push action eosdaq verify '[ "eosdaq" ]' -p eosdaq@active
#cleos -v --print-request push action eosdaq deletetransx '[ "eosdaq", 0, 0 ]' -p eosdaq@active

if [ -f local_init_extra.sh ]; then
    local_init_extra.sh
fi

