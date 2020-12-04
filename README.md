<h1 align="center">
	<img src="https://debmus.github.io/rpifo-web/img/favicon.png"> 
    <br>
    Rpifo-web
</h1>

WEB Responsive application for real-time Raspberry Pi monitoring (French interface)

Satic démo :
https://debmus.github.io/rpifo-web

## Install :
```bash
sudo apt install apache2 git lsb-release

git clone https://github.com/debmus/rpifo-web.git /var/www/rpifo/

sudo chmod +x /var/www/rpifo/export.sh
sudo bash /var/www/rpifo/export.sh
echo -e "# Exporting Pifo data every 5 minutes\n*/5 * * * * root /var/www/rpifo/export.sh" >/etc/cron.d/rpifo
```

## Apache2
```apache
# Exemple apache2 config
# Create file : /etc/apache2/sites-available/rpifo.conf
<VirtualHost *:9696>

	DocumentRoot /var/www/rpifo
	DirectoryIndex index.html

	<Directory /var/www/rpifo>
		Header set Access-Control-Allow-Origin "*"
		Header set Access-Control-Allow-Headers "Content-Type"
		Options FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log common

</VirtualHost>
```

```bash
sudo sed -i '/^Listen.*/a Listen 9696' /etc/apache2/ports.conf
sudo a2ensite rpifo
sudo a2enmod headers
sudo systemctl restart apache2
```

`The server is now listening on : http://<your ip>:9696`

## Upgrade :
```bash
sudo rm -rf /var/www/rpifo/
git clone https://github.com/debmus/rpifo-web.git /var/www/rpifo/
sudo chmod +x /var/www/rpifo/export.sh
sudo bash /var/www/rpifo/export.sh
```

## Remove :
```bash
sudo rm -rf /var/www/rpifo /etc/cron.d/rpifo /etc/apache2/sites-available/rpifo.conf
sudo a2dissite rpifo
sudo sed -i 's/.*Listen 9696.*//g' /etc/apache2/ports.conf
```