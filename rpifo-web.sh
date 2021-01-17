#!/bin/bash

CHECK_GO=$(echo -e "[\e[32m✔\e[0m]")

if [ -z $1 ]; then
    echo -e "# Rpifo-Web\n\ncd $DIR_RPIFO\n./rpifo-web.sh start|stop"
else
    case $1 in
    start)
        nohup go run server.go >/dev/null 2>&1 &
        PID_GO=$(echo $!)
        echo -e "$CHECK_GO Server listening on : http://$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}'):9696"
        ;;
    stop)
        kill $PID_GO
        echo -e "$CHECK_GO Server stoped"
        ;;
    *) echo "Bye" ;;
    esac
fi
