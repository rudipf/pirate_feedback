MemberDelegationLimits = mondelefant.new_class()
MemberDelegationLimits.table= 'member_delegation_limits'
MemberDelegationLimits.primary_key={"member_id"}

MemberDelegationLimits:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

function MemberDelegationLimits:by_pk(member_id)

local t=db:query("insert into member_delegation_limits (member_id,limit_outgoing,limit_incomming) select "..member_id..","..config.default_member_delegation..","..config.default_member_delegation.." where not exists (select 1 from member_delegation_limits where member_id="..member_id..");" )
  return self:new_selector()
    :add_where{ "member_id = ?", member_id }
    :optional_object_mode()
    :exec()
end

function MemberDelegationLimits:helper(limit, conf)
 local l=conf
 if limit then 
    if limit >=0 and limit <= conf then
        l=limit
    end
  end
return l
end
