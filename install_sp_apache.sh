#!/bin/bash

set -e

# Prerequisites
apt-get update -y
apt-get install -y build-essential checkinstall make gcc
# libcurl3 libssl-dev libcrypto

SRC=/home/vagrant/src
mkdir -p $SRC
sudo chown $USER $SRC
sudo chmod u+rwx $SRC
#apt-get install -y wget apache2

cd $SRC
wget http://shibboleth.net/downloads/log4shib/latest/log4shib-1.0.9.tar.gz
wget http://www.mirrorservice.org/sites/ftp.apache.org//xerces/c/3/sources/xerces-c-3.1.3.tar.gz
wget http://apache.mirror.anlx.net/santuario/c-library/xml-security-c-1.7.3.tar.gz
wget http://shibboleth.net/downloads/c++-opensaml/latest/xmltooling-1.5.6.tar.gz
wget http://shibboleth.net/downloads/c++-opensaml/latest/opensaml-2.5.5.tar.gz
wget http://shibboleth.net/downloads/service-provider/latest/shibboleth-sp-2.5.6.tar.gz

tar xvfz log4shib-1.0.9.tar.gz
tar xvfz xerces-c-3.1.3.tar.gz
tar xvfz xml-security-c-1.7.3.tar.gz
tar xvfz xmltooling-1.5.6.tar.gz
tar xvfz opensaml-2.5.5.tar.gz
tar xvfz shibboleth-sp-2.5.6.tar.gz

# install and configure apache2
apt-get install -y apache2
#apt-get install -y apache2-doc apache2-suexec-pristine apache2-suexec-custom apache2-utils openssl-blacklist
#apt-get install -y libmcrypt-dev mcrypt
#apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php-pear
#apt-get install -y php5-common php5-cli php5-curl php5-gmp php5-ldap
#apt-get install -y libapache2-mod-gnutls
#a2enmod gnutls

# set upbasic ssl web site
make-ssl-cert generate-default-snakeoil --force-overwrite
a2enmod ssl
a2ensite default-ssl
service apache2 restart

echo "Begin Build" > build.log

# install log4shib
cd ${SRC}/log4shib-1.0.9
./configure --disable-static --disable-doxygen --prefix=/opt/shibboleth-sp && make && make install && echo "Completed log4shib" >> ${SRC}/build.log                                                                         && \
cd -

# install xerces
cd ${SRC}/xerces-c-3.1.3
./configure --prefix=/opt/shibboleth-sp --disable-netaccessor-libcurl && make && make install && echo "Completed xerces" >> ${SRC}/build.log
cd -

# install xml-security
apt-get install -y libssl-dev libcurl4-openssl-dev autoconf autoconf automake libtool
cd ${SRC}/xml-security-c-1.7.3
./configure --disable-static --without-xalan --with-xerces=/opt/shibboleth-sp && make && make install && echo "Completed xml-security" >> ${SRC}/build.log
cd -

apt-get build-dep -y gearman-job-server
cd ${SRC}/xmltooling-1.5.6
./configure --with-log4shib=/opt/shibboleth-sp --prefix=/opt/shibboleth-sp -C && make && make install && echo "Completed xmltooling" >> ${SRC}/build.log
cd -

# install opensaml
cd ${SRC}/opensaml-2.5.5
apt-get install --yes wget gcc g++ make libssl-dev libcurl4-openssl-dev apache2-threaded-dev
./configure --with-log4shib=/opt/shibboleth-sp --prefix=/opt/shibboleth-sp -C && make && make install && echo "Completed opensaml" >> ${SRC}/build.log
cd -

# install Shibboloth
cd ${SRC}/shibboleth-sp-2.5.6
./configure --with-log4shib=/opt/shibboleth-sp --enable-apache-13  --with-apxs=/usr/bin/apxs --enable-apache-20 --with-apxs2=/usr/bin/apxs --prefix=/opt/shibboleth-sp >> ${SRC}/build.log
#  make && make install

#  ./configure --with-saml=/opt/shibboleth-sp --enable-apache-22 --with-log4shib=/opt/shibboleth-sp --with-xmltooling=/opt/shibboleth-sp --prefix=/opt/shibboleth-sp -C

cd -

#if [ ! -d '${SRC}/nginx-http-shibboleth' ]; then
#  git clone https://github.com/nginx-shib/nginx-http-shibboleth.git ${SRC}/nginx-http-shibboleth
#else
#  echo "Already have shibboleth"
#fi
