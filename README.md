<p align="center">
	<img src="https://debmus.github.io/rpifo-web/img/favicon.png"> 
    <h1 align="center">Rpifo-web</h1>
	<img src="https://img.shields.io/badge/version-2.0-gren.svg?style=for-the-badge">
</p>

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