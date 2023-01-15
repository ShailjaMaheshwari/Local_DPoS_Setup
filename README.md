#### XinFin DPoS

### Steps to build local DPoS to run a private xdc network.
To run a private network you can generate a genesis file using the link : https://medium.com/xinfin/how-to-set-up-a-private-blockchain-network-with-xdc-network-codebase-b2ee82368e83
Note: To provide the addresses in above link you can generate few address-private key pairs using xinfin web wallet. Use keystore file and remember the password of the wallet for each address that you use.

Once the genesis file is generated, as mentioned in above link follow steps 5 and 6. To clearly mention what step 6 asks to do is :
i) Take the genesis file generated in XDPoSChain using puppeth and use it to replace the genesis file mentioned in LocalDpos repository's devenet or testnet whatever section you are moving ahead with.
ii) Take the bootnode key and enode generated in step 5 of the link and place them in devnet/testnet's bootnode key and enodes_list.txt though you can use it directly while starting nodes but it will be safe option to save it.
iii) Enter the private key of 3 nodes, masternode and 2 signers respectively in .env file.
iv) In run.sh replace network id and wherever enode is used for starting all nodes, in command it will be like --bootnode <enode string> so repalce the enode with the one we have saved in enodes_list.txt. The enodes generated in system with default ip like [::] so while mentioning enode you can add default ip 127.0.0.1.

##Few more changes to be taken care of:
i) In run.sh change the relative or absolute path of XDPoSChain repository so that it can fetch the build/bin/XDC from the repo. 
ii) Also make sure that the port number of all nodes are different.
iii) Before running the run script, mention the password of all the nodes whose private key is mentioned in .env in the file .pwd
iv)sudo bash run.sh or ./run.sh
v) Once the network is up each nodes folder containing keystore, XDC.ipc files will be created, you can run the each node's console using xdc-attach scripts or command: sudo <path to XDPoSChain repo>/build/bin/XDC attach nodes/<node>/XDC.ipc.
Once the console open you can chekc eth.blocknumber, admin.nodeinfo, admin.peers, admin.addpeer() command sto check the network status. You can also check the ethstat flag in run.sh which holds YourNodeName:XinFinwebsite which shows node status and you can find your nodes once they are up.


## Network Ports

Following network ports need to be open for the nodes to communicate

| Port | Type | Definition |
|:------:|:-----:|:---------- |
|30301-3030*| TCP/UDP | XDC Enode |
|8545-854*| TCP | RPC |
|9545-954*| TCP | WebSocket |



