#!/bin/bash

DIR_RPIFO="${HOME}/rpifo-web/"
CHECK_GO=$(echo -e "[\e[32m✔\e[0m]")

sudo apt update
sudo apt install -y git lsb-release

cd ${HOME}
git clone https://github.com/debmus/rpifo-web.git

echo "# Exporting Rpifo data every minutes
* * * * * $DIR_RPIFO/scripts/export.sh" | sudo tee /etc/cron.d/rpifo

chmod +x ${DIR_RPIFO}/scripts/export.sh
chmod +x ${DIR_RPIFO}/app.sh
bash ${DIR_RPIFO}/scripts/export.sh
echo -e "\n echo -e "[\e[42m\e[1m SUCCES \e[0m"] Server installed"
