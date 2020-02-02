#/bin/bash

path="/opt/pirate_feedback/pirate_feedback/companion/"
datei="20200201"


cmd1=" tail -n +5 $path/files/$datei | head -n -6 | sed 's/Ja;Du;hast;alle;Mitgliedsbeiträge;bezahlt;und;bist;stimmberechtigt./Ja/g' | awk  -F\";\" '/Ja/ {printf(\"%s\t\", \$0); next } 1' | sed 's/;;/; ;/g' |  grep --binary-files=text 'und bist stimmberechtig' " 

# ISO_8859-1 UTF-8

cmdmime=" tail -n +5 | head -n -6 | "
cmdmime=""

cmd1=" iconv -fUTF-8 -tUTF-8 $path/files/$datei | $cmdmime  grep --binary-files=text 'stimm' | sed 's/Du hast alle.*bist stimmberechtigt./Ja/g' | sed 's/Es sind nicht.*nicht stimmberechtigt/Nein/g' | sed 's/\"//g' | sed 's/\x27/ /g' "


 echo $cmd1

cols="1,2,3,4,8,10,23,37"

cols2=$(echo $cols | sed 's/,/ \|/g' )  

# eval $cmd1 |  head -1 | awk -F";" '{ for(i = 1; i <= NF; i++) { print i" "$i; } }' | grep "[$cols2]"
# read


eval $cmd1 | cut -d";" -f$cols | cut -d";" -f8 | sort | uniq -c

echo " "

eval $cmd1 | head -5 | cut -d";" -f$cols

echo " "

eval $cmd1 | tail -n +2 | awk -F";" '{ print NF }' | sort -n | uniq -c


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
#eval $cmd1 | tail -n +2 | cut -d";" -f$cols 
#exit


# eval $cmd1 | tail -n +2 | cut -d";" -f$cols | awk -F";" '{print "\""$1"\",\""$2"\",\""$3"\",\""$4"\",\""$5"\",\""$6"\",\""$7"\",\""$8"\"  " }' | sed s/\"/\'/g > current.txt 

eval $cmd1 | tail -n +2 | cut -d";" -f$cols | awk -F";" '{print "select * from checkmember (\""$1"\",\""$2"\",\""$3"\",\""$4"\",\""$5"\",\""$6"\",\""$7"\",\""$8"\" ); " }' | sed s/\"/\'/g |  psql companion -U companion -a


psql companion -Ucompanion -A -c "select regkey,'LV Niedersachsen' from import where comp_user_stimmbaustein='Ja';" | tail -n +2 | awk -F"|" '{print "\""$1"\";\""$2"\"" }' |  head -n -1 > import.txt

echo "$ su www-data"
echo "$ cd <path>/liquid_feedback_frontend"
echo "$ echo \"util.import_members('<csv_file>')\" | ../webmcp/bin/webmcp_shell myconfig"
 
