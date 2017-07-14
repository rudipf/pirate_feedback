-- extensions after Jun 2017
-- to be included in core.sql

create table member_delegation_limits (
member_id integer PRIMARY KEY,
limit_outgoing int default 1000,
limit_incomming int default 1000);

create or replace function get_top_delegatees (In aread_id int)
Returns Table (member_id int , del float) AS $$

 select member_id , sum(weight)/10.0
from (
select Un.issue_id, Un.member_id, max(weight*abs(sign(grade))) weight
from
(select issue_id, member_id , weight from direct_voter
union
select issue_id, member_id , 1 as weight from delegating_voter ) Un
join vote v on Un.issue_id=v.issue_id and Un.member_id=v.member_id
where Un.issue_id in (select id from issue where (area_id=$1 or $1=-1) 
and closed is not NULL and voter_count>=1 order by id desc limit 10)
group by Un.issue_id, Un.member_id ) Sub
where weight >1
group by member_id 
order by 2 desc
limit 5
$$ LANGUAGE SQL;

create or replace function get_delegation_recommendation(In member_id integer, in area integer, in novote  integer DEFAULT 0, in commonlimit numeric  DEFAULT 0.75 )
RETURNS TABLE ( member_id int, delegate int, diff bigint, commonvotes double precision,ratio double precision)  AS $$
select member_id, member_id2 as delegate, sum(abs(grade-coalesce(grade2,$2))) diff, sum(coalesce(sign(abs(grade2)),0)) commonvotes,  (sum(1.0*abs(grade-coalesce(grade2,$3))))/sum(coalesce(sign(abs(grade2)),$3)) ratio
from
(
select r.member_id, r.grade, r.issue_id, r.initiative_id ,dm.member_id member_id2,
	(select grade from vote v where v.initiative_id=r.initiative_id and v.member_id=dm.member_id) grade2
from (select v.*
from direct_voter dv join vote v  on dv.issue_id=v.issue_id and dv.member_id=v.member_id) r 
join (select distinct v.member_id from vote v join direct_voter d using(issue_id) where d.member_id=$1 and v.grade!=0) dm on true 
join issue i on r.issue_id=i.id and (i.area_id=$2 or $2=-1)
where r.member_id=$1
) Sub
group by member_id, member_id2
having sum(coalesce(sign(abs(grade2)),0))>=count(1)*$4
order by 5
$$ LANGUAGE SQL;


alter table policy add column readjust_timing boolean default false;
alter table issue add column readjust_timing boolean default false;

--

CREATE or replace FUNCTION "copy_timings_trigger"()
  RETURNS TRIGGER
  LANGUAGE 'plpgsql' VOLATILE AS $$
    DECLARE
      "policy_row" "policy"%ROWTYPE;
    BEGIN
      SELECT * INTO "policy_row" FROM "policy"
        WHERE "id" = NEW."policy_id";
      IF NEW."admission_time" ISNULL THEN
        NEW."admission_time" := "policy_row"."admission_time";
      END IF;
      IF NEW."discussion_time" ISNULL THEN
        NEW."discussion_time" := "policy_row"."discussion_time";
      END IF;
      IF NEW."verification_time" ISNULL THEN
        NEW."verification_time" := "policy_row"."verification_time";
      END IF;
      IF NEW."voting_time" ISNULL THEN
        NEW."voting_time" := "policy_row"."voting_time";
      END IF;
	  NEW."readjust_timing":="policy_row"."readjust_timing";
      RETURN NEW;
    END;
$$;


create or replace function public.adjust_timings_trigger()
Returns trigger
Language 'plpgsql'
as $$

declare org_datetime timestamp;
declare target_datetime timestamp;
declare orgts double precision ;
declare targets double precision ;
begin
if Old.state='admission' and New.state='discussion' and New.readjust_timing then

org_datetime:=(current_timestamp)+New.discussion_time+New.verification_time+New.voting_time;
target_datetime:=cast(org_datetime as date) + cast(7-extract(dow from org_datetime) as int) + (time '15:00');
orgts:=extract(epoch from New.discussion_time+New.verification_time+New.voting_time);
targets:=extract(epoch from target_datetime-current_timestamp);

New.discussion_time:=targets/orgts*new.discussion_time;
New.verification_time:=targets/orgts*new.verification_time;
New.voting_time:=targets/orgts*new.voting_time;

end if;
  
return NEW;
end;
$$;
  
create trigger adjust_timings before update on issue 
 for each row execute procedure adjust_timings_trigger();

