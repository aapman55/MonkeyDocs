# SSL-Certificates

## Windows
Windows has system certificates which other applications can make use of. This is not always
configured correctly, which might lead to errors.

In the next sections the solution is provided for several applications.

### Python
You can install the following package (source: https://stackoverflow.com/a/57053415):

```commandline
pip install pip-system-certs
```

### Git
You can tell Git to use schannel. (source: https://stackoverflow.com/a/48212753)

```commandline
git config --global http.sslBackend schannel
```
