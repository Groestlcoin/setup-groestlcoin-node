#!/bin/bash
cnt=`groestlcoin-cli getblockcount`
hash=`groestlcoin-cli getblockhash ${cnt}`
timeline=`groestlcoin-cli getblock $hash | grep '"time"'`
ltrimtime=${timeline#*time\" : }
newest=${ltrimtime%%,*}
# echo $((`date +%s`-$newest)) # in miliseconds
echo $(((`date +%s`-$newest)/3600)) # in hours
