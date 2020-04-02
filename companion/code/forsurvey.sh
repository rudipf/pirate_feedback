#/bin/bash

sql="select comp_name2 firstname, comp_name lastname , comp_emailaddress email, 'OK' emailstatus from import where comp_user_stimmbaustein='Ja' and comp_emailaddress like '%@%' order by 2;"


echo $sql | psql -A -F","   -Ucompanion companion | awk -F"," '{ print "\"" $1 "\",\"" $2 "\",\"" $3 "\",\"" $4 "\"" }' 


