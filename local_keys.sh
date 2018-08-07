#!/bin/zsh

# Local eos
alias cleos='docker exec local_eosio /opt/eosio/bin/cleos --wallet-url http://localhost:8888'
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

    # wallet gen
    cleos wallet create 2>&1 > ${LOCAL_EOS}/.master
    cleos wallet create -n wall1 2>&1 > ${LOCAL_EOS}/.wall1
    cleos wallet create -n wall2 2>&1 > ${LOCAL_EOS}/.wall2
    cleos wallet create -n wall3 2>&1 > ${LOCAL_EOS}/.wall3
    cleos wallet create -n wall4 2>&1 > ${LOCAL_EOS}/.wall4

    # key gen
    cleos create key 2>&1 > ${LOCAL_EOS}/.key1
    cleos create key 2>&1 > ${LOCAL_EOS}/.key2
    cleos create key 2>&1 > ${LOCAL_EOS}/.key3
    cleos create key 2>&1 > ${LOCAL_EOS}/.key4

    cleos wallet import --private-key ${EOSIOKEY}
    cleos wallet import -n wall1 --private-key `prikey key1`
    cleos wallet import -n wall2 --private-key `prikey key2`
    cleos wallet import -n wall3 --private-key `prikey key3`
    cleos wallet import -n wall4 --private-key `prikey key4`
else
    cleos wallet unlock --password `openwallet master`
    cleos wallet unlock --password `openwallet wall1` -n wall1
    cleos wallet unlock --password `openwallet wall2` -n wall2
    cleos wallet unlock --password `openwallet wall3` -n wall3
    cleos wallet unlock --password `openwallet wall4` -n wall4
fi
