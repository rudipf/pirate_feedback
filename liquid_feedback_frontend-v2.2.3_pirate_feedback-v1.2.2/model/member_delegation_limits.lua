
member_delegation_limits = mondelefant.new_class()
member_delegation_limits.table= 'member_delegation_limits'
member_delegation_limits.primary_key={"member_id"}

member_delegation_limits:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

function member_delegation_limits:by_pk(member_id)
  return self:new_selector()
    :add_where{ "member_id = ?", member_id }
    :optional_object_mode()
    :exec()
end

