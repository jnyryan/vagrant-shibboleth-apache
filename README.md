# vagrant-shibboleth-sp

A shibboleth Service Provider that running on Apache and Ubuntu

## Prerequisites

This sets up Shibboleth on a virtual machine hosted in VirtualBox and uses
Vagrant to script the setup. You'll need both these free apps to get going.

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](https://www.vagrantup.com/)

## Setup

The provisioning of the VM using ```vagrant up``` uses the [install script](./install.sh) which does most of the heavy work:
- Updates and installs required packages
- Downloads/installs Shibboleth and its dependencies
- Forwards ports on host 50080 & 50443 to VM ports 80 and 443

There is some manual work to be done on the VM once the script has completed so you will need to ssh to the server and start it there.

First, provision the virtual machine
``` bash
vagrant up provider=virtualbox
```

Now wait 20 minutes while it downloads the components, compiles and installs them
``` bash
vagrant ssh
```

Once ssh'd, start the service

***Note*** A bug on the Ubuntu version means the directory ```/var/run/shibboleth```
needs to be created each time the server boots as /var/run is volatile.
```bash
mkdir -p /var/run/shibboleth
/opt/shibboleth-sp/sbin/shibd
```

Now from the host try to authenticate.
***Note*** this should direct you to the Harvard IDP, who will give you an error as they don't know who you are.
```bash
curl https://localhost:51080/secure
```

## Next steps

Set up an IdP


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

[Shibboleth Home](https://shibboleth.net/)

[Building the Native SP from Source on Linux](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPLinuxSourceBuild)

[Authentication How-To Guide: SAML/Shibboleth Integration with Apache](http://iam.harvard.edu/resources/saml-shibboleth-integration)

[Integrating Nginx and a Shibboleth SP with FastCGI](https://wiki.shibboleth.net/confluence/display/SHIB2/Integrating+Nginx+and+a+Shibboleth+SP+with+FastCGI)

[Shibboleth auth request module for nginx](https://github.com/nginx-shib/nginx-http-shibboleth)

[Issue with Shibboleth SP Compilation and Installation on Ubuntu 14.04](http://stackoverflow.com/questions/28689298/issue-with-shibboleth-sp-compilation-and-installation-on-ubuntu-14-04)

[ERROR Shibboleth.Listener](http://blog.stastnarodina.com/honza-en/spot/shibboleth-ubuntu/)
