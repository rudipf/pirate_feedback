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
