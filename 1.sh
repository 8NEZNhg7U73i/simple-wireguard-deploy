#!/bin/bash -e
list() {
    for i in $(apt list 2>>/dev/stdout | grep -e "installed" | awk -F '/' '{print $1}'); do
        echo $i 2>>/dev/stdout >>/root/out/list.txt
    done
}
show() {
    for i in $(cat /root/out/list.txt); do
        apt-cache show $i 2>>/dev/stdout >>/root/out/show/$i.txt
    done
}
showpkg() {
    for i in $(cat /root/out/list.txt); do
        apt-cache showpkg $i 2>>/dev/stdout >>/root/out/showpkg/$i.txt
    done
}
rdepends() {
    for i in $(cat /root/out/list.txt); do
        apt-cache rdepends $i 2>>/dev/stdout >>/root/out/rdepends/$i.txt
    done
}
depends() {
    for i in $(cat /root/out/list.txt); do
        apt-cache depends $i 2>>/dev/stdout >>/root/out/depends/$i.txt
    done
}
list_mod() {
    for i in $(cat /root/out/list.txt); do
        echo $i,$(echo $i | grep -o "-" | grep -c "-") 2>>/dev/stdout >>/root/out/list_mod.txt
    done
}
essential() {
    for i in $(cat /root/out/list.txt); do
        (
            IFS=$'\n'
            for j in $(cat /root/out/show/$i.txt); do
                if [ "$(echo $j | grep -x "Essential: yes")" == "Essential: yes" ]; then
                    echo "$i" 2>>/dev/stdout >>/root/out/essential.txt
                    break
                fi
                if [ "$(echo $j | grep -x "Priority: required")" == "Priority: required" ]; then
                    echo "$i" 2>>/dev/stdout >>/root/out/essential.txt
                    break
                fi
                if [ "$(echo $j | grep -x "Build-Essential: yes")" == "Build-Essential: yes" ]; then
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
list
show
for i in showpkg depends rdepends list_mod; do
    $i &
done
essential
for i in $(cat essential.txt); do
    echo "$i"
    sed -i ':a;N;$!ba;s/'$i'\n//g' /root/out/list.txt
done
docker rm -vf $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
