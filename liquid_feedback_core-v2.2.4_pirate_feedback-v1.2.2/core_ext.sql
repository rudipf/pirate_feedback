-- extensions after Jun 2017
-- to be included in core.sql

create table member_delegation_limits (
member_id integer PRIMARY KEY,
limit_outgoing int default 1000,
limit_incomming int default 1000);

