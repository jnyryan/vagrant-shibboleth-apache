# vagrant-shibboleth

  create a shibboleth Service Provider that runs on Apache


# Usage
# bug
if [ ! -e /var/run/shibboleth ]
then
   mkdir /var/run/shibboleth
fi

# start the service
/opt/shibboleth-sp/sbin/shibd

## Troubleshooting
By default, the Shibboleth module is configured to log information on behalf of Apache to
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
