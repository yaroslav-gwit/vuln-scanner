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
## I recommend running this check in the background using `tmux`, because if your SSH session drops, you will have to start all over again
```
sudo su -
tmux
curl -s https://raw.githubusercontent.com/yaroslav-gwit/vuln-scanner/main/main.sh | bash
```
To re-connect to existing session:
```
tmux a
```
## To remove `grype`, `syft` and clean up your system, execute the command below:
```
# Become root, if you are not
sudo su -
curl -s https://raw.githubusercontent.com/yaroslav-gwit/vuln-scanner/main/cleanup.sh | bash
```
