# Shell script for tron full node (linux, ubuntu)

## Give permission to execute script
```
chmod +x [script_name].sh
```

## Run the script
```
./[script_name].sh
```

## Get the latest block number
```
curl -X POST 'http://localhost:8545/jsonrpc' --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' | jq -r '.result' | xargs printf "%d\n"
```
