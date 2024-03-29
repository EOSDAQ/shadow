#!/bin/zsh

# Local eos
alias cleos='sudo docker exec local_keosd cleos -u http://local_nodeos:8888 --wallet-url http://localhost:8900'
export EOSIOKEY=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
export LOCAL_EOS=`cat ~/.local_eos`

openwallet () { 
    grep PW5 ${LOCAL_EOS}/.$1 | sed 's/"//g' 
}
pubkey () { 
    grep Public ${LOCAL_EOS}/.$1 | sed 's/Public key: //g' 
}
prikey() { 
    grep Private ${LOCAL_EOS}/.$1 | sed 's/Private key: //g' 
}

if [[ "$@" == "new" ]]; then
    echo "generation new wallet&key"

    rm -f ./local_data/*.wallet
    echo `pwd` > ~/.local_eos

    # master
    cleos wallet create --to-console 2>&1 > ${LOCAL_EOS}/.master
    cleos wallet import --private-key ${EOSIOKEY}

    for N in {1..40}
    do
        # wallet gen
        cleos wallet create --to-console -n wall${N} 2>&1 > ${LOCAL_EOS}/.wall$N
        # key gen
        cleos create key --to-console 2>&1 > ${LOCAL_EOS}/.key$N
        # import
        cleos wallet import -n wall$N --private-key `prikey key${N}`
    done
else
    cleos wallet unlock --password `openwallet master`
    for N in {1..40}
    do
        cleos wallet unlock --password `openwallet wall${N}` -n wall$N
    done
fi
