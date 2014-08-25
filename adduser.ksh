#/bin/ksh

for i in `cat newusers.csv`
do
    username=`echo $i | awk -F ',' '{print $1}'`
    email=`echo $i | awk -F ',' '{print $2}'`
    
    echo -n "Create ${username} with email of ${email}? "
    read yn

done

