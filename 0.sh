#!/bin/bash -e
sudo -E du -x / 2>>/dev/null 1>>du.txt

for i in $(ls); do
    cat $i | while read -r; do
        temp="$REPLY"
        echo "$temp"
        if [ "$temp" == "Package: "$temp"" ]; then
            pkg="$REPLY"
        fi
        list=$(echo "$temp" | grep -x "Essential: yes")
        if [ "$list" == "Essential: yes" ]; then
            echo "$temp"
        fi
    done
done

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
