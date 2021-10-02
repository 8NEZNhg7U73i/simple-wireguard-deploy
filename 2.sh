#!/bin/bash -e
for i in $(sudo -E apt list 2>/dev/null | grep -e "installed" | awk -F '/' '{print $1}'); do
    sudo -E echo $i >>remove.txt
    sudo -E echo $i
    sudo -E apt-get purge $i 2>>/remove.txt 1>>remove.txt
done

dirlist=(Architecture Bugs Conffiles Config-Version Conflicts Breaks Depends Description Enhances Essential Filename Homepage Installed-Size MD5sum MSDOS-Filename Maintainer Origin Package Pre-Depends Priority Provides Recommends Replaces Revision Section Size Source Status Suggests Tag Triggers-Awaited Triggers-Pending Version binary_Package binary_Synopsis binary_Summary db_Status-Abbrev db_Status-Want db_Status-Status db_Status-Eflag db-fsys_Files db-fsys_Last-Modified source_Package source_Version source_Upstream-Version)
fmtlist=(Architecture Bugs Conffiles Config-Version Conflicts Breaks Depends Description Enhances Essential Filename Homepage Installed-Size MD5sum MSDOS-Filename Maintainer Origin Package Pre-Depends Priority Provides Recommends Replaces Revision Section Size Source Status Suggests Tag Triggers-Awaited Triggers-Pending Version binary:Package binary:Synopsis binary:Summary db:Status-Abbrev db:Status-Want db:Status-Status db:Status-Eflag db-fsys:Files db-fsys:Last-Modified source:Package source:Version source:Upstream-Version)
for ((j = 1; j <= ${#dirlist[@]}; j++)); do
    mkdir ${dirlist[$j - 1]}
done
for i in $(dpkg-query -W -f='${Package}\n'); do
    for ((j = 1; j <= ${#fmtlist[@]}; j++)); do
        dirname=${dirlist[$j - 1]}
        pkgname=$i
        fmtname=${fmtlist[$j - 1]}
        dpkg-query -W -f=\$"{$fmtname}" $pkgname 1>>./$dirname/$pkgname.txt &
    done
done
