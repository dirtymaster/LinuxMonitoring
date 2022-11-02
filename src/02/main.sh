#!/bin/bash

func() {
    echo "HOSTNAME = $HOSTNAME"
    echo -n "TIMEZONE = "
    echo -n "$(timedatectl | grep "Time zone" | grep -o '[^:"]\+/[^"]\+* (' | sed 's/ //; s/(//')UTC "
    echo "$(timedatectl | grep "Time zone" | grep -o '[+-][0-9]*' | sed 's/0//; s/0//; s/0//')"
    # echo "USER = $USER"
    echo "USER = $(whoami)"
    echo "OS = $(cat /etc/issue)"
    echo "DATE = $(date | sed -e 's/[А-Я]//; s/[а-я]//; s/ //; s/ [A-Z]//; s/[A-Z]//; s/[A-Z]//; s/[A-Z]//')"
    echo "UPTIME = $(uptime -p)"
    echo "UPTIME_SEC = $(cat /proc/uptime | sed -e 's/\..*//g')"
    IP=$(ip a | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | awk '(NR==2)')
    echo "IP = $IP"
    echo "MASK = $(ifconfig | grep $IP | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | awk '(NR==2)')"
    echo "GATEWAY = $(ip -4 route show default | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '(NR==1)')"
    # TOTAL=$(echo "scale=3;$(grep MemTotal /proc/meminfo | grep -o "[0-9]*")/1000" | bc -l)
    echo "RAM_TOTAL = 0$(echo "scale=3;$(grep MemTotal /proc/meminfo | grep -o "[0-9]*")/1048576" | bc -l) GB"
    echo "RAM_USED = 0$(echo "scale=3;$(vmstat -s | grep "used memory" | grep -o "[0-9]*")/1048576" | bc -l) GB"
    echo "RAM_FREE = 0$(echo "scale=3;$(grep MemFree /proc/meminfo | grep -o "[0-9]*")/1048576" | bc -l) GB"
    echo "SPACE_ROOT = 0$(echo "scale=3;$(df -k / | grep /dev | grep -o "[0-9]*" | awk '(NR==1)')/1024" | bc -l) MB"
    echo "SPACE_ROOT_USED = 0$(echo "scale=3;$(df -k / | grep /dev | grep -o "[0-9]*" | awk '(NR==2)')/1024" | bc -l) MB"
    echo "SPACE_ROOT_FREE = 0$(echo "scale=3;$(df -k / | grep /dev | grep -o "[0-9]*" | awk '(NR==3)')/1024" | bc -l) MB"
}

func

read -p "Записать данные в файл?" choice
if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
    func > ./$(date +"%d_%m_%y_%H_%M_%S").status
fi