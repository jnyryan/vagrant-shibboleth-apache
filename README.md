# vagrant-shibboleth

  create a shibboleth Service Provider that runs on Apache on Ubuntu

## Usage

I have not configured it to start up automatically yet so you will need to
ssh to the server and start it there.

Also a bug on the Ubuntu version means the directory ```/var/run/shibboleth```
needs to be created each time the server boots as /var/run is volatile.

``` bash
vagrant up provider=virtualbox
```

Once ssh'd, run the following

```bash
# bug
if [ ! -e /var/run/shibboleth ]
then
   mkdir /var/run/shibboleth
fi

# start the service
/opt/shibboleth-sp/sbin/shibd
```

## The setup

The setup for this in on the file [install script](install_sp_apache.sh) which follows the instructions in
[Download and Install Shibboleth section of this link](http://iam.harvard.edu/resources/saml-shibboleth-integration)

## Configuring and testing with Harvard IdP

[Configure Shibboleth for the Harvard IdP (Pre-Production) Section](http://iam.harvard.edu/resources/saml-shibboleth-integration)

## Troubleshooting
By default, the Shibboleth module is configured to log information on behalf of Apache, these are written to:
```
tail /opt/shibboleth-sp/var/log/shibboleth-www/native.log
tail /opt/shibboleth-sp/var/log/shibboleth-www/native_warn.log
```

shibd creates its own separate logs in
```
tail /opt/shibboleth-sp/var/log/shibboleth/shibd.log        
tail /opt/shibboleth-sp/var/log/shibboleth/shibd_warn.log   
tail /opt/shibboleth-sp/var/log/shibboleth/signature.log    
tail /opt/shibboleth-sp/var/log/shibboleth/transaction.log

```

## References

[https://shibboleth.net/](https://shibboleth.net/)

[Authentication How-To Guide: SAML/Shibboleth Integration with Apache](http://iam.harvard.edu/resources/saml-shibboleth-integration)

[Integrating Nginx and a Shibboleth SP with FastCGI](https://wiki.shibboleth.net/confluence/display/SHIB2/Integrating+Nginx+and+a+Shibboleth+SP+with+FastCGI)

[Shibboleth auth request module for nginx](https://github.com/nginx-shib/nginx-http-shibboleth)

[Issue with Shibboleth SP Compilation and Installation on Ubuntu 14.04](http://stackoverflow.com/questions/28689298/issue-with-shibboleth-sp-compilation-and-installation-on-ubuntu-14-04)

[ERROR Shibboleth.Listener](http://blog.stastnarodina.com/honza-en/spot/shibboleth-ubuntu/)
