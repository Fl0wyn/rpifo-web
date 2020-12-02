#!/bin/bash -e

directory_rpifo='/var/www/rpifo/'
cron_rpifo='/etc/cron.d/rpifo'
last_version=$(curl -s https://raw.githubusercontent.com/debmus/rpifo-web/master/VERSION)
SUCCESS=$(echo -e "[\e[32m✔\e[0m] Success :")
ERROR=$(echo -e "[\e[31m✖\e[0m] Error :")
packages_needed=("apache2" "git" "lsb-release" "nmap")

if [[ $EUID -ne 0 ]]; then
	echo "$ERROR Must be run as root"
	exit 0
fi

function packages_install() {
	read -p "Install packages $(echo \"${packages_needed[@]}\") ? [Y/n]: " answer

	if [[ ! $answer =~ [Yy] ]]; then
		exit 0
	fi
	apt update && apt install -y ${packages_needed[@]}
}

function install_rpifo() {
	if [ ! -e $directory_rpifo ] && [ ! -e $directory_rpifo ]; then
		mkdir $directory_rpifo
		chown pi:pi -R $directory_rpifo
	fi

	rm -rf /var/www/rpifo/*

	git clone https://github.com/debmus/rpifo-web.git $directory_rpifo

	echo "# Exporting Pifo data every 5 minutes" >$cron_rpifo
	echo "*/5 * * * * root ${directory_rpifo}export.sh" >>$cron_rpifo
}

function config_apache2() {
	cat <<EOF >>/etc/apache2/sites-available/rpifo.conf
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
EOF
	sed -i '/^Listen.*/a Listen 9696' /etc/apache2/ports.conf
	a2ensite rpifo >/dev/null
	a2enmod headers >/dev/null
	systemctl restart apache2
	chmod +x ${directory_rpifo}export.sh
	bash ${directory_rpifo}export.sh
}

echo "+-------------------------------------------------------------------------------+"
echo -e "|\e[32m\e[1m Rpifo-web\e[0m\e[1m  : WEB Responsive application for real-time Raspberry Pi monitoring\e[0m |"
echo "+-------------------------------------------------------------------------------+"
echo ""
echo " Install and update script"
echo " Version : $now_version"
echo " Github : https://github.com/debmus/rpifo-web"
echo ""

dpkg -s "${packages_needed[@]}" >/dev/null 2>&1 || packages_install

install_rpifo || echo "$ERROR Installation Rpifo error" && exit 1
config_apache2 || echo "$ERROR Config Apache2 error" && exit 1

echo "$SUCCESS Installation completed"
echo "Server listening on : http://$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}'):9696"
