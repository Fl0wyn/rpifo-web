#!/bin/bash

DIR_RPIFO="${HOME}/rpifo-web/"

sudo apt install -y golang git lsb-release

cd ${HOME}
git clone https://github.com/debmus/rpifo-web.git

echo -e "# Exporting Rpifo data every 5 minutes\n*/5 * * * * root ${DIR_RPIFO}/src/export.sh" | sudo tee /etc/cron.d/rpifo-web

nohup go run ${DIR_RPIFO}server.go >/dev/null 2>&1 &
rm -f nohup.out
echo "Server listening on : http://$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}'):9696"
