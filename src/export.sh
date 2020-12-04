#!/bin/bash

# Hostname
show_hote=$(hostname)
# IP Address
show_ip=$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}')
# Distribution
show_os=$(echo "$(lsb_release -d | awk '{$1="";print}') - ($(cat /etc/debian_version))" | sed -e '1s/^.//')
# Kernel version
show_kernel=$(uname -srm)
# Temperature
show_temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
# Uptime
show_uptime=$(uptime -p | sed 's/up //g; s/hour/Heure/g; s/hours/Heures/g; s/day/Jour/g; s/days/Jours/g; s/week/Semaine/g; s/weeks/Semaines/g; s/month/Mois/g')
# CPU Load
show_loadaverage=$(cat /proc/loadavg)
show_loadaverage1=$(echo $show_loadaverage | awk '{print $1}')
show_loadaverage2=$(echo $show_loadaverage | awk '{print $2}')
show_loadaverage3=$(echo $show_loadaverage | awk '{print $3}')
# Task
show_tasks=$(top -b -n 1 | awk '/Tasks/ {print $2}')
# Last SSH
show_ssh=$(cat /var/log/auth.log | egrep '(sshd.*Accepted)' | tail -1 | awk '{print $11,"(Le "$2,$1,"à "$3")"}')

# SD card
exec_df=$(df)
exec_df_H=$(df -h)
show_sd_total=$(echo "$exec_df" | awk '/root/ {print $2}')
show_sd_used=$(echo "$exec_df" | awk '/root/ {print $3}')
show_sd_total_H=$(echo "$exec_df_H" | awk '/root/ {print $2}')
show_sd_used_H=$(echo "$exec_df_H" | awk '/root/ {print $3}')
show_sd_free_H=$(echo "$exec_df_H" | awk '/root/ {print $4}')

# Memory + Swap
exec_free=$(free --kilo)
exec_free_H=$(free --kilo -h)
# Memory
show_mem_total=$(echo "$exec_free" | awk '/Mem:/ {print $2}')
show_mem_used=$(echo "$exec_free" | awk '/Mem/ {print $3}')
show_mem_total_H=$(echo "$exec_free_H" | awk '/Mem:/ {print $2}')
show_mem_used_H=$(echo "$exec_free_H" | awk '/Mem/ {print $3}')
show_mem_free_H=$(echo "$exec_free_H" | awk '/Mem/ {print $4}')

# Swap
show_swap_total=$(echo "$exec_free" | awk '/Swap:/ {print $2}')
show_swap_used=$(echo "$exec_free" | awk '/Swap/ {print $3}')
show_swap_total_H=$(echo "$exec_free_H" | awk '/Swap:/ {print $2}')
show_swap_used_H=$(echo "$exec_free_H" | awk '/Swap/ {print $3}')
show_swap_free_H=$(echo "$exec_free_H" | awk '/Swap/ {print $4}')

echo "{
    \"hote\": \"$show_hote\",
    \"temp\": \"$show_temp\",
    \"info\": [
        {
            \"title\": \"Adresse IP\",
            \"response\": \"$show_ip\"
        },
        {
            \"title\": \"Distribution\",
            \"response\": \"$show_os\"
        },
        {
            \"title\": \"Version du noyau\",
            \"response\": \"$show_kernel\"
        },
        {
            \"title\": \"Temps d'utilisation\",
            \"response\": \"$show_uptime\"
        },
        {
            \"title\": \"Processus en cours\",
            \"response\": \"$show_tasks\"
        },
        {
            \"title\": \"Dernière connexion SSH\",
            \"response\": \"$show_ssh\"
        }
    ],
    \"cpu\": [
        {
            \"title\": \"$show_loadaverage1\"
        },
        {
            \"title\": \"$show_loadaverage2\"
        },
        {
            \"title\": \"$show_loadaverage3\"
        }
    ],
    \"mem\": [
        {
            \"total\": \"$show_mem_total\",
            \"use\": \"$show_mem_used\",
            \"totalH\": \"$show_mem_total_H\",
            \"useH\": \"$show_mem_used_H\",
            \"freeH\": \"$show_mem_free_H\"
        }
    ],
    \"swap\": [
        {
            \"total\": \"$show_swap_total\",
            \"use\": \"$show_swap_used\",
            \"totalH\": \"$show_swap_total_H\",
            \"useH\": \"$show_swap_used_H\",
            \"freeH\": \"$show_swap_free_H\"

        }
    ],
    \"sd\": [
        {
            \"total\": \"$show_sd_total\",
            \"use\": \"$show_sd_used\",
            \"totalH\": \"$show_sd_total_H\",
            \"useH\": \"$show_sd_used_H\",
            \"freeH\": \"$show_sd_free_H\"
        }
    ]
}" >/var/www/rpifo/src/result.json
