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
mkdir -p ~/src && cd ~/src
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
./autogen.sh
./configure --without-gui --without-upnp --disable-tests
make
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
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

echo "> Setup Bitcoin node to start at server startup"
sed -i '2a\
sudo -u bitcoin bitcoind -datadir=/crypto/btc-data' /etc/rc.local

echo "> Add an 'btc' alias ('btc getbalance')"
echo "alias btc=\"sudo -u bitcoin bitcoin-cli -datadir=/crypto/btc-data\"" >> ~/.bashrc

reboot
