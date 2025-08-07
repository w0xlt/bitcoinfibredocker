# bitcoinfibredocker


```bash
$ git clone git@github.com:w0xlt/bitcoinfibredocker.git

$ cd bitcoinfibredocker

$ mkdir ./bitcoin-data

$ cat > ./bitcoin-data/bitcoin.conf << EOF
listen=1
bind=0.0.0.0
udpport=8339,0
debug=fec
debug=udpnet
logtimemicros=1
debug=bench
prune=550
upnp=1
externalip=<extarnal_ip>
assumevalid=000000000000000000014348a2a22e1000287a88e47803cf24623c118afbda14
dbcache=10240
EOF

$ docker run -d \
    -v $(pwd)/bitcoin-data:/root/.bitcoin \
    -p 8333:8333 \
    -p 8332:8332 \
    -p 8339:8339/udp \
    --name mybitcoinfibre \
    bitcoinfibre /bitcoinfibre/src/bitcoind

$ docker exec -it mybitcoinfibre /bitcoinfibre/src/bitcoin-cli getblockcount
```

