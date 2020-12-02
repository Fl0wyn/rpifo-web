<h1 align="center">
	<img src="https://debmus.github.io/rpifo-web/img/favicon.png"> 
    <br>
    Rpifo-web
</h1>

WEB Responsive application for real-time Raspberry Pi monitoring (French interface)

Satic démo :
https://debmus.github.io/rpifo-web

## Install or upgrade :
```bash
curl -Ls https://raw.githubusercontent.com/debmus/rpifo-web/master/install.sh| sudo bash
```

## Remove :
```bash
sudo rm -rf /var/www/rpifo
sudo rm /etc/cron.d/rpifo
sudo rm /etc/apache2/sites-available/rpifo.conf
sudo a2dissite rpifo
sudo sed -i 's/.*Listen 9696.*//g' /etc/apache2/ports.conf
```