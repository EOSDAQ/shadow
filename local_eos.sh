if [ -z "${EOS_DIRECTORY}" ]; then
    echo "EOS_DIRECTORY is undefined"
    exit
fi

mkdir -p ./local_work
mkdir -p ./local_data

docker run --rm --name local_nodeos --network eos_net -d -p 18888:8888 -p 19876:9876 -v `pwd`/local_work:/work -v `pwd`/local_data:/mnt/dev/data -v `pwd`/local_config:/mnt/dev/config eosio/eos:latest  /bin/bash -c "nodeos -e -p eosio --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --config-dir /mnt/dev/config --http-server-address=0.0.0.0:8888 --http-validate-host=false --access-control-allow-origin=* --contracts-console"
docker run --rm --name local_keosd --network eos_net -d -p 18900:8900 -v `pwd`/local_work:/work -v `pwd`/local_data:/mnt/dev/data -v ${EOS_DIRECTORY}/build/contracts:/mnt/dev/contracts:rw eosio/eos:latest  /bin/bash -c "keosd --wallet-dir /mnt/dev/data --http-server-address=0.0.0.0:8900 --http-alias=localhost:8900 --http-alias=127.0.0.1:8900 --http-validate-host=false --access-control-allow-origin=*"
