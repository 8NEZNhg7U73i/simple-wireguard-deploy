#!/bin/bash -e
for i in $(sudo -E apt list 2>/dev/null | grep -e "installed" | awk -F '/' '{print $1}'); do sudo -E echo $i >>list.txt; done
