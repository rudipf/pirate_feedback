local initiative = param.get("initiative", "table")
local supporter = Supporter:by_pk(initiative.id, app.session.member.id)

local routing = {
  default = {
    mode = "redirect",
    module = request.get_module(),
    view = request.get_view(),
    id = param.get_id_cgi(),
    params = param.get_all_cgi()
  }
}

if not initiative.issue.closed then

  if not initiative.issue.fully_frozen then
    if supporter then
      if not supporter:has_critical_opinion() then
        ui.tag{ content = function()
          ui.image{
            static = "icons/16/thumb_up_light_green.png"
          }
          if initiative.issue.closed then
            slot.put(_"You were supporter.")
          else
            slot.put(_"You are supporter.")
          end
        end }
      else
        ui.tag{ attr = { class = "potential_supporter" }, content = function()
          ui.image{
            static = "icons/16/thumb_up.png"
          }
          if initiative.issue.closed then
            slot.put(_"You were potential supporter.")
          else
            slot.put(_"You are potential supporter.")
          end
        end }
      end
      slot.put(" (")
      ui.link{
        text    = _"Withdraw",
        module  = "initiative",
        action  = "remove_support",
        id      = initiative.id,
        routing = routing
      }
      slot.put(") &middot; ")
    elseif not initiative.revoked and app.session.member:has_voting_right_for_unit_id(initiative.issue.area.unit_id) then
      ui.link{
        text    = _"Support this initiative",
        module  = "initiative",
        action  = "add_support",
        id      = initiative.id,
        routing = routing
      }
      slot.put(" &middot; ")
    end
  end

  local ignored_initiative = IgnoredInitiative:by_pk(app.session.member.id, initiative.id)
  if ignored_initiative then
    ui.tag{
      content = _"You have ignored this initiative." .. " "
    }
    slot.put(" (")
    ui.link{
      text   = _"Stop ignoring initiative",
      module = "initiative",
      action = "update_ignore",
      id     = initiative.id,
      params = { delete = true },
      routing = {
        default = {
          mode = "redirect",
          module = request.get_module(),
          view = request.get_view(),
          id = param.get_id_cgi(),
          params = param.get_all_cgi()
        }
      }
    }
    slot.put(")")
  else
    ui.link{
      text    = _"Ignore initiative",
      module  = "initiative",
      action  = "update_ignore",
      id      = initiative.id,
      routing = {
        default = {
          mode = "redirect",
          module = request.get_module(),
          view = request.get_view(),
          id = param.get_id_cgi(),
          params = param.get_all_cgi()
        }
      },
      attr = { title = _"Ignoring an initiative means, that you don't get anymore email notifications about it." }
    }
  end

end
