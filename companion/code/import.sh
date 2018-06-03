#/bin/bash

path="/opt/pirate_feedback/companion/"

cmd1=" tail -n +5 $path/files/20180525214606 | head -n -6 | sed 's/Ja;Du;hast;alle;Mitgliedsbeiträge;bezahlt;und;bist;stimmberechtigt./Ja/g' | awk  -F\";\" '/Ja/ {printf(\"%s\t\", \$0); next } 1' | sed 's/;;/; ;/g' "

cols="1,2,3,4,8,10,24,37"

cols2=$(echo $cols | sed 's/,/ \|/g' )  

# eval $cmd1 |  head -1 | awk -F";" '{ for(i = 1; i <= NF; i++) { print i" "$i; } }' | grep "[$cols2]"
# read

eval $cmd1 | head -2 | cut -d";" -f$cols

echo " "

eval $cmd1 | tail -n +2 | awk -F";" '{ print NF }' | sort | uniq -c


echo 
echo "Ist das Zeilenformat comp_name;comp_name2;comp_user_schwebend;comp_user_mitgliedsnummer;comp_emailaddress;comp_user_mailbounce;comp_user_ov;comp_user_stimmbaustein  ?"
echo "Und haben alle Zeilen die gleiche Spaltenanzahl ?"
echo "Weiter machen mit dem db import ?"
echo "[j/n]"
read answer
if [ "$answer" != "${answer#[Jj]}" ] ;then
    echo Yes
else
    exit 
fi

echo "weiter"


eval $cmd1 | tail -n +2 | cut -d";" -f$cols | awk -F";" '{print "select * from checkmember\(\""$1"\",\""$2"\",\""$3"\",\""$4"\",\""$5"\",\""$6"\",\""$7"\",\""$8"\"\); " }' | sed s/\"/\'/g | psql companion -U companion -a


psql companion -Ucompanion -A -c "select regkey,'Global' from import where comp_user_stimmbaustein='Ja';" | tail -n +2 | awk -F"|" '{print "\""$1"\";\""$2"\"" }' | head -n +1 > import.txt

echo "$ su www-data"
echo "$ cd <path>/liquid_feedback_frontend"
echo "$ echo \"util.import_members('<csv_file>')\" | ../webmcp/bin/webmcp_shell myconfig"
 
