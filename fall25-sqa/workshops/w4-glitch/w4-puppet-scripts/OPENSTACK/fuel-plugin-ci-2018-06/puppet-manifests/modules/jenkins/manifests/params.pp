# Class: jenkins::params
#
class jenkins::params {
  $slave_authorized_keys = {}
  $slave_java_package = 'openjdk-7-jre-headless'

  $swarm_labels = ''
  $swarm_master = ''
  $swarm_user = ''
  $swarm_password = ''
  $swarm_package = 'jenkins-swarm-slave'
  $swarm_service = 'jenkins-swarm-slave'

  $ssl_cert_file = '/etc/ssl/jenkins.crt'
  $ssl_cert_file_contents = '-----BEGIN CERTIFICATE-----
MIIDPjCCAiYCCQCiiKl1cghBuDANBgkqhkiG9w0BAQUFADBhMQswCQYDVQQGEwJB
VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
cyBQdHkgTHRkMRowGAYDVQQDDBFzZXJ2ZXIudGVzdC5sb2NhbDAeFw0xNDA4MTEy
MDAzNTVaFw0xNTA4MTEyMDAzNTVaMGExCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApT
b21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQxGjAY
BgNVBAMMEXNlcnZlci50ZXN0LmxvY2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAtjgfpwJsZBz4bY/QgV69S1P5+54d+1lAxmoWDe++US3EdzVGWR8+
oaHO4crxDztTyOTJtstC/MkRCZngxUZdcpJz9T3v70pT/tfu95fVJaX1fLjcCdw3
wD1IMcGIzjtMzDLujYoeM7mdjR9ixzN5WiQFnngQkwqeEsQltV3jJSqn3U+P093l
6eVnSdfhLT+q8mvWYr8fhx4el3SHyk8qRomYj4gnsEJ3dGtjDNF9CI7XL2pZXVeD
PZZQKI5Fc3tYnSAUbvXO7fdeAn2QLG0kntkPLPGGAJspr8Vq3Ic/glbPBj6BsdYj
0jOMwWRYpCV2lk/CFZN03BUx6JPQMxbWHQIDAQABMA0GCSqGSIb3DQEBBQUAA4IB
AQBlKH2m2AdkmASM1Q7J/LA0NnanqUvy4n+zhYb8NarOLEHG+OzLBLyW/y51X3cb
0IOzHHupA3cu38TuXnIGnoT/M3QsKKKz8smthHLvb7RPiVkJNYMLm8ZJlX2uCQSu
rN4ikYHut6bElAf2yZDOiLhDhhFhIwQTj1vm+4gmYFnexcHylLvRY3ulkN/MccXr
NyObrYJYR4jB5C+S9rCTN7gU7jX6fCD2NoY5DGdpBkSNvnSIWDPftRExLkMC4vvs
hrL5z+KEJjQEQJMMQFgdt1kDeLcnFmZl3sqhRFs0/2alyRmxTxkrUtLn3z68RsZy
gDKsvK5qpm7hWt35IVL3nZsZ
-----END CERTIFICATE-----'
}
