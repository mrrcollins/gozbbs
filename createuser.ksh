#!/bin/rksh
trap "User wants to exit;exit" 2 3 9 15

p()
{
    echo "${1}" | fmt -w 72
}

clear
cat /usr/local/bbs/welcome.txt|fmt -w 72|more

continue=false
while [ ${continue} = "false" ] ; do
	echo -n "Please select a username: "
	read username
	username="$(echo ${username} | tr '[:upper:]' '[:lower:]')"
	continue=true

    eval "getent passwd|cut -f 1 -d ':' | grep -wq ${username}"
    inpasswd=$? 
    eval "cat newusers.csv | cut -f1 -d ','|grep -wq ${username}"
    innewusers=$?

    if [[ ${inpasswd} -eq 0 || ${innewusers} -eq 0 ]]; then
        p "Username already in use"
        continue=false
    fi
    
	if [[ ${#username} -lt 6 ]] ; then
		p "Usernames must be longer than 6 characters"
		continue=false
	fi
	if [[ ${#username} -gt 16 ]] ; then
		p "Usernames must be shorter than 16 characters"
		continue=false
	fi

    if [[ ${username} != @([a-z])*@([0-9a-z]) ]]; then
        p "Usernames must only contain numbers and letters and start with a letter"
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

continue=false
p "\nYour password will be emailed to you, once you log in you can change the password."
while [ ${continue} = "false" ] ; do
	echo -n "Please enter your email address: "
	read email
	email="$(echo ${email} | tr '[:upper:]' '[:lower:]')"
	continue=true

	if [[ ${continue} = "true" ]]; then
		echo -n "You entered ${email}. Is this correct? (y/n) "
		read yn
		if [[ ${yn} != "y" ]]; then
			continue=false
		fi
	fi

done

clear
cat /usr/local/bbs/tos.txt |fmt -w 72 | more

echo -n "\nCreate ${username} with the email address ${email}? "
read yn

if [[ ${yn} = "y" ]]; then
    p "\nPlease check your email soon for your password. Accounts aren't automatically created, so it may be up to 24 before you will receive your password."
    echo "${username},${email}" | tee -a newusers.csv
else
    p "Sorry to hear that, thank you for visiting."
fi
echo "\n\n\n\n"
exit
