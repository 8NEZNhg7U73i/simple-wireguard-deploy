#!/bin/bash -e
show() {
    for i in $(cat list.txt); do
        sudo -E apt-cache show $i 2>>/dev/null >>./show/$i.txt
        sudo -E apt-cache showpkg $i 2>>/dev/null >>./showpkg/$i.txt
        sudo -E apt-cache rdepends $i 2>>/dev/null >>./rdepends/$i.txt
        sudo -E apt-cache depends $i 2>>/dev/null >>./depends/$i.txt
        echo $i,$(echo $i | grep -o "-" | grep -c "-") 2>>/dev/null >>list_mod.txt
        (
            IFS=$'\n'
            for j in $(cat ./show/$i.txt); do
                #$temp="$j"
                temp=$(echo $j | grep -x "Essential: yes")
                #echo "$temp"
                if [ "$temp" == "Essential: yes" ]; then
                    echo "$i" 2>>/dev/null >>essential.txt
                    echo "$i"
                    break
                fi
            done
        )
    done
}
show