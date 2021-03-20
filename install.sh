#!/bin/bash

DIR_RPIFO="${HOME}/rpifo-web/"
CHECK_GO=$(echo -e "[\e[32m✔\e[0m]")

sudo apt update
sudo apt install -y golang git lsb-release

cd ${HOME}
git clone https://github.com/debmus/rpifo-web.git

echo "# Exporting Rpifo data every 5 minutes
*/5 * * * * root ${DIR_RPIFO}src/export.sh > ${DIR_RPIFO}src/result.json " | sudo tee /etc/cron.d/rpifo-web

chmod +x ${DIR_RPIFO}src/export.sh
echo -e "\n$CHECK_GO Server installed"
bash ${DIR_RPIFO}rpifo-web.sh