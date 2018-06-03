#/bin/bash

mailfrom='pfeilsticker@freenet.de'
mailsub='Dein registrierungscode für pirate feedback auf raugo.de'

mailtext="Hallo #Name, 
Deine Registrierungscode für http://pf.raugo.de/pf/ lautet:

#regkey 

Bitte besuche 

http://pf.raugo.de/pf/index/register.html?invite=#regkey

um Dich dort anzumelden, und die Bastelinstanz von Pirate Feedback zu nutzen

Beste Grüße, Rudi"

 
fromdate=`echo "select date(max(modtime)) from import;" | psql -t companion`

#echo $fromdate

cmd="select comp_name2,comp_emailaddress,regkey from import where comp_user_stimmbaustein='Ja' and modtime>='$fromdate';"

#echo $cmd

OIFS="$IFS" ; IFS=$'\n' ; oset="$-" ; set -f

while IFS="$OIFS" read -a line 
do 
  echo ${line[0]}   
  echo ${line[1]}   
  echo ${line[2]}
  echo ${line[3]}
  echo ${line[4]}

echo $mailtext | sed s/#Name/${line[0]}/g | sed s/#regkey/${line[4]}/g | mail -s $mailsub ${line[2]} 

done < <(echo $cmd |  psql -t companion)

