#!/bin/bash

if [[ "$#" -ne 4 ]] ; then
    echo "Введите 4 параметра"
    exit
fi

for number in "$@"
do
    if ! [[ $number == [1-6] ]] ; then
        echo "Параметр должен быть числом от 1 до 6"
        exit
    fi
done

if [[ $1 == $2 ]] || [[ $3 == $4 ]] ; then
    echo "Цвет текста и цвет фона не должны совпадать"
    exit
fi

HOSTNAME=$HOSTNAME
TIMEZONE="$(timedatectl | grep "Time zone" | grep -o '[^:"]\+/[^"]\+* (' | \
sed 's/ //; s/(//')UTC $(timedatectl | grep "Time zone" | grep -o '[+-][0-9]*' | \
sed 's/0//; s/0//; s/0//')"
USER=$USER
OS="$(cat /etc/issue | sed 's/\\n//')"
DATE="$(date | sed -e 's/[А-Я]//; s/[а-я]//; s/ //; s/ [A-Z]//; s/[A-Z]//; s/[A-Z]//; s/[A-Z]//')"
UPTIME="$(uptime -p)"
UPTIME_SEC="$(cat /proc/uptime | sed -e 's/\..*//g')"
IP=$(ip a | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | awk '(NR==2)')
MASK="$(ifconfig | grep $IP | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | awk '(NR==2)')"
GATEWAY="$(ip -4 route show default | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '(NR==1)')"
RAM_TOTAL="0$(echo "scale=3;$(grep MemTotal /proc/meminfo | grep -o "[0-9]*")/1048576" | bc -l) GB"
RAM_USED="0$(echo "scale=3;$(vmstat -s | grep "used memory" | grep -o "[0-9]*")/1048576" | bc -l) GB"
RAM_FREE="0$(echo "scale=3;$(grep MemFree /proc/meminfo | grep -o "[0-9]*")/1048576" | bc -l) GB"
SPACE_ROOT="$(echo "scale=3;$(df -k / | grep /dev | grep -o "[0-9]*" | awk '(NR==1)')/1024" | bc -l) MB"
SPACE_ROOT_USED="$(echo "scale=3;$(df -k / | grep /dev | grep -o "[0-9]*" | awk '(NR==2)')/1024" | bc -l) MB"
SPACE_ROOT_FREE="$(echo "scale=3;$(df -k / | grep /dev | grep -o "[0-9]*" | awk '(NR==3)')/1024" | bc -l) MB"

text_color() {
    case ${1} in
        1) echo "\033[37m";;
        2) echo "\033[31m";;
        3) echo "\033[32m";;
        4) echo "\033[34m";;
        5) echo "\033[35m";;
        6) echo "\033[30m";;
    esac
}

background_color() {
    case ${1} in
        1) echo "\033[47m";;
        2) echo "\033[41m";;
        3) echo "\033[42m";;
        4) echo "\033[44m";;
        5) echo "\033[45m";;
        6) echo "\033[40m";;
    esac
}

COLOR_OFF="\033[0m"
NAME_BACKGROUND_COLOR=$(background_color "$1")
NAME_TEXT_COLOR=$(text_color "$2")
VALUE_BACKGROUD_COLOR=$(background_color "$3")
VALUE_TEXT_FOLOR=$(text_color "$4")

echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}HOSTNAME${COLOR_OFF}        = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${HOSTNAME}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}TIMEZONE${COLOR_OFF}        = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${TIMEZONE}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}USER${COLOR_OFF}            = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${USER}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}OS${COLOR_OFF}              = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${OS}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}DATE${COLOR_OFF}            = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${DATE}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}UPTIME${COLOR_OFF}          = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${UPTIME}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}UPTIME_SEC${COLOR_OFF}      = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${UPTIME_SEC}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}IP${COLOR_OFF}              = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${IP}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}MASK${COLOR_OFF}            = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${MASK}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}GATEWAY${COLOR_OFF}         = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${GATEWAY}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}RAM_TOTAL${COLOR_OFF}       = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${RAM_TOTAL}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}RAM_USED${COLOR_OFF}        = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${RAM_USED}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}RAM_FREE${COLOR_OFF}        = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${RAM_FREE}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}SPACE_ROOT${COLOR_OFF}      = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${SPACE_ROOT}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}SPACE_ROOT_USED${COLOR_OFF} = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${SPACE_ROOT_USED}${COLOR_OFF}"
echo -e "${NAME_TEXT_COLOR}${NAME_BACKGROUND_COLOR}SPACE_ROOT_FREE${COLOR_OFF} = ${VALUE_TEXT_FOLOR}${VALUE_BACKGROUD_COLOR}${SPACE_ROOT_FREE}${COLOR_OFF}"