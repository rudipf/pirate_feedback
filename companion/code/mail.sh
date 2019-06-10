#/bin/bash

mailfrom='rudi@sme-nds.de'
mailsub='Dein Registrierungscode fuer die erste Kammer des Staendigen Mitgliederentscheids der Piraten Niedersachsen'

mailtext="Hallo #Name,  
Deine Registrierungscode fuer http://www.sme-nds.de/ lautet: 

#regkey  

Bitte besuche  

http://www.sme-nds.de/index/register.html?invite=#regkey 

um Dich dort anzumelden, und Dein Vorschlags- und Stimmrecht  
nach Paragraph 13b der Landessatzung wahrzunehmen.  

Beste Gruesse,  
Rudi (Beauftragter des LVs) 

ps: Falls Du Dich vor Deiner Anmeldung informieren moechtest, 
findet Du in der Newsbox auf https://wiki.piratenpartei.de/NDS:PG_SME 
einige interessante Links. 

"

 

fromdate=`echo "select date(max(modtime) ) from import;" | psql -U companion -t companion`

echo $fromdate

cmd="select comp_name2,comp_emailaddress,regkey from import where comp_user_stimmbaustein='Ja' and modtime>='$fromdate' and comp_emailaddress like '%@%';"

#echo $cmd

OIFS="$IFS" ; IFS=$'\n' ; oset="$-" ; set -f

while IFS="$OIFS" read -a line 
do 
  echo ${line[0]}   
  echo ${line[1]}   
  echo ${line[2]}
  echo ${line[3]}
  echo ${line[4]}
  sleep 10
echo "$mailtext" | sed s/#Name/${line[0]}/g | sed s/#regkey/${line[4]}/g | base64 |  mail -aFrom:rudi@sme-nds.de -a"Mime-Version:1.0" -a"Content-Type: text/plain; charset=UTF-8" -a"Content-Transfer-Encoding: base64" -s $mailsub  ${line[2]} 

done < <(echo $cmd |  psql -U companion -t companion)

