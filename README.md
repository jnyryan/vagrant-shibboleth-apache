# vagrant-shibboleth-sp

An example shibboleth Service Provider that running on Apache and Ubuntu.

## Overview

This is an automated process to set up Shibboleth Service Provider on a
virtual machine hosted in VirtualBox.

Once completed you will have a hosted website [https://localhost:51080/secure](https://localhost:51080/secure)
that redirects to Harvard IdP. Since Harvard do not know who we are, they will
throw an error, but the demo will prove we have set up Shibboleth correctly and
you can alter the IdP as required.

It uses ```vagrant up``` to do 2 things

First, using its VagrantFile
- Downloads, installs and starts an Ubuntu image
- Forwards ports on host 51080 & 51443 to VM ports 80 and 443  

Then, uses the [install script](./install.sh) which does most of the heavy work:
- Updates and installs required packages
- Downloads/installs Shibboleth and its dependencies
- Configures Shibboleth to use an external IdP

## Prerequisites

You'll need both these free apps to get going.

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](https://www.vagrantup.com/)

## Setup

There is some manual work to be done on the VM once the install script has
completed so you will need to ssh to the server and start it there.

First, provision the virtual machine
``` bash
vagrant up provider=virtualbox
```

Now wait 20 minutes while it downloads the components, compiles and installs them.
Coffee at this time might be a good choice, perhaps a few minutes on an xBox or
you console of choice. Mobile games are also a good option.
Or you could read some of the References below.

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

- Set up your own IdP (I will hopefully have this done soon)
- Add your own IdP metadata to replace [stage-idp-metadata.xml](./etc/stage-idp-metadata.xml)
- Update the [shibboleth2.xml](./etc/shibboleth2.xml) to reference your matadata

***Note*** see references below for details on setting up metadata for IdP


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
