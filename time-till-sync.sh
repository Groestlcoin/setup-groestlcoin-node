#!/bin/bash
cnt=`bitcoin-cli getblockcount`
hash=`bitcoin-cli getblockhash ${cnt}`
timeline=`bitcoin-cli getblock $hash | grep '"time"'`
ltrimtime=${timeline#*time\" : }
newest=${ltrimtime%%,*}
echo $((`date +%s`-$newest))
