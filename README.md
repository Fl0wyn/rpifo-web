<h1 align="center">
	<img src="https://raw.githubusercontent.com/debmus/rpifo-web/master/src/img/favicon.png">
    <br>
    Rpifo-web
</h1>

WEB Responsive application for real-time Raspberry Pi monitoring (French interface)

Satic démo :
https://debmus.github.io/rpifo-web


# Quick install
```bash
curl -L https://raw.githubusercontent.com/debmus/rpifo-web/master/install.sh | bash
```

# Manually install with apache2
```bash
# Install needed packages
sudo apt update
sudo apt install apache2 git lsb-release

# Clone repo
sudo git clone https://github.com/debmus/rpifo-web.git /var/www/rpifo/

sudo chmod +x /var/www/rpifo/src/export.sh
sudo bash /var/www/rpifo/src/export.sh

# Add cron task every 5 minutes
echo "# Exporting Pifo data every 5 minutes
*/5 * * * * root /var/www/rpifo/src/export.sh > /var/www/rpifo/src/result.json" | sudo tee /etc/cron.d/rpifo
```

```bash
sudo nano /etc/apache2/sites-available/rpifo.conf
```
```apache
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
# Add port '9696' in apache2 port config file
sudo sed -i '/^Listen.*/a Listen 9696' /etc/apache2/ports.conf

# Enabled this config
sudo a2ensite rpifo

# Enabled 'headers' module and restart service
sudo a2enmod headers
sudo systemctl restart apache2
```

The server is now listening on : `http://<rpi_ip>:9696`

***

## Upgrade version
```bash
sudo rm -rf /var/www/rpifo
sudo git clone https://github.com/debmus/rpifo-web.git /var/www/rpifo/
sudo chmod +x /var/www/rpifo/src/export.sh
sudo bash /var/www/rpifo/src/export.sh
```

## Remove project
```bash
sudo rm -rf /var/www/rpifo /etc/cron.d/rpifo /etc/apache2/sites-available/rpifo.conf
sudo a2dissite rpifo
sudo sed -i 's/.*Listen 9696.*//g' /etc/apache2/ports.conf
```