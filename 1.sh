#!/bin/bash -e
show() {
    for i in $(sudo -E apt list 2>/dev/stdout | grep -e "installed" | awk -F '/' '{print $1}'); do
        sudo -E echo $i >>list.txt
        sudo -E apt-cache show $i 2>>/dev/stdout >>./show/$i.txt
        sudo -E apt-cache showpkg $i 2>>/dev/stdout >>./showpkg/$i.txt
        sudo -E apt-cache rdepends $i 2>>/dev/stdout >>./rdepends/$i.txt
        sudo -E apt-cache depends $i 2>>/dev/stdout >>./depends/$i.txt
        echo $i,$(echo $i | grep -o "-" | grep -c "-") 2>>/dev/stdout >>list_mod.txt
        (
            IFS=$'\n'
            for j in $(cat ./show/$i.txt); do
                #$temp="$j"
                temp=$(echo $j | grep -x "Essential: yes")
                #echo "$temp"
                if [ "$temp" == "Essential: yes" ]; then
                    echo "$i" 2>>/dev/stdout >>essential.txt
                    echo "$i"
                    break
                fi
            done
        )
    done
}
mkdir show
mkdir showpkg
mkdir rdepends
mkdir depends
show
