-- displays the head bar of an area


local area = param.get("area", "table")
local member = param.get("member", "table")

local show_content = param.get("show_content", atom.boolean)
local for_listing = param.get("for_listing", atom.boolean)

if app.session.member_id then
  area:load_delegation_info_once_for_member_id(app.session.member_id)
end

if not param.get("hide_unit", atom.boolean) then
  execute.view{ module = "unit", view = "_head", params = { unit = area.unit, member = member } }
end

ui.container{ attr = { class = "area_head" }, content = function()

  -- area name
  ui.container{ attr = { class = "left" }, content = function()
    ui.container{ attr = { class = "title" }, content = function()
      ui.link{
        module = "area", view = "show", id = area.id,
        attr = { class = "area_name" }, content = area.name
      }
    end }
    if show_content and not for_listing and area.description ~= "" then
      ui.container{ attr = { class = "content" }, content = area.description }
    end
  end }

if show_content and member and config.display_area_stats then
ui.link {
module="area_statistics",view="show",id=area.id,
        attr = { class = "content" },content="Stats"
}
end


  -- area delegation
  if area.delegation then
    execute.view{ module = "delegation", view = "_info", params = { area = area, member = member } }
  end

  if show_content then

    -- actions (members with appropriate voting right only)
    if member then

      ui.container{ attr = { class = "content right clear_right" }, content = function()

        -- membership
        local membership = Membership:by_pk(area.id, member.id)
        if membership then
          if app.session.member_id == member.id then
            ui.tag{ content = _"You are participating in this area." }
            slot.put(" ")
            ui.tag{ content = function()
              slot.put("(")
              ui.link{
                text    = _"Withdraw",
                module  = "membership",
                action  = "update",
                params  = { area_id = area.id, delete = true },
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
            end }
          else
            ui.tag{ content = _"Member is participating in this area." }
          end
        elseif app.session.member_id == member.id and member:has_voting_right_for_unit_id(area.unit_id) then
          ui.link{
            text   = _"Participate in this area",
            module = "membership",
            action = "update",
            params = { area_id = area.id },
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
        end

        -- create new issue
        if not for_listing and app.session.member_id == member.id and app.session.member:has_voting_right_for_unit_id(area.unit_id) then
          slot.put(" &middot; ")
          ui.link{
            content = function()
              slot.put(_"Create new issue")
            end,
            module = "initiative",
            view = "new",
            params = { area_id = area.id }
          }
        end

      end }

    end

    if for_listing then

      ui.container{ attr = { class = "content left clear_left" }, content = function()
        ui.tag{ content = _"Issues:" }
        slot.put(" ")
        ui.link{
          module = "area", view = "show", id = area.id, params = { tab = "open", filter = "new" },
          text = _("#{count} new", { count = area.issues_new_count })
        }
        slot.put(" &middot; ")
        ui.link{
          module = "area", view = "show", id = area.id, params = { tab = "open", filter = "accepted" },
          text = _("#{count} in discussion", { count = area.issues_discussion_count })
        }
        slot.put(" &middot; ")
        ui.link{
          module = "area", view = "show", id = area.id, params = { tab = "open", filter = "half_frozen" },
          text = _("#{count} in verification", { count = area.issues_frozen_count })
        }
        slot.put(" &middot; ")
        ui.link{
          module = "area", view = "show", id = area.id, params = { tab = "open", filter = "frozen", filter_voting = "any" },
          text = _("#{count} in voting", { count = area.issues_voting_count })
        }
        if member then
          slot.put(" (")
          ui.link{
            module = "area", view = "show", id = area.id, params = { tab = "open", filter = "frozen" },
            text = _("#{count} not voted", { count = area.issues_to_vote_count })
          }
          slot.put(")")
        end
        slot.put(" &middot; ")
        ui.link{
          module = "area", view = "show", id = area.id, params = { tab = "closed", filter = "finished" },
          text = _("#{count} finished", { count = area.issues_finished_count })
        }
        slot.put(" &middot; ")
        ui.link{
          module = "area", view = "show", id = area.id, params = { tab = "closed", filter = "canceled" },
          text = _("#{count} canceled", { count = area.issues_canceled_count })
        }
      end }

    end

  end

end }
