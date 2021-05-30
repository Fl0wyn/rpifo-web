#!/bin/bash

: '
crontab -e
## RPIFO
* * * * * $HOME/test/export.sh
'

show_host=$(hostname)
show_temp="$(sudo vcgencmd measure_temp | tr -d -c .0-9)"

show_tasks=$(top -b -n 1 | awk '/Tasks/ {print $2}')
show_proc=$(cat /proc/loadavg | awk '{print $1,$2,$3}')

show_df=$(df | sed -n "2p" | awk '{print $2,$3,$4}')
show_mem=$(free --kilo | awk '/Mem/ {print $2,$3,$4}')
show_swap=$(free --kilo | awk '/Swap/ {print $2,$3,$4}')

show_model=$(cat /proc/device-tree/model | cut -d' ' --complement -s -f6,7)
show_distrib=$(echo "$(lsb_release -d | awk '{$1="";print}' | sed '$ s/.$//') $(cat /etc/debian_version))" | sed -e '1s/^.//')
show_kernel=$(uname -srm)
show_ip=$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}')
show_uptime=$(uptime -p | sed 's/up //g')
show_ssh=$(cat /var/log/auth.log | egrep '(sshd.*Accepted)' | tail -1 | awk '{print $11,"("$1,$2,$3")"}')

func() {

    echo '{'
    echo '"host": "'$show_host'",'
    echo '"temp": "'$show_temp'",'

    echo '"cpu": "'$show_proc'",'
    echo '"task": "'$show_tasks'",'

    echo '"df": "'$show_df'",'
    echo '"mem": "'$show_mem'",'
    echo '"swap": "'$show_swap'",'

    echo '"info": ['
    echo '{"title": "'Model'","response": "'$show_model'"},'
    echo '{"title": "'Distribution'","response": "'$show_distrib'"},'
    echo '{"title": "'Kernel version'","response": "'$show_kernel'"},'
    echo '{"title": "'IP address'","response": "'$show_ip'"},'
    echo '{"title": "'Uptime'","response": "'$show_uptime'"},'
    echo '{"title": "'Last SSH login'","response": "'$show_ssh'"}'

    echo ']}'

}

func >$HOME/test/result.json
