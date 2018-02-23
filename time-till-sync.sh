#!/bin/bash
cnt=`bitcoin-cli getblockcount`
hash=`bitcoin-cli getblockhash ${cnt}`
timeline=`bitcoin-cli getblock $hash | grep '"time"'`
ltrimtime=${timeline#*time\" : }
newest=${ltrimtime%%,*}
# echo $((`date +%s`-$newest)) # in miliseconds
echo $(((`date +%s`-$newest)/3600)) # in hours
