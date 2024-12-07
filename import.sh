#!/bin/bash

homebrew_dir="/var/www/localhost/htdocs/homebrew"

HB_IMPORTS=()

while read line; do
	read -a array <<< "$line"
	wget -N --directory-prefix "$homebrew_dir" "${array[1]}"
	filename=$(basename "${array[1]}")
	filename=$(echo "$filename" | sed 's/%20/ /g')
	mv "$filename" "${array[0]}"
	HB_IMPORTS+=("${array[0]}")
done <homebrew_urls

IFS=','
printf -v HB_IMPORTS '"%s",' ${HB_IMPORTS[@]}
 
sed -i s/\"toImport\".*/\"toImport\"\:\ \["${HB_IMPORTS%,}"\]/ "$homebrew_dir"/index.json
