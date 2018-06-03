create table import (
comp_name varchar(255), 
comp_name2 varchar(255), 
comp_user_schwebend varchar(255), 
comp_user_mitgliedsnummer varchar(255) not NULL unique,
comp_emailaddress varchar(255) ,
comp_user_mailbounce varchar(255),
comp_user_ov varchar(255) ,
comp_user_stimmbaustein varchar(255),
regkey varchar(255) unique,
isactive integer,
modtime timestamp DEFAULT current_timestamp )

create or replace function checkmember(varchar(255) , varchar(255) , varchar(255) ,varchar(255) ,varchar(255) ,varchar(255) ,varchar(255) ,varchar(255) ) 
returns integer
Language 'plpgsql'
as $$
begin
if exists (select 1 from import where comp_user_mitgliedsnummer =$4) then
update import set
comp_name= $1,
comp_name2= $2,
comp_user_schwebend=$3, 
-- comp_user_mitgliedsnummer=$4, 
comp_emailaddress= $5,
comp_user_mailbounce=$6,
comp_user_ov= $7,
comp_user_stimmbaustein= $8
where comp_user_mitgliedsnummer=$4;
else
insert into import ( comp_name,comp_name2,comp_user_schwebend,comp_user_mitgliedsnummer,comp_emailaddress,comp_user_mailbounce,comp_user_ov,comp_user_stimmbaustein ,regkey)
select $1,$2,$3,$4,$5,$6,$7,$8, md5(timeofday()::varchar||pg_backend_pid()::varchar||23::varchar );
end if;
return 1;
end;
$$ ;
