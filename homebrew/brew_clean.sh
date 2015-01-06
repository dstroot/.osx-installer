#!/bin/bash

# This script requires that you create and maintain a file that contains the
# package names you want installed on your system. If you don't have one
# already, use the following command and delete the package names what you
# don't want to keep installed.

# brew leaves > brew_packages
# Then you can remove all installed, but unwanted packages and any unnecessary dependencies by running the following command

# brew_clean brew_packages
# brew_clean is available here: https://gist.github.com/cskeeters/10ff1295bca93808213d

# This script gets all of the packages you specified in brew_packages and all of their dependancies and compares them against the output of brew list and finally removes the unwanted packages after verifying this list with the user.

# At this point if you want to remove package a, you simply remove it from the brew_packages file then re-run brew_clean brew_packages. It will remove b, but not c.

if [ "$#" -ne "1" ]; then
    echo "Usage: $0 Brewfile"
    exit 1
fi

cat $1 | grep -v -e '#' -e '^[[:space:]]*$' | xargs -I {} bash -c "echo {}; brew deps {}" | sort | uniq | cut -d' ' -f1 > /tmp/brew_keep
comm -23 <(brew list -1 | sort) <(cat /tmp/brew_keep) > /tmp/brew_rm
lines=$(cat /tmp/brew_rm | wc -l | sed -e 's/ //g')
if [ "$lines" -ne "0" ]; then
    echo "Remove the following packages?"
    cat /tmp/brew_rm
    read -p "Remove? [Y/n]" ans
    if [ "$ans" == "Y" ]; then
        brew rm $(cat /tmp/brew_rm)
    fi
else
    echo "All clean"
fi
rm -f /tmp/brew_keep /tmp/brew_rm
