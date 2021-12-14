# Server vulnerability scanner
This is a simple `bash` script that utilises `syft` and `grype` to check for vulnerabilities on a given server.
## Make sure you are running as root!
```
sudo su -
curl -s https://raw.githubusercontent.com/yaroslav-gwit/vuln-scanner/main/main.sh | bash
```
or
```
sudo su -
curl -s https://raw.githubusercontent.com/yaroslav-gwit/vuln-scanner/main/main.sh | bash -x
```
if you'd like to see the debugging info from bash
