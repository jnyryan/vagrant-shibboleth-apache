#!/bin/bash

set -e

# Prerequisites
apt-get update -y
apt-get install -y build-essential checkinstall make gcc silversearcher-ag apache2

SRC=/home/vagrant/src
mkdir -p $SRC
sudo chown $USER $SRC
sudo chmod u+rwx $SRC

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

# install xmltooling with BOOST headers
apt-get build-dep -y gearman-job-server
apt-get install -y wget gcc g++ make libssl-dev libcurl4-openssl-dev apache2-threaded-dev

cd ${SRC}/xmltooling-1.5.6
./configure --with-log4shib=/opt/shibboleth-sp --prefix=/opt/shibboleth-sp -C && make && make install && echo "Completed xmltooling" >> ${SRC}/build.log
cd -

# install opensaml
apt-get install --yes wget gcc g++ make libssl-dev libcurl4-openssl-dev apache2-threaded-dev

cd ${SRC}/opensaml-2.5.5
./configure --with-log4shib=/opt/shibboleth-sp --prefix=/opt/shibboleth-sp -C && make && make install && echo "Completed opensaml" >> ${SRC}/build.log
cd -

# install Shibboloth
cd ${SRC}/shibboleth-sp-2.5.6
./configure --with-log4shib=/opt/shibboleth-sp --enable-apache-24 --with-apxs24=/usr/bin/apxs --prefix=/opt/shibboleth-sp && make && make install && echo "Completed shibboleth" >> ${SRC}/build.log
cd -

exit

# Basic Configuration
# These steps will configure Apache to load mod_shib, supply it with proper host and scheme information, and start shibd.
export LD_LIBRARY_PATH=/opt/shibboleth-sp/lib
cat /vagrant/etc/apache24.conf >> /etc/apache2/apache2.conf
# Set up metadata
cp /vagrant/etc/stage-idp-metadata.xml /opt/shibboleth-sp/etc/shibboleth/stage-idp-metadata.xml
service apache2 restart

# create this folder each home the server starts, as it's an Ubuntu bug
mkdir -g /var/run/shibboleth
# start the service
/opt/shibboleth-sp/sbin/shibd

#if [ ! -d '${SRC}/nginx-http-shibboleth' ]; then
#  git clone https://github.com/nginx-shib/nginx-http-shibboleth.git ${SRC}/nginx-http-shibboleth
#else
#  echo "Already have shibboleth"
#fi
