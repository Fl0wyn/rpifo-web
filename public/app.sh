#!/bin/bash

DIR_RPIFO="${HOME}/rpifo-web/"
CHECK_GO=$(echo -e "[\e[32m✔\e[0m]")

if [ -z $1 ]; then
    echo -e "# Rpifo-Web\n\ncd $DIR_RPIFO\n./rpifo-web.sh start|stop"
else
    case $1 in
    start)
        python3 server.py >/dev/null 2>&1 &
        echo -e "$CHECK_GO Server listening on : http://$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}'):9696"
        ${DIR_RPIFO}scripts/export.sh > ${DIR_RPIFO}result.json
        ;;
    stop)
        ps -ef | awk '/[r]pifo/ { print $2 }' | xargs kill >/dev/null 2>&1 &
        echo -e "$CHECK_GO Server stoped"
        ;;
    *) echo "Bye" ;;
    esac
fi
