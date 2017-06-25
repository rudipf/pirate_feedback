ui.title (_"Change your delegation limits")

util.help("settings_member_delegation_limits",_"Change delegation limits")

local limits =MemberDelegationLimits:by_pk(app.session.member_id,member_id)

-- db_query{"select  ?,?", limits.limit_outgoing, limits.limit_incomming}

if not limits or not limits.limit_outgoing then
   limit_outgoing=config.default_member_delegation
else 
   limit_outgoing=limits.limit_outgoing
end
if not limits or not limits.limit_incomming then
   limit_incomming=config.default_member_delegation
else
   limit_incomming=limits.limit_incomming
end

ui.form{
	module="member",
	action="update_member_delegation_limits",
	content=function()
		ui.field.text{ label=_"limit_outgoing", name ="limit_outgoing", value= limit_outgoing }
	 	ui.field.text{ label=_"limit_incomming", name ="limit_incomming", value=limit_incomming}	
		ui.submit{ value=_"Change limits" }
end
}

--local c=Delegation:countanyout(app.session.member_id)

--local d=Delegation:countanyin(app.session.member_id)
--slot.put(_"X"..c.."X"..d)
-- slot.put(Delegation:countanyin(app.session.member_id))


