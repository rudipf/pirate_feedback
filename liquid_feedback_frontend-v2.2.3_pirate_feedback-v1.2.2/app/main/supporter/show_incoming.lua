local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))
local issue = initiative.issue
local member = Member:by_id(param.get("member_id", atom.integer))

local members_selector = Member:new_selector()
  :join("delegating_interest_snapshot", nil, "delegating_interest_snapshot.member_id = member.id")
  :join("issue", nil, "issue.id = delegating_interest_snapshot.issue_id")
  :add_where{ "delegating_interest_snapshot.issue_id = ?", issue.id }
  :add_where{ "delegating_interest_snapshot.event = ?", issue.latest_snapshot_event }
  :add_where{ "delegating_interest_snapshot.delegate_member_id = ?", member.id }

ui.title(function()
  if member.id == app.session.member.id then
    -- show own delegation
    slot.put(_("Incoming delegations"))
  else
    -- show other member's delegation
    slot.put(_("Incoming delegations of member '#{member}'", { member = string.format('<a href="%s">%s</a>',
      encode.url{ module = "member", view = "show", id = member.id },
      encode.html(member.name)
    )}))
  end
end, issue.area.unit, issue.area, issue)

execute.view{
  module = "member",
  view = "_list",
  params = {
    members_selector = members_selector,
    issue = issue,
    trustee = member,
    show_delegation_link = true
  }
}