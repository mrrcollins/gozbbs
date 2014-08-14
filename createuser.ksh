#!/bin/ksh

continue=false

while [ ${continue} = "false" ] ; do
	echo -n "Please select a username: "
	read username
	username="$(echo ${username} | tr '[:upper:]' '[:lower:]')"
	continue=true

	if [[ ${#username} -lt 6 ]] ; then
		echo "Usernames must be longer than 6 characters"
		continue=false
	fi
	if [[ ${#username} -gt 16 ]] ; then
		echo "Usernames must be shorter than 16 characters"
		continue=false
	fi

    valid='0-9a-z'
    if [[ ${username} != @([a-z])*@([0-9a-z]) ]]; then
        echo "Usernames must only contain numbers and letters and start with a letter"
        continue=false
    fi    

	if [[ ${continue} = "true" ]]; then
		echo -n "You chose ${username}. Is this the username you want? (y/n) "
		read yn
		if [[ ${yn} != "y" ]]; then
			continue=false
		fi
	fi
done

