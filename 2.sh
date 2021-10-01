#!/bin/bash -e
for i in $(sudo -E apt list 2>/dev/null | grep -e "installed" | awk -F '/' '{print $1}'); do
    sudo -E echo $i >>remove.txt
    sudo -E echo $i
    sudo -E apt-get purge $i 2>>/remove.txt 1>>remove.txt
done

dirlist="Architecture Bugs Conffiles Config-Version Conflicts Breaks Depends Description Enhances Essential Filename Homepage Installed-Size MD5sum MSDOS-Filename Maintainer Origin Package Pre-Depends Priority Provides Recommends Replaces Revision Section Size Source Status Suggests Tag Triggers-Awaited Triggers-Pending Version binary:Package binary:Synopsis binary:Summary db:Status-Abbrev db:Status-Want db:Status-Status db:Status-Eflag db-fsys:Files db-fsys:Last-Modified source:Package source:Version source:Upstream-Version"
mkdir $dirlist
for i in $(dpkg-query -W -f='${Package}\n'); do
    for j in $dirlist; do
        dpkg-query -W -f=${{$j}} $i 1>>./$j/$i.txt &
    done
done
