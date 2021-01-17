#!/bin/bash

DIR_RPIFO="${HOME}/rpifo-web/"

sudo apt install -y golang git lsb-release
git clone https://github.com/debmus/rpifo-web.gi $DIR_RPIFO

echo -e "# Exporting Rpifo data every 5 minutes\n*/5 * * * * root ${DIR_RPIFO}/src/export.sh" | sudo tee /etc/cron.d/rpifo-web

cd $DIR_RPIFO
nohup go run server.go >/dev/null 2>&1 &
rm -f nohup.out rpifo-web
echo "Server listening on : http://$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}'):9696"
