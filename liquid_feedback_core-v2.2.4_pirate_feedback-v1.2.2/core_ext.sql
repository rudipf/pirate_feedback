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
