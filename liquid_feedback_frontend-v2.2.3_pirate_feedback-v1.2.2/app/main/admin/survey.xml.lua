stack={}
istack=1

slot.set_layout("xml", "application/octet-stream")

function xmls(tag,content) 
stack[istack]=tag
istack=istack+1
if content then
slot.put_into("default",'<'..tag..'>'..content)
else
slot.put_into("default",'<'..tag..'>')
end
return stack,istack
end

function xmle(a) 
istack=istack-1
slot.put_into("default",'</'..stack[istack]..'>\n')
end

local sql=[[
select ini.id as ini_id, isu.id as issue_id 
from initiative ini ,issue isu 
where ini.issue_id=isu.id 
and area_id=]]
sql=sql..config.survey_area.." and policy_id="..config.survey_policy
sql=sql.." and winner=true"
sql=sql.." and closed>'"..tostring(param.get("startdate",atom.date)).."'"
sql=sql.." order by isu.id,ini.id"
sql=sql.." limit "..config.survey_maxitems

local inis=db:query(sql,"list")

--slot.put_into("default",tostring(param.get("startdate",atom.date)) )

slot.put_into("default",[=[<?xml version="1.0" encoding="UTF-8"?>]=])

xmls("document","")
xmls("LimeSurveyDocType","Survey")
xmle()
xmls("DBVersion","347")
xmle()
xmls("languages","")
xmls("language","de")
xmle()
xmle()
xmls("groups","")
xmls("fields","")
xmls("fieldname","gid")
xmle()
xmls("fieldname","sid")
xmle()
xmls("fieldname","group_name")
xmle()
xmls("fieldname","group_order")
xmle()
xmls("fieldname","description")
xmle()
xmls("fieldname","language")
xmle()
xmls("fieldname","randomization_group")
xmle()
xmls("fieldname","grelevance")
xmle()
xmle()
xmls("rows","")
xmls("row","")
xmls("gid","<![CDATA[1]]>")
xmle()
xmls("sid","<![CDATA[165353]]>")
xmle()
xmls("group_name","<![CDATA[Beschlüsse der zweiten Kammer des SME]]>")
xmle()
xmls("group_order","<![CDATA[0]]>")
xmle()
xmls("description","")
xmle()
xmls("language","<![CDATA[de]]>")
xmle()
xmls("randomization_group","")
xmle()
xmls("grelevance","")
xmle()
xmle()
xmle()
xmle()
xmls("questions","")
xmls("fields","")
xmls("fieldname","qid")
xmle()
xmls("fieldname","parent_qid")
xmle()
xmls("fieldname","sid")
xmle()
xmls("fieldname","gid")
xmle()
xmls("fieldname","type")
xmle()
xmls("fieldname","title")
xmle()
xmls("fieldname","question")
xmle()
xmls("fieldname","preg")
xmle()
xmls("fieldname","help")
xmle()
xmls("fieldname","other")
xmle()
xmls("fieldname","mandatory")
xmle()
xmls("fieldname","question_order")
xmle()
xmls("fieldname","language")
xmle()
xmls("fieldname","scale_id")
xmle()
xmls("fieldname","same_default")
xmle()
xmls("fieldname","relevance")
xmle()
xmls("fieldname","modulename")
xmle()
xmle()
xmls("rows","")

mail_text=""

-- question/initiative loop 
for i,ini in ipairs(inis) do 

local initiative = Initiative:by_id(ini[1])
local questiontext=initiative.current_draft:get_content("html")

xmls("row","")
local inititle="<b>PP SME "..initiative.id.." ("..initiative.name..")</b></p>"
mail_text=mail_text.."<a href=https://www.sme-nds.de/initiative/show/"..initiative.id..".html>PP SME "..initiative.id.." ("..initiative.name..")</a></p>"

xmls("qid","<![CDATA["..initiative.id.."]]>")
xmle()
xmls("parent_qid","<![CDATA[0]]>")
xmle()
xmls("sid","<![CDATA[165353]]>")
xmle()
xmls("gid","<![CDATA[1]]>")
xmle()
xmls("type","<![CDATA[Y]]>")
xmle()
xmls("title","<![CDATA[A]]>")
xmle()
xmls("question","<![CDATA["..inititle..questiontext.."]]>")
xmle()
xmls("preg","")
xmle()
xmls("help","<![CDATA[Stimmst Du für den obigen Text ? ]]>")
xmle()
xmls("other","<![CDATA[N]]>")
xmle()
xmls("mandatory","<![CDATA[N]]>")
xmle()
xmls("question_order","<![CDATA[1]]>")
xmle()
xmls("language","<![CDATA[de]]>")
xmle()
xmls("scale_id","<![CDATA[0]]>")
xmle()
xmls("same_default","<![CDATA[0]]>")
xmle()
xmls("relevance","<![CDATA[1]]>")
xmle()
xmls("modulename","")
xmle()
xmle()

end

-- question loop end
xmle()
xmle()
xmls("surveys","")
xmls("fields","")
xmls("fieldname","sid")
xmle()
xmls("fieldname","gsid")
xmle()
xmls("fieldname","admin")
xmle()
xmls("fieldname","expires")
xmle()
xmls("fieldname","startdate")
xmle()
xmls("fieldname","adminemail")
xmle()
xmls("fieldname","anonymized")
xmle()
xmls("fieldname","faxto")
xmle()
xmls("fieldname","format")
xmle()
xmls("fieldname","savetimings")
xmle()
xmls("fieldname","template")
xmle()
xmls("fieldname","language")
xmle()
xmls("fieldname","additional_languages")
xmle()
xmls("fieldname","datestamp")
xmle()
xmls("fieldname","usecookie")
xmle()
xmls("fieldname","allowregister")
xmle()
xmls("fieldname","allowsave")
xmle()
xmls("fieldname","autonumber_start")
xmle()
xmls("fieldname","autoredirect")
xmle()
xmls("fieldname","allowprev")
xmle()
xmls("fieldname","printanswers")
xmle()
xmls("fieldname","ipaddr")
xmle()
xmls("fieldname","refurl")
xmle()
xmls("fieldname","publicstatistics")
xmle()
xmls("fieldname","publicgraphs")
xmle()
xmls("fieldname","listpublic")
xmle()
xmls("fieldname","htmlemail")
xmle()
xmls("fieldname","sendconfirmation")
xmle()
xmls("fieldname","tokenanswerspersistence")
xmle()
xmls("fieldname","assessments")
xmle()
xmls("fieldname","usecaptcha")
xmle()
xmls("fieldname","usetokens")
xmle()
xmls("fieldname","bounce_email")
xmle()
xmls("fieldname","attributedescriptions")
xmle()
xmls("fieldname","emailresponseto")
xmle()
xmls("fieldname","emailnotificationto")
xmle()
xmls("fieldname","tokenlength")
xmle()
xmls("fieldname","showxquestions")
xmle()
xmls("fieldname","showgroupinfo")
xmle()
xmls("fieldname","shownoanswer")
xmle()
xmls("fieldname","showqnumcode")
xmle()
xmls("fieldname","bouncetime")
xmle()
xmls("fieldname","bounceprocessing")
xmle()
xmls("fieldname","bounceaccounttype")
xmle()
xmls("fieldname","bounceaccounthost")
xmle()
xmls("fieldname","bounceaccountpass")
xmle()
xmls("fieldname","bounceaccountencryption")
xmle()
xmls("fieldname","bounceaccountuser")
xmle()
xmls("fieldname","showwelcome")
xmle()
xmls("fieldname","showprogress")
xmle()
xmls("fieldname","questionindex")
xmle()
xmls("fieldname","navigationdelay")
xmle()
xmls("fieldname","nokeyboard")
xmle()
xmls("fieldname","alloweditaftercompletion")
xmle()
xmls("fieldname","googleanalyticsstyle")
xmle()
xmls("fieldname","googleanalyticsapikey")
xmle()
xmle()
xmls("rows","")
xmls("row","")
xmls("sid","<![CDATA[165353]]>")
xmle()
xmls("gsid","<![CDATA[1]]>")
xmle()
xmls("admin","")
xmle()
xmls("adminemail","")
xmle()
xmls("anonymized","<![CDATA[Y]]>")
xmle()
xmls("faxto","")
xmle()
xmls("format","<![CDATA[S]]>")
xmle()
xmls("savetimings","<![CDATA[N]]>")
xmle()
xmls("template","<![CDATA[fruity]]>")
xmle()
xmls("language","<![CDATA[de]]>")
xmle()
xmls("additional_languages","")
xmle()
xmls("datestamp","<![CDATA[N]]>")
xmle()
xmls("usecookie","<![CDATA[N]]>")
xmle()
xmls("allowregister","<![CDATA[N]]>")
xmle()
xmls("allowsave","<![CDATA[Y]]>")
xmle()
xmls("autonumber_start","<![CDATA[0]]>")
xmle()
xmls("autoredirect","<![CDATA[N]]>")
xmle()
xmls("allowprev","<![CDATA[N]]>")
xmle()
xmls("printanswers","<![CDATA[N]]>")
xmle()
xmls("ipaddr","<![CDATA[N]]>")
xmle()
xmls("refurl","<![CDATA[N]]>")
xmle()
xmls("publicstatistics","<![CDATA[N]]>")
xmle()
xmls("publicgraphs","<![CDATA[N]]>")
xmle()
xmls("listpublic","<![CDATA[N]]>")
xmle()
xmls("htmlemail","<![CDATA[N]]>")
xmle()
xmls("sendconfirmation","<![CDATA[N]]>")
xmle()
xmls("tokenanswerspersistence","<![CDATA[N]]>")
xmle()
xmls("assessments","<![CDATA[N]]>")
xmle()
xmls("usecaptcha","<![CDATA[N]]>")
xmle()
xmls("usetokens","<![CDATA[N]]>")
xmle()
xmls("bounce_email","")
xmle()
xmls("emailresponseto","")
xmle()
xmls("emailnotificationto","")
xmle()
xmls("tokenlength","<![CDATA[15]]>")
xmle()
xmls("showxquestions","<![CDATA[Y]]>")
xmle()
xmls("showgroupinfo","<![CDATA[B]]>")
xmle()
xmls("shownoanswer","<![CDATA[Y]]>")
xmle()
xmls("showqnumcode","<![CDATA[X]]>")
xmle()
xmls("bounceprocessing","<![CDATA[N]]>")
xmle()
xmls("showwelcome","<![CDATA[Y]]>")
xmle()
xmls("showprogress","<![CDATA[Y]]>")
xmle()
xmls("questionindex","<![CDATA[1]]>")
xmle()
xmls("navigationdelay","<![CDATA[0]]>")
xmle()
xmls("nokeyboard","<![CDATA[N]]>")
xmle()
xmls("alloweditaftercompletion","<![CDATA[N]]>")
xmle()
xmle()
xmle()
xmle()
xmls("surveys_languagesettings","")
xmls("fields","")
xmls("fieldname","surveyls_survey_id")
xmle()
xmls("fieldname","surveyls_language")
xmle()
xmls("fieldname","surveyls_title")
xmle()
xmls("fieldname","surveyls_description")
xmle()
xmls("fieldname","surveyls_welcometext")
xmle()
xmls("fieldname","surveyls_endtext")
xmle()
xmls("fieldname","surveyls_url")
xmle()
xmls("fieldname","surveyls_urldescription")
xmle()
xmls("fieldname","surveyls_email_invite_subj")
xmle()
xmls("fieldname","surveyls_email_invite")
xmle()
xmls("fieldname","surveyls_email_remind_subj")
xmle()
xmls("fieldname","surveyls_email_remind")
xmle()
xmls("fieldname","surveyls_email_register_subj")
xmle()
xmls("fieldname","surveyls_email_register")
xmle()
xmls("fieldname","surveyls_email_confirm_subj")
xmle()
xmls("fieldname","surveyls_email_confirm")
xmle()
xmls("fieldname","surveyls_dateformat")
xmle()
xmls("fieldname","surveyls_attributecaptions")
xmle()
xmls("fieldname","email_admin_notification_subj")
xmle()
xmls("fieldname","email_admin_notification")
xmle()
xmls("fieldname","email_admin_responses_subj")
xmle()
xmls("fieldname","email_admin_responses")
xmle()
xmls("fieldname","surveyls_numberformat")
xmle()
xmls("fieldname","attachments")
xmle()
xmle()
xmls("rows","")
xmls("row","")
xmls("surveyls_survey_id","<![CDATA[165353]]>")
xmle()
xmls("surveyls_language","<![CDATA[de]]>")
xmle()
xmls("surveyls_title","<![CDATA[2.Kammer des Ständigen Mitgliederentscheids der Piratenpartei Niedersachsen im "..os.date("%B").." "..os.date("%Y").."]]>")
xmle()
xmls("surveyls_description","<![CDATA[Anträge nach <a href=https://wiki.piratenpartei.de/NDS:Satzung#.C2.A7_13b_Der_st.C3.A4ndige_Mitgliederentscheid> §13(b) der Landessatzung</a>]]>")
xmle()
xmls("surveyls_welcometext","<![CDATA[Die folgenden Anträge wurden in <a href=https://www.sme-nds.de>der ersten Kammer des SME</a> angenommen und können jetzt von Dir in der zweiten Kammer abgesimmt werden. Du kannst ihnen zustimmen, sie ablehnen oder Dich bei einzelnen Anträgen enthalten. Sie gelten als angenommen und stehen dann Positionspapieren der Landesmitgliederversammlung gleich, wenn eine Mehrheit der abgegebenen gültigen Stimmen íhnen zustimmt. (Also mehr Ja als Nein Stimmen). ]]>")
xmle()
xmls("surveyls_endtext","<![CDATA[Vielen Dank für Deine Teilnahme.]]>")
xmle()
xmls("surveyls_url","")
xmle()
xmls("surveyls_email_invite_subj","<![CDATA[Einladung zur Abstimmung in der 2.Kammer des SME]]>")
xmle()

xmls("surveyls_email_invite",[=[<![CDATA[Ahoi {FIRSTNAME},<br />
<br />
Ich möchte Dich als Beauftragter für den Ständigen Mitgliederentscheid der Piratenpartei Noiedersachsen einladen Deine Stimme in der zweiten Kammer abzugeben.<br />
Die folgenden Anträge stehen zur Abstimmung, da Sie in der ersten Kammer beschlossen worden sind.</p> 
]=]..mail_text..[=[
Um Deine Stimme abzugeben, klicke bitte auf den folgenden Link:<br />
<br />
{SURVEYURL}<br />

mit freundlichen Grüßen,
Rüdiger (Rudi) Pfeilsticker
(pfeilsticker@freenet.de)

]]>]=])
xmle()
xmls("surveyls_email_remind_subj","<![CDATA[Reminder to participate in a survey]]>")
xmle()
xmls("surveyls_email_remind",[=[<![CDATA[Dear {FIRSTNAME},<br />
<br />
Recently we invited you to participate in a survey.<br />
<br />
We note that you have not yet completed the survey, and wish to remind you that the survey is still available should you wish to take part.<br />
<br />
The survey is titled:<br />
"{SURVEYNAME}"<br />
<br />
"{SURVEYDESCRIPTION}"<br />
<br />
To participate, please click on the link below.<br />
<br />
Sincerely,<br />
<br />
{ADMINNAME} ({ADMINEMAIL})<br />
<br />
----------------------------------------------<br />
Click here to do the survey:<br />
{SURVEYURL}<br />
<br />
If you do not want to participate in this survey and don't want to receive any more invitations please click the following link:<br />
{OPTOUTURL}]]>]=])
xmle()
xmls("surveyls_email_register_subj","<![CDATA[Survey registration confirmation]]>")
xmle()
xmls("surveyls_email_register",[=[<![CDATA[Dear {FIRSTNAME},<br />
<br />
You, or someone using your email address, have registered to participate in an online survey titled {SURVEYNAME}.<br />
<br />
To complete this survey, click on the following URL:<br />
<br />
{SURVEYURL}<br />
<br />
If you have any questions about this survey, or if you did not register to participate and believe this email is in error, please contact {ADMINNAME} at {ADMINEMAIL}.]]>]-])
xmle()
xmls("surveyls_email_confirm_subj","<![CDATA[Confirmation of your participation in our survey]]>")
xmle()
xmls("surveyls_email_confirm",[-[<![CDATA[Dear {FIRSTNAME},<br />
<br />
this email is to confirm that you have completed the survey titled {SURVEYNAME} and your response has been saved. Thank you for participating.<br />
<br />
If you have any further questions about this email, please contact {ADMINNAME} on {ADMINEMAIL}.<br />
<br />
Sincerely,<br />
<br />
{ADMINNAME}]]>]=])
xmle()
xmls("surveyls_dateformat","<![CDATA[3]]>")
xmle()
xmls("email_admin_notification_subj","<![CDATA[Response submission for survey {SURVEYNAME}]]>")
xmle()
xmls("email_admin_notification",[=[<![CDATA[Hello,<br />
<br />
A new response was submitted for your survey '{SURVEYNAME}'.<br />
<br />
Click the following link to see the individual response:<br />
{VIEWRESPONSEURL}<br />
<br />
Click the following link to edit the individual response:<br />
{EDITRESPONSEURL}<br />
<br />
View statistics by clicking here:<br />
{STATISTICSURL}]]>]=])
xmle()
xmls("email_admin_responses_subj","<![CDATA[Response submission for survey {SURVEYNAME} with results]]>")
xmle()
xmls("email_admin_responses",[=[<![CDATA[Hello,<br />
<br />
A new response was submitted for your survey '{SURVEYNAME}'.<br />
<br />
Click the following link to see the individual response:<br />
{VIEWRESPONSEURL}<br />
<br />
Click the following link to edit the individual response:<br />
{EDITRESPONSEURL}<br />
<br />
View statistics by clicking here:<br />
{STATISTICSURL}<br />
<br />
<br />
The following answers were given by the participant:<br />
{ANSWERTABLE}]]>]=])
xmle()
xmls("surveyls_numberformat","<![CDATA[0]]>")
xmle()
xmle()
xmle()
xmle()

while istack>1
do
xmle()
end

