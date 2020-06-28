#/bin/bash

path="/opt/pirate_feedback/pirate_feedback/companion/"
datei="20200613"

sql="select comp_user_mitgliedsnummer, comp_name2 firstname, comp_name lastname from import where comp_user_stimmbaustein='Ja' and comp_emailaddress like '%@%' order by 1 ;"


echo $sql | psql -t -A -F"," -Ucompanion companion | while IFS= read -r LINE; do

IFS=","

#    echo $LINE
array=($LINE)
pattern=";\"${array[0]}\";"
# echo $pattern
a=`grep -c -e $pattern $path/files/$datei`
if [ $a -ge  "1" ]; then

#echo ${array[0]}
b=$a 
else
echo $LINE
sql2="update import set comp_user_stimmbaustein='Nein' where comp_user_mitgliedsnummer='${array[0]}' ;"
#echo $sql2 | psql -Ucompanion companion

fi

done 

