#!/bin/bash -e

directory_rpifo='/var/www/rpifo/'
local_version=$(cat ${directory_rpifo}VERSION >/dev/null)
git_version=$(curl -s https://raw.githubusercontent.com/debmus/rpifo-web/master/VERSION)
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

	function config_rpifo() {
		rm -rf /var/www/rpifo >/dev/null 2>&1
		git clone https://github.com/debmus/rpifo-web.git $directory_rpifo
		chown pi:pi -R $directory_rpifo
	}

	local_version_if=$(echo $local_version |tr '.' ',')
	git_version_if=$(echo $local_version |tr '.' ',')

	if [[ -e $directory_rpifo ]] && [[ -d $directory_rpifo ]]; then
		if [[ $local_version_if -eq $git_version_if ]]; then
			echo -e "\n$ERROR Rpido already installed"
			exit 0
		else
			config_rpifo
			echo -e "\n$SUCCESS Upgrade $local_version to $git_version completed"
			exit 0
		fi
	fi

	config_rpifo
	echo -e "# Exporting Pifo data every 5 minutes\n*/5 * * * * root ${directory_rpifo}export.sh" >/etc/cron.d/rpifo
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
echo " Install and upgrade script"
echo " Version : $git_version"
echo " Github : https://github.com/debmus/rpifo-web"
echo ""

dpkg -s "${packages_needed[@]}" >/dev/null 2>&1 || packages_install

install_rpifo || check_install_rpifo='false'
config_apache2 || check_config_apache2='false'

if [[ $check_install_rpifo = false ]]; then
	echo "$ERROR Installation Rpifo error"
	exit 1
elif [[ $check_config_apache2 = false ]]; then
	echo "$ERROR Config Apache2 error"
	exit 1
else
	echo -e "\n$SUCCESS Installation completed"
	echo "Server listening on : http://$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}'):9696"
fi
