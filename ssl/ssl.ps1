$subject = "/CN=test.home"
$dnsAndIps = "subjectAltName=DNS:your-dns.record,IP:257.10.10.1"


Write-Output $dnsAndIps

openssl genrsa -aes256 -out ca-key.pem 4096

openssl req -new -x509 -sha256 -days 3650 -key ca-key.pem -out ca.pem

openssl genrsa -out cert-key.pem 4096

openssl req -new -sha256 -subj $subject -key cert-key.pem -out cert.csr

Write-Output "Create cnf"
Write-Output $dnsAndIps >> extfile.cnf

Write-Output "Create cert.pem"
openssl x509 -req -sha256 -days 3650 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial

Write-Output "Create fullchain certificate"
cat cert.pem > fullchain.pem
cat ca.pem >> fullchain.pem

Write-Output "Create cert.pfx"
openssl rsa -in cert-key.pem -out private.key
openssl pkcs12 -export -out certificate.pfx -inkey private.key -in cert.pem -certfile cert.pem
