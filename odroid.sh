#!/bin/bash

cd ~
echo "> Updating Ubuntu"
add-apt-repository -y ppa:bitcoin/bitcoin
apt-get -y update
apt-get -y install software-properties-common python-software-properties htop
apt-get -y install git build-essential autoconf libboost-all-dev libssl-dev pkg-config
apt-get -y install libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libtool
apt-get -y install libcurl4-openssl-dev db4.8 libevent-dev

echo "> Build bitcoin from source"
mkdir -p /mnt/hdd/bitcoin-src && cd /mnt/hdd/bitcoin-src
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
./autogen.sh
./configure --without-gui --without-upnp
make
make check
make install

echo "> Create Bitcoin User"
useradd -m bitcoin

echo "> Bitcoin config"
cd ~bitcoin
sudo -u bitcoin mkdir .bitcoin
config=".bitcoin/bitcoin.conf"
sudo -u bitcoin touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "connections=40" >> $config
echo "proxy=127.0.0.1:9050" >> $config
echo "txindex=1" >> $config
echo "externalip=87.197.157.72" >> $config
echo "zmqpubrawblock=tcp://127.0.0.1:28332" >> $config
echo "zmqpubrawtx=tcp://127.0.0.1:28333" >> $config
echo "datadir=/mnt/hdd/btc-data" >> $config
echo "port=8301" >> $config
echo "prune=1" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

echo "> Setup Bitcoin node to start at server startup"
sudo -u bitcoin mkdir /mnt/hdd/btc-data
sed -i '2a\
sudo -u bitcoin bitcoind -datadir=/mnt/hdd/btc-data' /etc/rc.local

echo "> Add an 'btc' alias ('btc getbalance')"
echo "alias btc=\"sudo -u bitcoin bitcoin-cli -datadir=/mnt/hdd/btc-data\"" >> ~/.bashrc

reboot
