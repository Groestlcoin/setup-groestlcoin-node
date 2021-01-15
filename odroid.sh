#!/bin/bash

cd ~
echo "> Updating Ubuntu"
apt-get -y install software-properties-common python-software-properties htop
apt-get -y install git build-essential autoconf libboost-all-dev libssl-dev pkg-config
apt-get -y install libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libtool
apt-get -y install libcurl4-openssl-dev libdb5.3 libdb5.3-dev libdb5.3++-dev libevent-dev

echo "> Build groestlcoin from source"
mkdir -p /mnt/hdd/groestlcoin-src && cd /mnt/hdd/groestlcoin-src
git clone https://github.com/groestlcoin/groestlcoin.git
cd groestlcoin
./autogen.sh
./configure --without-gui --without-upnp
make
make check
make install

echo "> Create Groestlcoin User"
useradd -m groestlcoin

echo "> Groestlcoin config"
cd ~groestlcoin
sudo -u groestlcoin mkdir .groestlcoin
config=".groestlcoin/groestlcoin.conf"
sudo -u groestlcoin touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "connections=40" >> $config
echo "proxy=127.0.0.1:9050" >> $config
echo "txindex=1" >> $config
echo "externalip=87.197.157.72" >> $config
echo "zmqpubrawblock=tcp://127.0.0.1:28332" >> $config
echo "zmqpubrawtx=tcp://127.0.0.1:28333" >> $config
echo "datadir=/mnt/hdd/grs-data" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

echo "> Setup Groestlcoin node to start at server startup"
sudo -u groestlcoin mkdir /mnt/hdd/grs-data
sed -i '2a\
sudo -u groestlcoin groestlcoind -datadir=/mnt/hdd/grs-data' /etc/rc.local

reboot
