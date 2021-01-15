#!/bin/bash

cd ~
echo "> Updating Ubuntu"
apt-get -y install software-properties-common python-software-properties htop
apt-get -y install git build-essential autoconf libboost-all-dev libssl-dev pkg-config
apt-get -y install libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libtool
apt-get -y install libcurl4-openssl-dev libdb5.3 libdb5.3-dev libdb5.3++-dev libevent-dev

echo "> Build groestlcoin from source"
mkdir -p ~/src && cd ~/src
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
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

echo "> Setup Groestlcoin node to start at server startup"
sed -i '2a\
sudo -u groestlcoin groestlcoind -datadir=/crypto/grs-data' /etc/rc.local

reboot
