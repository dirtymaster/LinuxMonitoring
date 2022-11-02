#!/bin/bash

TIMEFORMAT="Script execution time (in seconds) = %R"

time {
    if ! [[ -d $1 ]] || ! [[ ${1:(-1)} == "/" ]]
    then
    echo "Error"
    exit
    fi

    START=$(date +%s%N)

    echo "Total number of folders (including all nested ones) = \
    $(($(find ${1} -type d| wc -l)-1))"

    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    for ((i = 2; i <= 6; i++))
    {
        TOP_5_FOLDERS=$(du ${1} | sort -rnk1 | head -n 6 | awk "(NR==${i})")
        if ! [[ -z $TOP_5_FOLDERS ]]; then
            echo -n "$((${i}-1)) - "
            echo -n $(echo "${TOP_5_FOLDERS}" | awk '{print $2}')
            echo -n ", "
            echo -n $(echo "${TOP_5_FOLDERS}" | awk '{print $1}')
            echo "KB"
        fi
    }

    echo "Total number of files = $(find ${1} -type f | wc -l)"

    echo "Number of:"
    echo "Configuration files (with the .conf extension) = \
    $(find ${1} -type f -iname "*.conf" | wc -l)"

    echo "Text files = $(find ${1} -type f -iname "*.txt" | wc -l)"

    echo "Executable files = $(find ${1} -type f -perm /a=x | wc -l)"

    echo "Log files (with the extension .log) = \
    $(find ${1} -type f -iname "*.log" | wc -l)"

    echo "Archive files = \
    $(find ${1} -type f -iregex ".*\.(zip|rar|gz|tar|7z)$" | wc -l)"

    echo "Symbolic links = $(find ${1} -type l | wc -l)"

    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    TOP_10_FILES=$(find "${1}" -type f -print0 | xargs -0 du -h | sort -rh | head -n 10)
    IFS=$'\n'
    i=0
    for file in $TOP_10_FILES
    do
        FILE_SIZE=$(echo "$file" | awk '{print $1}')
        FILE_PATH=$(echo "$file" | awk '{print $2}')
        i=$(( i + 1 ))
        echo "${i} - ${FILE_PATH}, ${FILE_SIZE}"
    done

    echo "TOP 10 executable files of the maximum size arranged in descending order \
    (path, size and MD5 hash of file)"
    TOP_10_FILES2=$(find "${1}" -type f -perm /a=x -print0 | xargs -0 du -h | sort -rh | head -n 10)
    IFS=$'\n'
    i=0
    for file2 in $TOP_10_FILES2
    do
        FILE_SIZE2=$(echo "$file2" | awk '{print $1}')
        FILE_PATH2=$(echo "$file2" | awk '{print $2}')
        MD5=$(md5sum ${FILE_PATH2} | awk '{print $1}')
        i=$(( i + 1 ))
        echo "${i} - ${FILE_PATH2}, ${FILE_SIZE2}, ${MD5}"
    done
}