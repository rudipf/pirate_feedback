#/bin/bash

mailfrom='rudi@sme-nds.de'
mailsub='Zur Erinnerung: Dein Registrierungscode fuer die erste Kammer des Staendigen Mitgliederentscheids der Piraten Niedersachsen'

mailtext="Hallo #Name,  
Deine Registrierungscode fuer http://www.sme-nds.de/ lautet: 

#regkey  

Bitte besuche  

https://www.sme-nds.de/index/register.html?invite=#regkey 

um Dich dort anzumelden, und Dein Vorschlags- und Stimmrecht  
nach Paragraph 13b der Landessatzung wahrzunehmen.  

Beste Gruesse,  
Rudi (Beauftragter des LVs) 

ps: Falls Du Dich vor Deiner Anmeldung informieren moechtest, 
findet Du in der Newsbox auf https://wiki.piratenpartei.de/NDS:PG_SME 
einige interessante Links. 
pps: Diese Erinnerung erreicht Dich auch, weil ein Teil der Einladungen
vor einer Woche nicht erfolgreich verschickt werden konnte.

"

 

fromdate='2018-11-01'
echo $fromdate

includes=`su www-data -c "psql pirate_feedback -t -c 'select invite_code from member where active = false;'" | awk ' { a="'"'"'"; if ($0 ~ "a"){ sub(" ","",$0);print a$0a"," }}' `

andclause=" and comp_emailaddress='junghaenel-hannover@gmx.de' "
#andclause=" and comp_emailaddress like 'u%' "
#andclause=" and comp_name2 like '% %' "
cmd="select replace(comp_name2,' ','_'),comp_emailaddress,regkey from import where comp_user_stimmbaustein='Ja' "$andclause" and modtime>='$fromdate' and comp_emailaddress like '%@%' and regkey in ("$includes" '-xx');"

#echo $cmd


OIFS="$IFS" ; IFS=$'\n' ; oset="$-" ; set -f

while IFS="$OIFS" read -a line 
do
  toname=` echo ${line[0]} | sed s/'_'/' '/g ` 
  echo ${line[0]}" ... "$toname   
  echo ${line[1]}   
  echo ${line[2]}
  echo ${line[3]}
  echo ${line[4]}
  echo "end"
  sleep 30 
echo "$mailtext" | sed s/#Name/$toname/g | sed s/#regkey/${line[4]}/g | base64|  mail -aFrom:rudi@sme-nds.de -a"Mime-Version:1.0" -a"Content-Type: text/plain; charset=UTF-8" -a"Content-Transfer-Encoding: base64" -s $mailsub  ${line[2]} 

done < <(echo $cmd |  psql -U companion -t companion)

