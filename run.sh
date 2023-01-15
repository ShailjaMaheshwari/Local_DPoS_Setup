#!/bin/bash
_interupt() { 
    echo "Shutdown $child_proc"
    kill -TERM $child_proc
    exit
}

trap _interupt INT TERM

touch .pwd
export $(cat .env | xargs)
Bin_NAME=XDC

WORK_DIR=$PWD
PROJECT_DIR="../origXdpos"
cd $PROJECT_DIR && make XDC
cd $WORK_DIR
echo "before if"
ls ./nodes/1/$Bin_NAME/
if [ ! -d ./nodes/1/$Bin_NAME/chaindata ]
then
  echo " in then"
  wallet1=$(${PROJECT_DIR}/build/bin/$Bin_NAME account import --password .pwd --datadir ./nodes/1 <(echo ${PRIVATE_KEY_1}) | awk -v FS="({|})" '{print $2}')
  wallet2=$(${PROJECT_DIR}/build/bin/$Bin_NAME account import --password .pwd --datadir ./nodes/2 <(echo ${PRIVATE_KEY_2}) | awk -v FS="({|})" '{print $2}')
  wallet3=$(${PROJECT_DIR}/build/bin/$Bin_NAME account import --password .pwd --datadir ./nodes/3 <(echo ${PRIVATE_KEY_3}) | awk -v FS="({|})" '{print $2}')
  ${PROJECT_DIR}/build/bin/$Bin_NAME --datadir ./nodes/1 init ./genesis/genesis.json
  ${PROJECT_DIR}/build/bin/$Bin_NAME --datadir ./nodes/2 init ./genesis/genesis.json
  ${PROJECT_DIR}/build/bin/$Bin_NAME --datadir ./nodes/3 init ./genesis/genesis.json
else
  echo "in else -----"
  wallet1=$(${PROJECT_DIR}/build/bin/$Bin_NAME account list --datadir ./nodes/1 | head -n 1 | awk -v FS="({|})" '{print $2}')
  wallet2=$(${PROJECT_DIR}/build/bin/$Bin_NAME account list --datadir ./nodes/2 | head -n 1 | awk -v FS="({|})" '{print $2}')
  wallet3=$(${PROJECT_DIR}/build/bin/$Bin_NAME account list --datadir ./nodes/3 | head -n 1 | awk -v FS="({|})" '{print $2}')
fi

echo "wallets:1"
echo $wallet1
echo "wallets :2"
echo $wallet2
echo "wallet 3:"
echo $wallet3
VERBOSITY=3
GASPRICE="1"
networkid=13123


echo Starting the bootnode ...
${PROJECT_DIR}/build/bin/bootnode -nodekey ./bootnode.key --addr 0.0.0.0:30301 &
child_proc=$! 

echo Starting the nodes ...

${PROJECT_DIR}/build/bin/$Bin_NAME --bootnodes "enode://cbac8dee6adc4dc6b68bbb5c84e4810a4ca1f517622306d21decf72c0c4de6b0b7f07ba4ab333a75f34b0f0b9b852c8b7f5f56bd6aa06a3170a096a48958d2ed@127.0.0.1:30301" --syncmode "full" --datadir ./nodes/1 --networkid "${networkid}" --port 30311 --rpc --rpccorsdomain "*" --ws --wsaddr="0.0.0.0" --wsorigins "*" --wsport 9551 --rpcaddr 0.0.0.0 --rpcport 8551 --rpcvhosts "*" --unlock "${wallet1}" --password ./.pwd --mine --gasprice "${GASPRICE}" --targetgaslimit "420000000" --verbosity ${VERBOSITY} --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,XDPoS --ethstats "KMSXinFin-MasterNode-01:xinfin_xdpos_hybrid_network_stats@stats.xinfin.network:3000" &
child_proc="$child_proc $!"
${PROJECT_DIR}/build/bin/$Bin_NAME --bootnodes "enode://cbac8dee6adc4dc6b68bbb5c84e4810a4ca1f517622306d21dec72c0c4de6b0b7f07ba4ab333a75f34b0f0b9b852c8b7f5f56bd6aa06a3170a096a48958d2ed@127.0.0.1:30301" --syncmode "full" --datadir ./nodes/2 --networkid "${networkid}" --port 30312 --rpc --rpccorsdomain "*" --ws --wsaddr="0.0.0.0" --wsorigins "*" --wsport 9552 --rpcaddr 0.0.0.0 --rpcport 8552 --rpcvhosts "*" --unlock "${wallet2}" --password ./.pwd --mine --gasprice "${GASPRICE}" --targetgaslimit "420000000" --verbosity ${VERBOSITY} --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,XDPoS --ethstats "KMSXinFin-MasterNode-02:xinfin_xdpos_hybrid_network_stats@stats.xinfin.network:3000" &
child_proc="$child_proc $!"
${PROJECT_DIR}/build/bin/$Bin_NAME --bootnodes "enode://cbac8dee6adc4dc6b68bbb5c84e4810a4ca1f517622306d21decf72c0c4de6b0b7f07ba4ab333a75f34b0f0b9b852c8b7f5f56bd6aa06a3170a096a48958d2ed@127.0.0.1:30301" --syncmode "full" --datadir ./nodes/3 --networkid "${networkid}" --port 30313 --rpc --rpccorsdomain "*" --ws --wsaddr="0.0.0.0" --wsorigins "*" --wsport 9553 --rpcaddr 0.0.0.0 --rpcport 8553 --rpcvhosts "*" --unlock "${wallet3}" --password ./.pwd --mine --gasprice "${GASPRICE}" --targetgaslimit "420000000" --verbosity ${VERBOSITY} --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,XDPoS --ethstats "KMSXinFin-MasterNode-03:xinfin_xdpos_hybrid_network_stats@stats.xinfin.network:3000" 
