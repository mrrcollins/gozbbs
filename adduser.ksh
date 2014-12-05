#/bin/ksh

. ./config

for i in `cat newusers.csv`
do
    username=`echo $i | awk -F ',' '{print $1}'`
    email=`echo $i | awk -F ',' '{print $2}'`
    
    echo -n "Create ${username} with email of ${email}? "
    read yn
    
    if [[ ${yn} = "y" ]]; then
        PW=`pwgen -Av 8 1`
        /usr/sbin/adduser -batch ${username} bbs ${username} ${PW} -shell lynx -class bbs -unencrypted
        cat emailwelcome.txt | sed "s/%%username%%/${username}/" | sed "s/%%password%%/${PW}/" | \
            ./sendEmail -xu ${EMAILUSERNAME} -xp ${EMAILPASSWORD} -u ${EMAILSUBJECT} -f ${EMAILFROM} -s ${EMAILSERVER} -t ${email}
    fi

done

