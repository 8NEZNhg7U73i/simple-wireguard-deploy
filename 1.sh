#!/bin/bash -e
show() {
    for i in $(apt list 2>>/dev/stdout | grep -e "installed" | awk -F '/' '{print $1}'); do
        echo $i 2>>/dev/stdout >>/root/out/list.txt
        apt-cache show $i 2>>/dev/stdout >>/root/out/show/$i.txt
        apt-cache showpkg $i 2>>/dev/stdout >>/root/out/showpkg/$i.txt
        apt-cache rdepends $i 2>>/dev/stdout >>/root/out/rdepends/$i.txt
        apt-cache depends $i 2>>/dev/stdout >>/root/out/depends/$i.txt
        echo $i,$(echo $i | grep -o "-" | grep -c "-") 2>>/dev/stdout >>/root/out/list_mod.txt
        (
            IFS=$'\n'
            for j in $(cat /root/out/show/$i.txt); do
                temp=$(echo $j | grep -x "Essential: yes")
                if [ "$temp" == "Essential: yes" ]; then
                    echo "$i" 2>>/dev/stdout >>/root/out/essential.txt
                    break
                fi
                if [ "$temp" == "Priority: required" ]; then
                    echo "$i" 2>>/dev/stdout >>/root/out/essential.txt
                    break
                fi
            done
        )
    done
}
mkdir /root/out
mkdir /root/out/show
mkdir /root/out/showpkg
mkdir /root/out/rdepends
mkdir /root/out/depends
du -x / 2>>/dev/null 1>>/root/out/du.txt
show
