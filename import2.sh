#!/bin/sh

homebrew_dir="/var/www/localhost/htdocs/homebrew"
homebrew_dir="$(pwd)"

# Initialize an empty list as a space-separated string
HB_IMPORTS=""

# Process each line in the homebrew_urls file
while IFS= read -r line; do
    # Split the line by spaces into positional parameters
    set -- $line
    
    # Download the file with wget
	rm "$homebrew_dir"/"$1"
    wget --directory-prefix "$homebrew_dir" "$2"
    
    # Get the filename from the URL
    filename=$(basename "$2")
    
    # Replace '%20' with a space in the filename
    filename=$(echo "$filename" | sed 's/%20/ /g')
    
    # Move the file to the desired name
    mv "$filename" "$1"
    
    # Append the new file name to the HB_IMPORTS string
    if [ -n "$HB_IMPORTS" ]; then
        HB_IMPORTS="$HB_IMPORTS,$1"
    else
        HB_IMPORTS="$1"
    fi
done < homebrew_urls

# Prepare the final JSON update
# Remove trailing comma, if any
HB_IMPORTS="\"$HB_IMPORTS\""

# Update the index.json file with the new import list
sed -i "s/\"toImport\".*/\"toImport\": [$HB_IMPORTS]/" "$homebrew_dir"/index.json

