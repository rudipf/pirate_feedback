
limit_outgoing=param.get("limit_outgoing", atom.integer)
limit_incomming=param.get("limit_incomming", atom.integer)

if limit_outgoing then
 if limit_outgoing <0 then
  limit_outgoing=config.default_member_delegation
 end
 if limit_outgoing>config.max_delegations_given then
  limit_outgoing=config.max_delegations_given
 end
 if limit_outgoing~=config.default_member_delegation and limit_outgoing < Delegation:countanyout(app.session.member.id) then 
  slot.put_into("error", _"You already gave more delegations, remove some first")
  return false 
 end
end

if limit_incomming then
 if limit_incomming <0 then
  limit_incomming=config.default_member_delegation
 end
 if limit_incomming>config.max_delegations_recieved then
  limit_incomming=config.max_delegations_recieved
 end
 if limit_incomming~=config.default_member_delegation and limit_incomming < Delegation:countanyin(app.session.member.id) then
  slot.put_into("error", _"You already recieved more delegations, remove some first")
  return false
 end
end

member_id=app.session.member_id

if member_id then
db:query{ "delete from member_delegation_limits where member_id= ? ;", member_id}
db:query{ "insert into member_delegation_limits values (?,?,?); ",member_id, limit_outgoing, limit_incomming }

end


