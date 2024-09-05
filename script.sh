#!/bin/bash

# Function to show usage
usage() {
    echo "Usage: $0 <domain> <file1> [file2 ...]"
    echo "  -p    Add protocol (http:// or https://) to the subdomains"
    exit 1
}

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    usage
fi

# Extract domain argument
domain=$1
shift

# Check for optional protocol flag
add_protocol=false
if [ "$1" == "-p" ]; then
    add_protocol=true
    shift
fi

# Create or clear the zubs.txt file
> zubs.txt

# Process each file
for file in "$@"; do
    if [ -f "$file" ]; then
        if [ "$add_protocol" = true ]; then
            # Extract lines with http:// or https:// and domain
            cat "$file" | grep -oP "(http://|https://)?[a-zA-Z0-9.-]+\.$domain" | sort -u >> zubs.txt
        else
            # Extract lines with domain only
            cat "$file" | grep -oP "[a-zA-Z0-9.-]+\.$domain" | sort -u >> zubs.txt
        fi
    else
        echo "File $file does not exist."
    fi
done

echo "Subdomains extracted to zubs.txt"
