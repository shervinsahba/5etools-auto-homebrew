#!/bin/sh

homebrew_dir="/var/www/localhost/htdocs/homebrew"

HB_IMPORTS=""

# Process each line in the homebrew_urls file
while IFS= read -r line; do
    # Split the line by spaces into positional parameters
    set -- $line
    
    wget --directory-prefix "$homebrew_dir" "$1"
	
	filename=$(basename "$1" | sed 's/%20/ /g')

	mv "$homebrew_dir"/$(basename "$1") "$filename"

    if [ -n "$HB_IMPORTS" ]; then
        HB_IMPORTS="$HB_IMPORTS,\"$filename\""
    else
        HB_IMPORTS=\""$filename"\"
    fi
done < homebrew_urls

# Update the index.json file with the new import list
sed -i "s/\"toImport\".*/\"toImport\":\ [$HB_IMPORTS]/" "$homebrew_dir"/index.json

