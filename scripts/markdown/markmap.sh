#!/bin/bash

base=./
folders=$(find $base \( -name .git -o -name node_modules -o -name cdk.out -o -name dist \) -prune -o -type d -print)
folders=$(echo $folders | sort)

if [ ${#folders} -gt 0 ]; then
    echo "---"
    echo "markmap:"
    echo    "colorFreezeLevel: 2"
    echo "---"
    echo "# markmap"
fi
for folder in $folders; do
    folder=${folder#"$base"}
    alias=${folder##*/}
    alias="$(tr '[:lower:]' '[:upper:]' <<< ${alias:0:1})${alias:1}"
    slashes=$(grep -o "/" <<< $folder | wc -l)
    hashes="##"
    for ((i=0; i<$slashes; i++)); do
        hashes+="#"
    done
    title="$hashes [$alias]($folder)"
    if [ ${#folder} -gt 0 ]; then
        echo "$title" 
    fi
done