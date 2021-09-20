#!/bin/bash -e
for i in $(sudo -E apt list 2>/dev/null | grep -e "installed" | awk -F '/' '{print $1}'); do
    sudo -E echo $i >>remove.txt
    sudo -E echo $i
    sudo -E apt-get remove $i 2>>/remove.txt 1>>remove.txt
done
