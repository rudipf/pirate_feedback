stack={}
istack=1

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
if( stack[istack]) then
slot.put_into("default",'</'..stack[istack]..'>\n')
end
end

----

function data(tablen, col, key)
sql="select column_name from information_schema.columns where table_name='"..tablen.."' order by case when column_name='"..col.."' then '0' else column_name end;"

local cols=db:query(sql,"list")

local mtt = {}
mtt[1]=1

sql="select "
l=1
for i,k in ipairs(cols) do
 sql=sql..k[1].."::varchar, "
 --slot.put_into("default",i.."x "..k[1].."</p> ")
 table.insert(mtt,i,k[1])
 l=l+1
end

sql=sql.."'NULL' as BLANKO from "..tablen.." where "..col.."="..key..";"

--slot.put_into("default",sql)

res=db:query(sql,"list")

sql="select description from pg_catalog.pg_statio_all_tables as st inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid) where objsubid='0' and relname='"..tablen.."';"
com=db:query(sql,"list")


xmls("Tabelle","")
xmls("Tabellenname",tablen)
xmle()

for i,k in ipairs(com) do
xmls("TableComment", k[1])
xmle()
end


for i,k in ipairs(res) do
    xmls("Datensatz","" )
    xmls("Datensatznummer",i)
    xmle()
    for j,jj in ipairs(mtt) do
      if (mtt[j] ~=1 ) then
      xmls(mtt[j], "<![CDATA["..tostring(k[mtt[j]]).."]]>")
      --slot.put_into("default",mtt[j].." "..tostring(k[mtt[j]]).." </p> ")
      xmle()
      end
    end
    xmle()
end

xmle()
end
----

local id = param.get_id()

local member = Member:by_id(id)


stack={}
istack=1
slot.set_layout("xml", "application/octet-stream")
slot.put_into("default",[=[<?xml version="1.0" encoding="UTF-8"?>]=])

xmls("document","")

data("member","id",id)

data("member_delegation_limits","member_id",id)

data("notify","member_id",id)

data("member_history","member_id",id)

data("rendered_member_statement","member_id",id)
data("setting","member_id",id)
data("member_relation_setting","member_id",id)
data("member_image","member_id",id)
data("contact","member_id",id)
data("contact","other_member_id",id)

data("ignored_member","member_id",id)
data("ignored_member","other_member_id",id)
data("session","member_id",id)
data("unit_setting","member_id",id)
data("area_setting","member_id",id)
data("issue_setting","member_id",id)
data("initiative","revoked_by_member_id",id)
data("ignored_initiative","member_id",id)
data("initiative_setting","member_id",id)
data("draft","author_id",id)
data("suggestion","author_id",id)
data("suggestion_setting","member_id",id)
data("argument","author_id",id)
data("privilege","member_id",id)
data("membership","member_id",id)
data("interest","member_id",id)
data("initiator","member_id",id)
data("supporter","member_id",id)
data("opinion","member_id",id)
data("rating","member_id",id)
data("delegation","truster_id",id)
data("delegation","trustee_id",id)
data("direct_population_snapshot","member_id",id)
data("delegating_population_snapshot","member_id",id)
data("direct_interest_snapshot","member_id",id)
data("delegating_interest_snapshot","member_id",id)
data("direct_supporter_snapshot","member_id",id)
data("non_voter","member_id",id)
data("direct_voter","member_id",id)
data("rendered_voter_comment","member_id",id)
data("delegating_voter","member_id",id)
data("delegating_voter","delegate_member_id",id)
data("vote","member_id",id)
data("event","member_id",id)





xmle()

